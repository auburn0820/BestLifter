//
//  RankViewModel.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/06/12.
//

import Foundation

class RankViewModel: ObservableObject {
    @Published var userInfo = [UserData]()
    
    func getUserInfo() {
        Location.shared.getUserAddress { userRank in
            if let userInfo = userRank.data {
                self.userInfo = userInfo
            }
        }
    }
}
