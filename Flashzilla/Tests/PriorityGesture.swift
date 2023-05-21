//
//  PriorityGesture.swift
//  Flashzilla
//
//  Created by Aleksey Nosik on 10.05.2023.
//

import SwiftUI

struct PriorityGesture: View {
    @State private var offset = CGSize.zero         // где находится
    @State private var isDragging = false           // перетаскивается ли сейчас
    
    
    var body: some View {
        // создаем жест, который изменяет наши свойства стейт
        let dragGesture = DragGesture()             // жест перемещения
            .onChanged { value in
                offset = value.translation
            }
            .onEnded { _ in
                withAnimation {
                    offset = .zero
                    isDragging = false
                }
            }
        
        let pressGesture = LongPressGesture()        // жест нажатия долгого
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }
        
        let combined = pressGesture.sequenced(before: dragGesture)      // объединяем два жеста в связку
        
        Circle()
            .fill(.red)
            .frame(width: 64, height: 64)
            .scaleEffect(isDragging ? 1.5 : 1)          // если перетаскиваем, то используем 1,5, нет - 1
            .offset(offset)
            .gesture(combined)
        
        HStack {
            VStack {
                Text("Установленный приоритет")
                    .onTapGesture {
                        print("Text tapped")
                    }
            }
            .highPriorityGesture(
                TapGesture()
                    .onEnded {
                        print("VStack tapped")
                    }
            )
            
            Divider()
            
            // одновлеменный вызов жестов
            VStack {
                Text("Одновременный вызов двух жестов")
                    .onTapGesture {
                        print("Text tapped")
                    }
            }
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        print("VStack tapped")
                    }
            )
            
            
            // можно таксже сделать, чтобы один жест был доступен только после того, как был применен другой (пример мы задерживаем что-то, а затем можем перетащить это)
            
            
            
        }
        .padding()
    }
}

struct PriorityGesture_Previews: PreviewProvider {
    static var previews: some View {
        PriorityGesture()
    }
}
