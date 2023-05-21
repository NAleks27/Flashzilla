//
//  CoreHapticsTestVibro.swift
//  Flashzilla
//
//  Created by Aleksey Nosik on 10.05.2023.
//

import CoreHaptics
import SwiftUI

// corehapticts мы должны создать до работы с юай (это класс - ссылочный тип)
// 1. Gроверяем поддерживает ли устройство тактильные ощущения
// 2. Интенсивноссть и резкость тактильных ощущений можно регулировать

struct CoreHapticsTestVibro: View {
    @State private var engine: CHHapticEngine?

    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .onTapGesture(perform: simpleSuccess)
            
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .onAppear(perform: prepareHaptics)
                .onTapGesture(perform: complexSuccess)

        }
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
//        generator.notificationOccurred(.warning)
//        generator.notificationOccurred(.error)
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }          // 1
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func complexSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }         // 1
        
        var events = [CHHapticEvent]()              // создаем события
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))        // 2
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness , value: Float(i))       // 2
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)    // создаем событие
        }
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))        // 2
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness , value: Float(1 - i))       // 2
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)    // создаем событие
        }

        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])       // создаем шаблон всех событий(чтобы он мог иметь много событий в себе)
            let player = try engine?.makePlayer(with: pattern)                  // создаем проигрыватель
            try player?.start(atTime: 0)
        } catch {
            print("Failet to play pattern \(error.localizedDescription)")
        }
        
    }
}

struct CoreHapticsTestVibro_Previews: PreviewProvider {
    static var previews: some View {
        CoreHapticsTestVibro()
    }
}
