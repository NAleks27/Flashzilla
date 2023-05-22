//
//  CardView.swift
//  Flashzilla
//
//  Created by Aleksey Nosik on 12.05.2023.
//

import SwiftUI

// Double(abs(offSet.width / 50)) этот код весь дает единицу и соответственно 2 - 1 = 1 прозрачность (100%)
// для удаления карты плохим примером является то, чтобы дочернее вью пыталось изменить родительское, например удалить карту из массива карт (спагетти код)
// для этого мы создадим свойство с функциональным типом и в родительском вью (контент вью) будет передавать в данное вью кложур по удалению карты и здесь его вызывать

// Это нормально, сначала подготовить движок для вибрации, но потом не использовать, хоть это и садит сильнее батарейку. Система подготавливает и если не использовали его, через какое-то время отключает его и он не прогрет

// Нужно учитывать то, что если использовать вибрацию на каждую карточку то в долгосрочной перспективе это может быть раздражающим для пользователей, поэтому рекомендовано для нашего случая убрать вибрацию на успех, но оставить на неудачу

// Функция abs() технически описывает, насколько далеко число от нуля, не принимая во внимание, положительное оно или отрицательное.

struct CardView: View {
    let card: Card
//    var removal: (() -> Void)?                     // именно здесь объявляем свойство,
    
    var removal: (() -> Void)? = nil
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled

    @State private var feedback = UINotificationFeedbackGenerator()
    @State private var isShowingAnswer = false
    @State private var offSet = CGSize.zero          // по умолчанию нет перетаскивания (вращение и смещение тесно связаны)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(differentiateWithoutColor ? .white : .white.opacity(1 - Double(abs(offSet.width / 50))))
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(offSet.width >= 0 ? .green : .red)
                )
                .shadow(radius: 10)
            
            VStack {
                if voiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.promt)    // настраиваем чтобы в одном поле менялся вопрос на ответ для пользователя
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    Text(card.promt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offSet.width / 5)))
        .offset(x: offSet.width * 5, y: 0)              // двигать только влево или вправо но никогда верх и низ
        .opacity(2 - Double(abs(offSet.width / 50)))    // abs - from negative value to positive // 2 помогает оставаться карточке не сильно прозрачной при малейшем перетаскивании
        .accessibilityAddTraits(.isButton)                  // при озвучке будет говориться, то это кнопка для определенных людей
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offSet = gesture.translation            // перемещение до момента отпускания пальца
                    feedback.prepare()                      // подготовка вибрации
                }
                .onEnded { _ in
                    if abs(offSet.width) > 100 {            // abs нужно, так как при смещении влево будет минусовое значение и это никогда не было бы больше 100 
                        if offSet.width > 0 {
//                            feedback.notificationOccurred(.success)   // вибрация на успех
                        } else {
                            feedback.notificationOccurred(.error)   // вибрация на неудачу при этом возможны задержки с вибрацией если заранее не подготовить движок
                        }
                        removal?()
                    } else {
                        offSet = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.spring(), value: offSet)        // чтобы возврат карты на место был плавным 
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}
