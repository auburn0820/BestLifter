//
//  Profile.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/04/19.
//

import SwiftUI
import Combine

struct Profile: View {
//    @EnvironmentObject var profileViewModel = ProfileLogic
    @ObservedObject var profileViewModel: ProfileViewModel = ProfileViewModel()
    @State var modal: Bool = false
    @State var orientation = UIDevice.current.orientation
    
    var body: some View {
        UserInfoView(profileViewModel: self.profileViewModel, modal: self.$modal)
            .onAppear {
                if profileViewModel.name.isEmpty {
                    self.modal = true
                }
            }
            .fullScreenCover(isPresented: $modal, content: {
                RegisterInfo(profileViewModel: self.profileViewModel)
            })
    }
}

struct UserInfoView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Binding var modal: Bool
    @State var name = ""
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    VStack {
                        Image("user")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color.gray)
                            .padding()
                        Text("\(self.profileViewModel.name)")
                        
                        Button(action: {
                            //                        print(profileLogic.name)
                            self.modal.toggle()
                        }, label: {
                            Text("편집")
                                .foregroundColor(Color.black)
                        })
                        .frame(width: 50, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(lineWidth: 2.0)
                        )
                        .padding(.top, 10)
                        .fullScreenCover(isPresented: $modal, content: {
                            RegisterInfo(profileViewModel: self.profileViewModel)
                        })
                    }
                    .padding(.top, 20)
                    Divider()
                        .background(Color.black)
                        .padding()
                    wilksPointView
                        .frame(width: geometry.size.width, alignment: .leading)
                        .padding(.bottom, 20)
                    weightTotal
                        .frame(width: geometry.size.width, alignment: .leading)
                        .padding(.bottom, 20)
                }
            }
        }
    }
    var wilksPointView: some View {
        VStack(alignment: .leading) {
            Text("Wilks Point")
                .font(.system(size: 30))
                .padding(.leading, 20)
            Text(profileViewModel.wilksPoint)
                .font(.system(size: 20))
                .padding(.top, 10)
                .padding(.leading, 30)
        }
    }
    
    var weightTotal: some View {
        VStack(alignment: .leading) {
            Text("체중")
                .font(.system(size: 30))
                .padding(.leading, 20)
                .padding(.bottom, 10)
            Text("\(profileViewModel.userWeightStr) kg")
                .font(.system(size: 20))
                .padding(.bottom, 10)
                .padding(.leading, 30)
            
            Text("1RM")
                .font(.system(size: 30))
                .padding(.leading, 20)
                .padding(.bottom, 10)
            Text("Squat")
                .font(.system(size: 25))
                .padding(.leading, 20)
            
            Text("\(profileViewModel.squatWeightsStr) kg")
                .font(.system(size: 20))
                .padding(.bottom, 10)
                .padding(.top, 10)
                .padding(.leading, 30)
            
            Text("Bench Press")
                .font(.system(size: 25))
                .padding(.leading, 20)
            Text("\(profileViewModel.benchPressWeightsStr) kg")
                .font(.system(size: 20))
                .padding(.bottom, 10)
                .padding(.top, 10)
                .padding(.leading, 30)
            
            Text("Deadlift")
                .font(.system(size: 25))
                .padding(.leading, 20)
            Text("\(profileViewModel.deadliftWeightsStr) kg")
                .font(.system(size: 20))
                .padding(.bottom, 10)
                .padding(.top, 10)
                .padding(.leading, 30)
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
