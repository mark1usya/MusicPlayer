//
//  ImportFileManger.swift
//  MusicPlayer
//
//  Created by Mark Pashukevich on 3.09.24.
//

import Foundation
import SwiftUI
import AVFoundation
import RealmSwift

///ImportFileManager use for select and import audio to the app
struct ImportFileManger: UIViewControllerRepresentable {
    
   
    ///coordinator  controls tasks bettween SwiftUI and UIKit
    func makeCoordinator() -> Coordinator{
        Coordinator(parent: self)
    }
    
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .open)
        picker.allowsMultipleSelection = false
        
        picker.shouldShowFileExtensions = true
        
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        
        var parent: ImportFileManger
        @ObservedResults(SongModel.self) var songs
        init(parent: ImportFileManger) {
            self.parent = parent
        }
        
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            
            guard let url = urls.first, url.startAccessingSecurityScopedResource() else {return}
            defer {url.stopAccessingSecurityScopedResource()
                
            }
            do{
                //get data
               let document = try Data(contentsOf: url)
                
                let asset = AVAsset(url:url)
            ///initialization for SongModel object
                var song = SongModel(name: url.lastPathComponent, data: document)
                
                let metadata = asset.metadata
                for item in metadata{
                    ///check if file has a metadata  with key/value
                    guard let key = item.commonKey?.rawValue, let value = item.value
                    else{continue}
                    switch key {
                    case AVMetadataKey.commonKeyArtist.rawValue:
                        song.artist = value as? String
                    case AVMetadataKey.commonKeyArtwork.rawValue:
                        song.coverImage = value as? Data
                    case AVMetadataKey.commonKeyTitle.rawValue:
                        song.name = value as? String ?? song.name
                    default:
                        break
                    }
                }
                
                song.duration = CMTimeGetSeconds(asset.duration)
                
                let isDublicate = songs.contains{$0.name == song.name && $0.artist == song.artist}
                /// add song to the array songs if it is a firts one
                if !isDublicate{
                   
                        $songs.append(song)
                        
                    }
                else{
                    print("Song with the same name already exists ")
                }
            }
            
            catch{
                print("Error proccesing the file: \(error)")
            }
        }
    }
}
