//
//  BatPathAnalyserViewModel.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/06/07.
//

import Foundation
import AVFoundation
import UIKit
import SwiftUI

class BarPathAnalyserViewModel: ObservableObject {
    var avPlayer: AVPlayer?
    private var generator:AVAssetImageGenerator!
    var frames = [UIImage]()
    
    func imageFromVideo(url: URL, at time: TimeInterval) -> UIImage? {
        let asset = AVURLAsset(url: url)

        let assetIG = AVAssetImageGenerator(asset: asset)
        assetIG.appliesPreferredTrackTransform = true
        assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
        
        let cmTime = CMTime(seconds: time, preferredTimescale: 60)
        let thumbnailImageRef: CGImage
        do {
            thumbnailImageRef = try assetIG.copyCGImage(at: cmTime, actualTime: nil)
        } catch let error {
            print("Error: \(error)")
            return nil
        }

        return UIImage(cgImage: thumbnailImageRef)
    }
    
    func getAllFrames(url: URL) {
        let asset:AVAsset = AVAsset(url: url)
        let duration:Float64 = CMTimeGetSeconds(asset.duration)
        self.generator = AVAssetImageGenerator(asset:asset)
        self.generator.appliesPreferredTrackTransform = true
        
        var seconds: Float64 = 0
        
        while seconds <= duration {
            self.getFrame(fromTime: seconds)
            seconds += 1
            
        }
        self.generator = nil
    }
    
    func getFrame(fromTime: Float64) {

        let time: CMTime = CMTimeMakeWithSeconds(fromTime, preferredTimescale: 100)
        let image: CGImage
        do {
           try image = self.generator.copyCGImage(at:time, actualTime:nil)
        } catch {
           return
        }
        self.frames.append(UIImage(cgImage:image))
    }
    
    func processVideo(completion: @escaping (AVPlayer) -> Void) {
        print("frames count : \(frames.count)")
        let settings = CXEImagesToVideo.videoSettings(codec: AVVideoCodecType.h264.rawValue, width: (frames[0].cgImage?.width)!, height: (frames[0].cgImage?.height)!)
        let movieMaker = CXEImagesToVideo(videoSettings: settings)
        movieMaker.createMovieFrom(images: frames){ (fileURL: URL) in
            let video = AVAsset(url: fileURL)
            
            let playerItem = AVPlayerItem(asset: video)
//            let player = AVPlayer()
//            player.setPlayerItem(playerItem: playerItem)
            let player = AVPlayer(playerItem: playerItem)
            self.avPlayer = player
            completion(player)
            print(fileURL)
        }
    }
}
