//
//  SettingsView.swift
//  Flashzilla
//
//  Created by Aleksey Nosik on 22.05.2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var reuseCards: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Toggle("Card should be reused when answered incorrectly", isOn: $reuseCards)
                    .navigationTitle("Settings")
                    .toolbar {
                        Button("Done", action: done)
                    }
            }
        }
    }
    
    func done() {
        dismiss()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(reuseCards: .constant(false))
    }
}
