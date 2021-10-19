//
//  BatPathAnalyser.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/06/07.
//

import Foundation
import SwiftUI
import AVKit

struct BarPathAnalyserView: View {
    @Binding var isPresented: Bool
    @State var isVideoPickerPresented: Bool = false
    @State var pickedVideo: URL?
    @State var pickedVideoAsset: AVAsset?
    @State var dragStartingLocation = CGPoint.zero
    @State var dragEndingLocation =  CGPoint.zero
    @State var dragTransition = CGSize.zero
    @State var tapLocation = CGPoint.zero
    @State var draged = false
    @State var videoThumbnail: Image?
    @State var avPlayer: AVPlayer?
    @State var uiImages = [UIImage]()
    @StateObject var barPathAnalyserViewModel = BarPathAnalyserViewModel()
    
    @GestureState var isPressed = false
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        let dragGesture = DragGesture()
            .onChanged { value in
                if !draged {
                    self.dragStartingLocation = value.location
                    draged.toggle()
                }
                self.dragTransition = value.translation
//                let x = Float(dragTransition.width)
//                let y = Float(dragTransition.height)
                let endPoint = dragStartingLocation.applying(CGAffineTransform(translationX: dragTransition.width, y: dragTransition.height))
                dragEndingLocation = endPoint
            }
            .onEnded { value in
                print(value)
            }
        
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    
                }, label: {
                    Text("분석")
                        .frame(width: 60, height: 30, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                        )
                        .foregroundColor(.black)
                        .padding(.trailing, 20)
                })
            }
            
            if self.avPlayer != nil {
                VideoPlayer(player: self.avPlayer!)
//                PlayerViewContainer(player: self.avPlayer!)
            }
            
//            if videoThumbnail != nil {
//                ZStack {
//                videoThumbnail
//                    .gesture(dragGesture)
//                Rectangle()
//                    .foregroundColor(.green)
//                    .position(dragStartingLocation)
//                    .frame(width: abs(dragEndingLocation.x - dragStartingLocation.x),
//                           height: abs(dragEndingLocation.y - dragStartingLocation.y))
//                }
//            }
//            if pickedVideo != nil {
//                VideoPlayer(player: AVPlayer(url: pickedVideo!))
//                    .scaledToFit()
//            }
            Spacer()
            Divider()
            VStack {
                Button(action: {
                    self.isVideoPickerPresented.toggle()
                }, label: {
                    Text("불러오기")
                        .frame(width: 300, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                        )
                        .foregroundColor(.black)
                })
                .padding(.bottom, 10)
                .fullScreenCover(isPresented: $isVideoPickerPresented, content: {
                    VideoPicker() { video in
//                        print(video)
//                        barPathAnalyserViewModel.getAllFrames(url: video)
//                        barPathAnalyserViewModel.processVideo { player in
//                            self.avPlayer = player
//                        }
//                        pickedVideo = video
//                        pickedVideoAsset = AVAsset(url: video)
                        if let image = barPathAnalyserViewModel.imageFromVideo(url: video, at: 1) {
                            videoThumbnail = Image(uiImage: image)
                        }
                        
                    }
                    .ignoresSafeArea()
                })
                
                Button(action: {
                    self.isPresented.toggle()
                }, label: {
                    Text("취소")
                        .frame(width: 300, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                        )
                        .foregroundColor(.black)
                })
            }
        }
    }
}

class PlayerView: UIView {
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    init(player: AVPlayer) {
        super.init(frame: .zero)
        self.player = player
        self.backgroundColor = .black
        setupLayer()
    }
    
    func setupLayer() {
        playerLayer.contentsGravity = .resizeAspectFill
        playerLayer.videoGravity = .resizeAspectFill
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}

struct PlayerViewContainer: UIViewRepresentable {
    typealias UIViewType = PlayerView
    
    let player: AVPlayer
    
    init(player: AVPlayer) {
        self.player = player
    }
    
    func makeUIView(context: Context) -> PlayerView {
        return PlayerView(player: player)
    }
    
    func updateUIView(_ uiView: PlayerView, context: Context) { }
}

struct BarPathAnalyserView_Previews: PreviewProvider {
    @State static var value = true
    static var previews: some View {
        BarPathAnalyserView(isPresented: $value)
    }
}
