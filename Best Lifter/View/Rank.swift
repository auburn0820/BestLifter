//
//  Rank.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/04/19.
//

import SwiftUI

struct Rank: View {
    @StateObject var rankViewModel = RankViewModel()
    
    let width = UIScreen.main.bounds.width - 40
    let biggerWidth = UIScreen.main.bounds.width - 20
    var body: some View {
        VStack {
            HStack {
                Text("Ranking")
                    .font(.largeTitle)
                    .padding()
                Spacer()
                Button {
                    rankViewModel.getUserInfo()
                    print(rankViewModel.userInfo.count)
                } label: {
                    Text("업데이트")
                        .frame(width: 100, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                        )
                        .foregroundColor(.black)
                        .padding()
                }
            }
            .frame(height: 50)
            Divider()
            ScrollView {
                if rankViewModel.userInfo.count >= 1 {
                    ForEach(0..<rankViewModel.userInfo.count, id:\.self) { index in
                        HStack {
                            Group{
                                Text("\(index + 1)")
                                    .font(.largeTitle)
                                    .padding(.leading, 20)
                                Image("user")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding()
                                Text(rankViewModel.userInfo[index].userName ?? "")
                                Spacer()
                                Text("\(String(format: "%.0f",rankViewModel.userInfo[index].score ?? 0.0))")
                                    .padding(.trailing, 20)
                            }
                        }
                        .frame(width: width , height: 80, alignment: .center)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.white)
                        )
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 3)
                        .padding()
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
}

struct Rank_Previews: PreviewProvider {
    static var previews: some View {
        Rank()
    }
}
