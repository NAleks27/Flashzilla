//
//  BackgroundModeAppTest.swift
//  Flashzilla
//
//  Created by Aleksey Nosik on 11.05.2023.
//

import SwiftUI

// фоновый режим - когда приложение скрыто
// для добавления уведомлений приложения в фоновом режиме нужно:
// 1. Создаем свойство, которое отслеживает ключ среды, scenePhase
// 2. Используется .onChange{} для просмотра фазы выше
// 3. Добавление нашей логики для реагирования на изменения фазы сцены
// Фаза сцены - окно приложения при вызове диспетчера задач например
// ФАЗЫ ПЕРЕХОДА ПО СЦЕНАМ: active -> inactive -> background -> inactive -> active
// ACTIVE - те, которые мы непосредственно сейчас используем и имеем к нему доступ
// INACTIVE - те, еоторые могут быть видны пользователю, но к ним нет доступа управления (например свайп панели инструментов сверху или вызов диспетчера задач - он же режим многозадачности)
// BACKGROUND - те, которые не видны пользователю на экране (такие задачи могут быть прекращены в какой-то момент в будущем, если есть нехватка озу - ios убивает фоновые процессы для освобождения памяти)


struct BackgroundModeAppTest: View {
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    print("Active")
                } else if newPhase == .inactive {
                    print("Inactive")
                } else if newPhase == .background {
                    print("Background")
                }
            }
    }
}

struct BackgroundModeAppTest_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundModeAppTest()
    }
}
