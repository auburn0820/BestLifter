//
//  Main.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/04/08.
//

import SwiftUI

struct Main: View {
    @StateObject var profileViewModel = ProfileViewModel()
    @StateObject var onDietViewModel = OnDietViewModel()
    @StateObject var dietViewModel = DietViewModel()
    @State private var selection = 0
    @State private var addButtonIsTapped: Bool = false
    @State private var showWorkoutModal: Bool = false
    @State private var showDietModal: Bool = false
    
    var body: some View {
        ZStack() {
            VStack() {
                TabView(selection: $selection) {
                    Profile(profileViewModel: profileViewModel).tag(0)
                    Workout().tag(1)
                    Diet(dietViewModel: dietViewModel, profileViewModel: profileViewModel, onDietViewModel: onDietViewModel).tag(2)
                    Rank().tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                Divider()
                TabBar(selection: $selection)
                    .frame(height: 30, alignment: .center)
            }
            VStack() {
                Spacer()
                HStack() {
                    Spacer()
                    hotButtonView
                }
            }
        }
    }
}

extension Main {
    private var hotButtonView: some View {
        VStack(alignment: .center) {
            if addButtonIsTapped {
                Button(action: {
                    self.showWorkoutModal.toggle()
                }, label: {
                    Image("addWorkout")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                        .foregroundColor(Color.white)
                })
                .frame(width: 50, height: 50, alignment: .center)
                .background(Color(red: 0 / 255, green: 122 / 255, blue: 255 / 255))
                .cornerRadius(40.0)
                .padding(.bottom, 5)
//                .scaleEffect(addButtonIsTapped ? 1 : 0)
//                .animation(.easeOut(duration: 0.1))
                .fullScreenCover(isPresented: self.$showWorkoutModal, content: {
                    OnWorkOut(profileViewModel: profileViewModel)
                })
                .transition(.asymmetric(insertion: .scale, removal: .scale))
                
                Button(action: {
                    self.showDietModal.toggle()
                }, label: {
                    Image("foodRecord")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                        .foregroundColor(Color.white)
                })
                .frame(width: 50, height: 50, alignment: .center)
                .background(Color(red: 0 / 255, green: 122 / 255, blue: 255 / 255))
                .cornerRadius(40.0)
                .padding(.bottom, 20)
//                .scaleEffect(addButtonIsTapped ? 1 : 0)
//                .animation(.easeOut(duration: 0.05))
                .fullScreenCover(isPresented: self.$showDietModal, content: {
                    OnDiet(onDietViewModel: onDietViewModel, dietViewModel: dietViewModel)
                })
                .transition(.asymmetric(insertion: .scale, removal: .scale))
            }
            
            Button(action: {
                withAnimation(.easeOut(duration: 0.1)) {
                    self.addButtonIsTapped.toggle()
                }
            }, label: {
                Image("plus")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .foregroundColor(Color(red: 0 / 255, green: 122 / 255, blue: 255 / 255))
            })
            .background(Color.white)
            .cornerRadius(25)
            .rotationEffect(Angle.degrees(addButtonIsTapped ? 45 : 0))
            .scaleEffect(addButtonIsTapped ? 1.2 : 1)
            .animation(.easeOut(duration: 0.05))
            .padding(.bottom, 60)
        }
        .padding(.trailing, 20)
    }
}

struct TabBar: View {
    @Binding var selection: Int
    @Namespace private var currentTab
    
    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(tabs.indices) { index in
                // 실선을 표시하기 위한 GeometryReader
                GeometryReader { geometry in
                    VStack(spacing: 4) {
                        if selection == index {
                            // 현재 선택된 탭 바 메뉴 색상 설정
                            Color(red: 0 / 255, green: 122 / 255, blue: 255 / 255)
                                .frame(height: 2)
                                .offset(y: -8)
                                .matchedGeometryEffect(id: "currentTab", in: currentTab)
                        }
                        // 이미지 설정
                        Image(tabs[index].image)
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 25, height: 25)
                        //                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(width: geometry.size.width / 2,
                           height: 30,
                           alignment: .bottom)
                    .padding(.horizontal)
                    .foregroundColor(selection == index ? Color(red: 0 / 255, green: 122 / 255, blue: 255 / 255) : Color(red: 211 / 255, green: 211 / 255, blue: 211 / 255))
                    // 해당 이미지가 선택됐을 때, 어떤 동작을 할 것인지 구현할 수 있다.
                    .onTapGesture {
                        // selection 변수의 값을 업데이트한다.
                        withAnimation(.easeOut(duration: 0.2)) {
                            selection = index
                        }
                    }
                }
                .frame(height: 30, alignment: .bottom)
            }
        }
    }
}

struct Tab {
    let image: String
    let label: String
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
//        Main().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}

let tabs: [Tab] = [
    Tab(image: "profile", label: "profile"),
    Tab(image: "workoutRecord", label: "workoutRecord"),
    Tab(image: "foodRecord", label: "foodRecord"),
    Tab(image: "rank", label: "rank")
]
