//
//  FilterToggleView.swift
//  RacesFeature
//
//  Created by Chris Nevin on 19/5/2025.
//

import SwiftUI

struct CategoryToggleView: View {
    let category: Category
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            HStack {
                Image(category.icon)
                    .renderingMode(.template)
                    .tint(Color(ColorResource.icon))
                Text(category.title)
            }
        }
        .tint(.accentColor)
    }
}
