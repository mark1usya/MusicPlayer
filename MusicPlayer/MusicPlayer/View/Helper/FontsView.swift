//
//  FontsView.swift
//  MusicPlayer
//
//  Created by Mark Pashukevich on 1.09.24.
//

import SwiftUI
struct DurationFontsModefier: ViewModifier{
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .font(.system(size: 14,weight: .light,design: .rounded))
    }
}


extension View{
    func durationFont() -> some View{
        self.modifier(DurationFontsModefier())
    }
}
extension Text{
   
    func nameFont() -> some View {
        self
            .foregroundStyle(.white)
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            
    }
    func artistFont() -> some View {
        self
            .foregroundStyle(.white)
            .font(.system(size: 14, weight: .light, design: .rounded))
            
    }
}
struct FontsView: View {
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .nameFont()
            
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .artistFont()
            
            HStack{
                Text("00:00")
                Spacer()
                Text("03:27")
            }
            .durationFont()
        }
    }
}

#Preview {
    FontsView()
}
