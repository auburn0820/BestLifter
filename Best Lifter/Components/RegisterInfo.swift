//
//  RegisterInfo.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/05/01.
//

import SwiftUI
import Combine

struct RegisterInfo: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var genderSelectionViewModal: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                VStack {
                    Text("신체")
                        .font(.system(size: 30))
                    TextField("이름", text: $profileViewModel.name)
                        .multilineTextAlignment(.center)
                        .frame(width: geometry.size.width - 80, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(lineWidth: 2)
                        )
                    TextField("체중", text: $profileViewModel.userWeightStr)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .frame(width: geometry.size.width - 80, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(lineWidth: 2)
                        )
                    Button(action: {
                        self.genderSelectionViewModal.toggle()
                    }, label: {
                        Text("\(profileViewModel.genderString)")
                            .foregroundColor(profileViewModel.genderString == "성별" ? Color.gray : Color.black)
                            .frame(width: geometry.size.width - 80, height: 30)
                    })
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2)
                    )
                    .fullScreenCover(isPresented: $genderSelectionViewModal, content: {
                        genderSelectionView
                    })
                }
                
                VStack {
                    Text("중량")
                        .font(.system(size: 30))
                        .padding(.top, 20)
                    TextField("스쾃", text: $profileViewModel.squatWeightsStr)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .frame(width: geometry.size.width - 80, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(lineWidth: 2)
                        )
                    
                    TextField("벤치프레스", text: $profileViewModel.benchPressWeightsStr)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .frame(width: geometry.size.width - 80, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(lineWidth: 2)
                        )
                    
                    TextField("데드리프트", text: $profileViewModel.deadliftWeightsStr)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .frame(width: geometry.size.width - 80, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(lineWidth: 2)
                        )
                }
                Button(action: {
                    if !profileViewModel.name.isEmpty {
                        self.profileViewModel.userRegistered = true
                        profileViewModel.getWilksPoint()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("등록")
                        .foregroundColor(Color.black)
                })
                .frame(width: 80, height: 30, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(lineWidth: 2)
                )
                .padding(.top, 20)
            }
            .frame(width: geometry.size.width - 50, height: 450, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(lineWidth: 2)
            )
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

extension RegisterInfo {
    var genderSelectionView: some View {
        VStack {
            Picker(selection: $profileViewModel.gender, label: Text("성별"), content: {
                Text("남성").tag(1)
                Text("여성").tag(2)
            })
            Button(action: {
                self.genderSelectionViewModal.toggle()
                profileViewModel.setGenderString()
            }, label: {
                Text("등록")
                    .foregroundColor(Color.black)
            })
            .frame(width: 80, height: 30, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(lineWidth: 2)
            )
            .padding(.top, 20)
        }
        
    }
}

struct RegisterInfo_Previews: PreviewProvider {
    static var previews: some View {
        RegisterInfo(profileViewModel: ProfileViewModel())
    }
}
