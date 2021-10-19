//
//  Network.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/05/15.
//

import Foundation
import Alamofire

public class Network {
    static let shared = Network()
    var predictionList = String()
    
    func sendImageToPredictServer(image: UIImage, completion: @escaping (FoodPredictionLabels) -> Void) {
        guard let url = URL(string: Constant.imagePredictServer) else { return }
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            if let imageData = image.jpegData(compressionQuality: 0.2) {
                multipartFormData.append(imageData, withName: "file", fileName: "foodImage.jpeg", mimeType: "image/jpeg")
            }
        }, to: url, method: .post, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let labelsJSON):
                do {
                    let serializedLabelsJSON = try JSONSerialization.data(withJSONObject: labelsJSON, options: .prettyPrinted)
                    let foodPredictionLabels = try JSONDecoder().decode(FoodPredictionLabels.self, from: serializedLabelsJSON)
                    
                    completion(foodPredictionLabels)
                } catch {
                    print("Can't decode food prediction JSON: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Can't response json data: \(error.localizedDescription)")
            }
        }
    }
    
    func sendFoodNameToDBServer(foodName: String, completion: @escaping (FoodNutrientInfo) -> Void) {
        let urlString = Constant.foodDBServer + foodName
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: encodedString) else { return }
        
//        print("하이요")
        
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let foodInfoJSON):
                do {
//                    print(foodInfoJSON)
                    let serializedLabelsJSON = try JSONSerialization.data(withJSONObject: foodInfoJSON, options: .prettyPrinted)
                    let foodNutrientInfo = try JSONDecoder().decode(FoodNutrientInfo.self, from: serializedLabelsJSON)
                    
                    completion(foodNutrientInfo)
                } catch {
                    print("Can't decode food info JSON: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Can't response json data: \(error.localizedDescription)")
            }
        }
    }
    
    func getUserRanking(userLocation: String ,completion: @escaping (UserRank) -> Void) {
//        guard let userLocation = Location.shared.getUserAddress() else { return }
        print("userLocation : \(userLocation)")
        let urlString = (Constant.rankingServer + userLocation).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let userRankingJSON):
                do {
                    print(url)
                    print(userRankingJSON)
                    let serializedRankingJSON = try JSONSerialization.data(withJSONObject: userRankingJSON, options: .prettyPrinted)
                    let userRankInfo = try JSONDecoder().decode(UserRank.self, from: serializedRankingJSON)
                    
                    completion(userRankInfo)
                } catch {
                    print("Can't decode user ranking JSON: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Can't fetch user ranking: \(error.localizedDescription)")
            }
        }
    }
}
