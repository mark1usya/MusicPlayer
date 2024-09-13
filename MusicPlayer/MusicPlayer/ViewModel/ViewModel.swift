//
//  ViewModel.swift
//  MusicPlayer
//
//  Created by Mark Pashukevich on 2.09.24.
//

import Foundation
import AVFAudio
import AVFoundation.AVAudioSession
import RealmSwift

class ViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate{
    @ObservedResults(SongModel.self) var songs
    @Published var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var currentIndex: Int?
    @Published var currentTime: TimeInterval = 0.0
    @Published var totalTime: TimeInterval = 0.0
   
    var currentSong:SongModel? {
        guard let currentIndex = currentIndex,songs.indices.contains(currentIndex)
        else{
            return nil
        }
        return songs[currentIndex]
    }
    
    // MARK: Methods
    
    func playAudio(song:SongModel){
       
        do{
            
            self.audioPlayer = try AVAudioPlayer(data: song.data)
            self.audioPlayer?.delegate = self
            self.audioPlayer?.play()
          
            isPlaying = true
            totalTime = audioPlayer?.duration ?? 0.0
            if let index = songs.firstIndex(where: { $0.id == song.id}) {
                currentIndex = index
               
            }
            
         
        }
        catch{
            print("Error in audio playback: \(error.localizedDescription)")
        }
    }
    
    
    func playPause(){
        if isPlaying
        {
            self.audioPlayer?.pause()
        }
        else{
            self.audioPlayer?.play()
        }
        isPlaying.toggle()
        
    }
    
    func forward(){
        guard let currentIndex = currentIndex else{return}
        let nextIndex = currentIndex + 1 < songs.count ? currentIndex + 1 : 0
        playAudio(song: songs[nextIndex])
    }
    
    func backward(){
        
        guard let  currentIndex = currentIndex else{return}
        let previousIndex = currentIndex > 0 ? currentIndex - 1 : songs.count - 1
        playAudio(song: songs[previousIndex])
    }
    
    func stopAudio(){
        self.audioPlayer?.stop()
        self.audioPlayer = nil
        isPlaying = false
        
    }
    
    func seekAudio(Time:TimeInterval){
        audioPlayer?.currentTime = Time
    }
    func upgradeProgress(){
        
        guard let player = audioPlayer else{
            return
        }
        currentTime = player.currentTime
    }
    
    func durationFormatted(_ duration: TimeInterval) -> String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute,.second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: duration) ?? ""
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            forward()
        }
    }
    
}
