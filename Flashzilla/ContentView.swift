//
//  ContentView.swift
//  Flashzilla
//
//  Created by Aleksey Nosik on 10.05.2023.
//

import SwiftUI

// для создания таймера используем SUI, Foundation and Combine
// создаем триггер, который будет каждую секунду обновляться
// создаем свойство для отслеживания, сколько времени осталось у игрока и из этого свойства будем вычитать 1 при срабатывании таймера-триггера

// важно что при скрытии приложения оно переходит в фоновый режим но пару секунд еще работает, поэтому при скрытии приложенияна таймере одни цифры, а по возвращению они меньше на пару секунд - поэтому для этого нам нужно сразу останавливать время и использовать для этого фазысцены (active, inactive, background)


extension View {
    func stacked(at position: Int, total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    @State private var showingEditView = false
    @State private var showingSettingScreen = false

    
    @State private var cards = [Card]()
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var reuseCards = false
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.7))
                    .clipShape(Capsule())
                
                Toggle("Reuse cards", isOn: $reuseCards)
                
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index]) {
                            if reuseCards {
                                withAnimation {
                                    pushCardToBack(at: index)
                                }
                            } else {
                                withAnimation {                     // для скольжения карт
                                    removeCard(at: index)
                                }
                            }
                        }
                        .stacked(at: index, total: cards.count)
                        .allowsHitTesting(index == cards.count - 1) // блокируем перетаскивание нижних карт, кроме верхней
                        .accessibilityHidden(index < cards.count - 1)   // отключаем озвучивание нижних карт
                    }
                }
                .allowsHitTesting(timeRemaining > 0)            // доступность если на таймере больше 0
                
                if cards.isEmpty {
                    Button("Start again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
                
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    VStack {
                        Button {
                            showingEditView = true
                        } label: {
                            Image(systemName: "plus.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        
                        Button {
                            showingSettingScreen = true
                        } label: {
                            Image(systemName: "gear")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                    }
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .font(.title)
            .padding()
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            if reuseCards {
                                withAnimation {
                                    pushCardToBack(at: cards.count - 1)
                                }
                            } else {
                                withAnimation {
                                    removeCard(at: cards.count - 1)
                                }
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black).opacity(0.7)
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black).opacity(0.7)
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                        
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditView, onDismiss: resetCards, content: EditCardsView.init)  // синтаксический сахар
        .sheet(isPresented: $showingSettingScreen) { SettingsView(reuseCards: $reuseCards) }
        .onAppear(perform: resetCards)
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }        // добавляем эту защиту, так как при нажатии на кнопки чтобы мы не пытались удалить что-то когда уже нет карт
        
        cards.remove(at: index)
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func pushCardToBack(at index: Int) {
        let reuseCard = cards.remove(at: index)
        cards.insert(reuseCard, at: 0)
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
