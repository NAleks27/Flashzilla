//
//  UsingTimerTest.swift
//  Flashzilla
//
//  Created by Aleksey Nosik on 11.05.2023.
//

import SwiftUI

//tolerance - максимальный и минимальный допуск


struct UsingTimerTest: View {
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    
    @State private var counter = 0
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onReceive(timer) { time in
                if counter == 5 {
                    timer.upstream.connect().cancel()
                } else {
                    print("The time is now; \(time)")
                }
                counter += 1
            }
    }
}

struct UsingTimerTest_Previews: PreviewProvider {
    static var previews: some View {
        UsingTimerTest()
    }
}
