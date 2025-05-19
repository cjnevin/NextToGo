//
//  FilterView.swift
//  RacesFeature
//
//  Created by Chris Nevin on 19/5/2025.
//

import SwiftUI

struct FilterView: View {
    @Binding var isShowing: Bool
    @Bindable var viewModel: NextRacesViewModel

    var body: some View {
        NavigationView {
            VStack {
                CategoryToggleView(
                    category: .greyhoundRacing,
                    isOn: $viewModel.greyhounds
                )
                CategoryToggleView(
                    category: .harnessRacing,
                    isOn: $viewModel.harnesses
                )
                CategoryToggleView(
                    category: .horseRacing,
                    isOn: $viewModel.horses
                )
                Spacer()
            }
            .padding()
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle(LocalizedStringKey("Filters"))
            .toolbar {
                Button(LocalizedStringKey("Done")) {
                    isShowing = false
                }
            }
        }
        .presentationDetents([.fraction(0.35)])
    }
}
