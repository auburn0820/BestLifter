//
//  RecordsView.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/06/07.
//

import SwiftUI

struct RecordsDetailView: View {
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var dietViewModel: DietViewModel
    @Binding var isPresented: Bool
    @State var workoutName: String
    let dateFormatter = DateFormatter()
    
    
    init(coreDataManager: CoreDataManager, isPresented: Binding<Bool>, workoutName: String, dietViewModel: DietViewModel) {
        self.coreDataManager = coreDataManager
        self.dietViewModel = dietViewModel
        self._isPresented = isPresented
        self.workoutName = workoutName
        self.dateFormatter.dateFormat = "yy.MM.dd"
    }
    
    init(coreDataManager: CoreDataManager, isPresented: Binding<Bool>, dietViewModel: DietViewModel) {
        self.coreDataManager = coreDataManager
        self._isPresented = isPresented
        self.workoutName = ""
        self.dateFormatter.dateFormat = "yy.MM.dd"
        self.dietViewModel = dietViewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(workoutName != "" ? workoutName : "체중")")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            Divider()
            if workoutName != "" {
                ForEach(coreDataManager.getWorkoutRecords(workoutName: workoutName), id: \.date) { workoutRecord in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(String(format: "%.1f", workoutRecord.weight))kg")
                                .font(.title)
                            Text(workoutRecord.date, formatter: dateFormatter)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 10)
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width - 40, height: 80, alignment: .center)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.white)
                    )
                    .cornerRadius(10)
                    .shadow(color: .black, radius: 3)
                    .padding(.vertical, 10)
                }
            } else {
                ForEach(0..<dietViewModel.bodyWeights.count) { index in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(String(format: "%.1f", dietViewModel.bodyWeights[index]))kg")
                                .font(.title)
                            Text(dietViewModel.bodyWeightsDate[index], formatter: dateFormatter)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 10)
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width - 40, height: 80, alignment: .center)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.white)
                    )
                    .cornerRadius(10)
                    .shadow(color: .black, radius: 3)
                    .padding(.vertical, 10)
                }
            }
            Spacer()
            Divider()
            Button(action: {
                self.isPresented.toggle()
            }, label: {
                Text("닫기")
                    .frame(width: 300, height: 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                    )
            })
            .foregroundColor(.black)
        }
    }
}
