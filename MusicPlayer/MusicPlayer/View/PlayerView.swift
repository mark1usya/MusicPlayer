//
//  PlayerView.swift
//  MusicPlayer
//
//  Created by Mark Pashukevich on 1.09.24.
//

import SwiftUI
import RealmSwift
struct PlayerView: View {
    // MARK: Properties
    
    @ObservedResults(SongModel.self) var songs
   @StateObject var vm = ViewModel()
    @State private var showFiles = false
    @State private var showFullPlayer = false
    @State private var isDraging = false
    @Namespace private var playerAnimation
    
    var frameImage: CGFloat{
        
        showFullPlayer ? 320 : 50
    }
    // MARK: Body
    var body: some View {
        NavigationStack{
            ZStack{
                BackgroundView()
                
                VStack {
                //MARK: List of songs
                    List{
                        ForEach(songs) {song in
                            SongSell(song: song, durationFormated: vm.durationFormatted)
                                .onTapGesture {
                                    vm.playAudio(song: song)
                                }
                        }
                        .onDelete(perform: $songs.remove)
                    }
                    .listStyle(.plain)
                    Spacer()
                    
                    //MARK:  Player
                    if vm.currentSong != nil{
                      Player()
                        
                        
                        .frame(height: showFullPlayer ? SizeConstant.fullPlayer : SizeConstant.miniPlayer)
                        .onTapGesture {
                           
                            withAnimation(.spring) {
                                self.showFullPlayer.toggle()
                            }
                        }
                    }
                     
                }
             
                
            }
            //MARK: Navigation bar
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                Button{
                    showFiles.toggle()
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                }}
                                 }
            
            // MARK: File's sheet
            .sheet(isPresented:$showFiles, content: {
                ImportFileManger()
            })
                                 }
                                 }
    //MARK: Methods
    @ViewBuilder
    private func Player() -> some View {
        
        VStack{
            
            ///MARK: mini player
            HStack{
                
                SongImageView(imageData: vm.currentSong?.coverImage, size: frameImage)
       if !showFullPlayer{
                    ///Description
                    
                    VStack(alignment:.leading){
                        SongDescription()
                        
                     
                    }.matchedGeometryEffect(id:"Description", in:playerAnimation)
                    
                    
                    Spacer()
           CustomButton(image:vm.isPlaying ? "pause.fill" : "play.fill" , size: .title) {
                        vm.playPause()
                    }
                    
                    
           
                }
                    
            }
            .padding()
            .background(showFullPlayer ? .clear : .black.opacity(0.3))
            .cornerRadius(10)
            .padding()
            
            /// Full Player
            if showFullPlayer{
                VStack{
                    ///description
                    VStack{
                        SongDescription()
                    }.matchedGeometryEffect(id:"Song Title", in:playerAnimation)
                    VStack{
                        HStack{
                            
                            Text("\(vm.durationFormatted(vm.currentTime))")
                            Spacer()
                            Text("\(vm.durationFormatted(vm.totalTime))")
                        }
                        .durationFont()
                        .padding()
                        
                        
                        ///Slider
                        ///
                        
                        Slider(value: $vm.currentTime, in: 0...vm.totalTime){
                            editing in isDraging = editing
                            if !editing{
                                vm.seekAudio(Time: vm.currentTime)
                            }
                        }
                        .offset(y: -18)
                        .accentColor(.white )
                        .onAppear{
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                vm.upgradeProgress()
                            }
                        }
                        HStack(spacing:40){
                            CustomButton(image: "backward.end.fill", size: .title2) {
                                vm.backward()
                            }
                            CustomButton(image: vm.isPlaying ? "pause.circle.fill" : "play.circle.fill", size: .largeTitle) {
                                vm.playPause()
                            }
                            CustomButton(image: "forward.end.fill", size: .title2) {
                                vm.forward()
                                
                            }
                            
                            
                        }
                    }
                    .padding(.horizontal,40)
                }
            }
            
        }
    }
    
    
    private func CustomButton(image:String, size: Font, action: @escaping () -> () ) -> some View{
        Button {
            action()
        }label: {
            Image(systemName: image).foregroundStyle(.white)
                .foregroundColor(.white)
                .font(size)
        }
        
    }
    
    @ViewBuilder
    private func SongDescription() -> some View{
        if let currentSong = vm.currentSong{
            Text(currentSong.name)
                .nameFont()
            Text(currentSong.artist ?? "Unknown Artist")
                .artistFont()
        }
    }
}

#Preview {
    PlayerView()
}

