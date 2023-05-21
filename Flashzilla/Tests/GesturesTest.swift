//
//  GesturesTest.swift
//  Flashzilla
//
//  Created by Aleksey Nosik on 10.05.2023.
//

import SwiftUI

// Жесты работают по принципу TRUE - FALSE - если нажато - запускаем кложур, отпускается - отключаем кложур. Если держим до запуска то выполняется TRUE -> FALSE -> Action (example onPressingChanged)
// .onTapGesture(count: 2) - количество нажатий для виполнения действия
// .onLongPressGesture(minimumDuration: 2)- длительное нажатие для виполнения действия c определенным кол-вом секунд


// Типы жестов:
// 1. Нажатие
// 2. Перетаскивание
// 3. Длительное нажатие
// 4. Увеличение
// 5. Вращение + жест нажатие


struct GesturesTest: View {
    @State private var currentAmount = 0.0
    @State private var finalAmount = 1.0
    
    @State private var currentAmountRotation = Angle.zero
    @State private var finalAmountRotation = Angle.zero

    
    var body: some View {
        VStack {
            Text("Test onTapGesture")
                .onTapGesture(count: 2) {
                    print("2 counts")
                }
            
            Text("Test onLongPressGesture")
                .onLongPressGesture(minimumDuration: 1) {
                    print("long press")
                } onPressingChanged: { inProgress in
                    print("In progress: \(inProgress)")
                }
        }
        
        // в данном случае мы увеличиваем общую шкалу на то на сколько увеличился объект и фиксируем новое начальное значение шкалы, чтобы сохранять приближение (как приближение фото в фотопленке) масштабируем с помощья зажатия опшин клавиши
        Text("Test MagnificationGesture")
            .scaleEffect(finalAmount + currentAmount)
            .gesture(
                MagnificationGesture()
                    .onChanged { amount in
                        currentAmount = amount - 1
                    }
                    .onEnded({ amount in
                        finalAmount += currentAmount
                        currentAmount = 0
                    })
            )
        
        // здесь работаем с углами
        Text("Test RotationGesture")
            .rotationEffect(finalAmountRotation + currentAmountRotation)
            .gesture(
                RotationGesture()
                    .onChanged { angle in
                        currentAmountRotation = angle
                    }
                    .onEnded({ angle in
                        finalAmountRotation += currentAmountRotation
                        currentAmountRotation = .zero
                    })
            )
    }
}

struct GesturesTest_Previews: PreviewProvider {
    static var previews: some View {
        GesturesTest()
    }
}
