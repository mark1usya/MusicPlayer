//
//  BackgroundView.swift
//  MusicPlayer
//
//  Created by Mark Pashukevich on 1.09.24.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        LinearGradient(
            colors: [.bottomBackground,.topBackground, .red],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}


#Preview {
    BackgroundView()
}
