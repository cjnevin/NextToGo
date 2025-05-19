//
//  NextRacesView.swift
//  RacesFeature
//
//  Created by Chris Nevin on 18/5/2025.
//

import Core
import SwiftUI

public struct NextRacesView: View {
    @Bindable public var viewModel: NextRacesViewModel
    @State private var showingFilters = false

    public init(viewModel: NextRacesViewModel = NextRacesViewModel()) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            ZStack {
                switch viewModel.state {
                case .idle:
                    EmptyView()
                case .loading:
                    ProgressView()
                case .loaded(let items):
                    VStack {
                        List {
                            ForEach(items) { item in
                                RaceView(model: item)
                            }
                        }
                    }
                    .task {
                        await viewModel.startTimer()
                    }
                case .error(let string):
                    Text(string).foregroundColor(.red)
                }
            }
            .navigationTitle(LocalizedStringKey("Next to Go"))
            .toolbar {
                Button(LocalizedStringKey("Filters"), systemImage: "slider.horizontal.3") {
                    showingFilters.toggle()
                }
            }
            .task {
                await viewModel.startFetching()
            }
        }
        .sheet(isPresented: $showingFilters) {
            FilterView(
                isShowing: $showingFilters,
                viewModel: viewModel
            )
        }
    }
}

#Preview {
    NextRacesView(
        viewModel: NextRacesViewModel(
            dateProvider: MockDateProvider(),
            endpoint: MockNextRacesEndpoint()
        )
    )
}
