//
//  SongSellView.swift
//  MusicPlayer
//
//  Created by Mark Pashukevich on 2.09.24.
//

import SwiftUI

struct SongSell: View {
    let song: SongModel
    let durationFormated: (TimeInterval) -> String
    var body: some View {
        HStack{
            SongImageView(imageData: song.coverImage, size: 60)
            
            VStack(alignment:.leading){
                Text(song.name)
                    .nameFont()
                
                Text(song.artist ?? "Unknown artist")
                    .artistFont()
            }
            Spacer()
            if let duration = song.duration{
                Text(durationFormated(duration))
                    .artistFont()
            }
           
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}


#Preview {
    PlayerView()
}
