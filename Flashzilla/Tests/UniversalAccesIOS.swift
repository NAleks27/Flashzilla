//
//  UniversalAccesIOS.swift
//  Flashzilla
//
//  Created by Aleksey Nosik on 11.05.2023.
//

import SwiftUI

// differentiateWithoutColor - для людей с проблемами цветовосприятия
// reduceMotion - уменьшение движения в самом приложении
// reduceTransparency - уменьшение прозрачности

// функция с дженериком (данная функция означает, что она будет выдавать ошибки если тело которое мы здесь сделали масштабируется)
// то есть если reduceMotion включено, то вызываем просто body, а если выключено, то body с анимацией
func withOptionalAnimation<Result> (_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
    if UIAccessibility.isReduceMotionEnabled {
        return try body()
    } else {
        return try withAnimation(animation, body)
    }
}

struct UniversalAccesIOS: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var scale = 1.0
    
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency

    
    var body: some View {
        VStack {
            HStack {
                if differentiateWithoutColor {
                    Image(systemName: "checkmark.circle")
                }
                
                Text("Success")
            }
            .padding()
            .background(differentiateWithoutColor ? .black : .green)
            .foregroundColor(.white)
            .clipShape(Capsule())
            
            
            Text("Hello world")
                .foregroundColor(.gray)
                .scaleEffect(scale)
                .onTapGesture {
//                    if reduceMotion {
//                        scale *= 1.5
//                    } else {
//                        withAnimation {
//                            scale *= 1.5
//                        }
//                    }
                    withOptionalAnimation {
                        scale *= 1.5
                    }
                }
            
            
            Text("Hello iOS")
                .padding()
                .background(reduceTransparency ? .black : .black.opacity(0.5))
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
    }
}

struct UniversalAccesIOS_Previews: PreviewProvider {
    static var previews: some View {
        UniversalAccesIOS()
    }
}
