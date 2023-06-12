//
//  EditCards.swift
//  Flashzilla
//
//  Created by Aleksey Nosik on 21.05.2023.
//

import SwiftUI

// 1. Это вью должно иметь собственный массив персональных карт
// 2. Навигейшн вью для кнопки ГОТОВО
// 3. Список всех созданных карт
// 4. Поле для ввода вопроса, подсказки
// 6. Метод для загрузки и сохранения данных

struct EditCardsView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var cards = [Card]()
    @State private var newPromt = ""
    @State private var newAnswer = ""
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("Cards")
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Promt", text: $newPromt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add card", action: addCard)
                }
                
                Section {
                    List {
                        ForEach(0..<cards.count, id:\.self) { index in
                            VStack(alignment: .leading) {
                                Text(cards[index].promt)
                                    .font(.subheadline)
                                Text(cards[index].answer)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onDelete(perform: removeCard)
                    }
                } header: {
                    Text("Cards (\(cards.count))")
                        .font(.subheadline.bold())
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done", action: done)
            }
            .onAppear(perform: loadData)
        }
    }
    func addCard() {
        let trimmedPromt = newPromt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        
        guard trimmedPromt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        
        let card = Card(promt: trimmedPromt, answer: trimmedAnswer)
        cards.insert(card, at: 0)
        
        saveData()
        
        newPromt = ""
        newAnswer = ""
    }
    
    func removeCard(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        saveData()
    }
    
    func done() {
        dismiss()
    }
    
    func loadData() {
        do {
            let data = try Data(contentsOf: savePath)
            cards = try JSONDecoder().decode([Card].self, from: data)
        } catch {
            cards = []
        }
    }
    
    func saveData() {        
        do {
            let data = try JSONEncoder().encode(cards)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
    
}

struct EditCards_Previews: PreviewProvider {
    static var previews: some View {
        EditCardsView()
    }
}
