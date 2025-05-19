//
//  RaceView.swift
//  RacesFeature
//
//  Created by Chris Nevin on 19/5/2025.
//

import SwiftUI

struct RaceView: View {
    let model: RaceDisplayModel

    var body: some View {
        HStack {
            Image(model.icon)
                .renderingMode(.template)
                .tint(Color(ColorResource.icon))
            Text("R\(model.number)")
            Text(model.name)
            Spacer()
            Text(model.timeElapsed)
        }
        .id(model.id)
    }
}
