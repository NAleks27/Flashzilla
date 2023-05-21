//
//  UserInteractivity.swift
//  Flashzilla
//
//  Created by Aleksey Nosik on 10.05.2023.
//

import SwiftUI

// 1. если указать .allowsHitTesting(false) то данное вью будет буд-то отсутствовать и при нажатии на него в нашем случае будет Rectangle
// 2. Если указать .contentShape(Rectangle()) то область доступа по нажатию на круг будет квадратная

struct UserInteractivity: View {
    var body: some View {
        HStack {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.blue)
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            print("Rectangle tapped!")
                        }
                    
                    Circle()
                        .fill(.red)
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            print("Circle tapped!")
                        }
                        .allowsHitTesting(false)                    // 1
                }
                
                ZStack {
                    Rectangle()
                        .fill(.green)
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            print("Rectangle tapped!")
                        }
                    
                    Circle()
                        .fill(.yellow)
                        .frame(width: 100, height: 100)
                        .contentShape(Rectangle())                  // 2
                        .onTapGesture {
                            print("Circle tapped!")
                        }
                }
            }
            
            Spacer()
                .frame(width: 100)
            
            VStack {
                Text("Hello")
                Spacer().frame(height: 100)
                Text("World!")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                print("VStack tapped")
            }
        }
    }
}

struct UserInteractivity_Previews: PreviewProvider {
    static var previews: some View {
        UserInteractivity()
    }
}
