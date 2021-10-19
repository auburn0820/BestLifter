//
//  Workout.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/04/19.
//

import SwiftUI
import CoreData
//import SwiftUICharts

struct Workout: View {
    @ObservedObject var coreDataManager = CoreDataManager.shared
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Program.date, ascending: true)],
        animation: .default)
    private var routines: FetchedResults<Program>
    
    @State var benchPressWeights = [Double]()
    @State var squatWeights = [Double]()
    @State var deadliftWeights = [Double]()
    
    @State var benchPressDate = [Date]()
    @State var squatDate = [Date]()
    @State var deadliftDate = [Date]()
    
    @State var isDetailSquatRecordViewPresented: Bool = false
    @State var isDetailBenchPressRecordViewPresented: Bool = false
    @State var isDetailDeadliftRecordViewPresented: Bool = false
    @State var isBarPathAnalyserViewPresented: Bool = false
    
    @StateObject var workoutViewModel = WorkoutViewModel()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
    
    var body: some View {
        VStack {
            ScrollView {
                // weight 배열을 published로 둘 것
                VStack {
                    if !squatWeights.isEmpty {
                        LineChartView(data: squatWeights, title: "스쿼트", form: ChartForm.large, lineStartColor: Colors.OrangeStart, lineEndColor: Colors.OrangeEnd)
                            .padding()
                            .onLongPressGesture {
                                self.isDetailSquatRecordViewPresented.toggle()
                            }
                            .fullScreenCover(isPresented: $isDetailSquatRecordViewPresented) { RecordsDetailView(coreDataManager: coreDataManager, isPresented: $isDetailSquatRecordViewPresented, workoutName: "Squat", dietViewModel: DietViewModel())
                            }
                    }
                    
                    if !benchPressWeights.isEmpty {
                        LineChartView(data: benchPressWeights, title: "벤치프레스", form: ChartForm.large, lineStartColor: Colors.BorderBlue, lineEndColor: Colors.GradientNeonBlue)
                            .padding()
                            .onLongPressGesture {
                                self.isDetailBenchPressRecordViewPresented.toggle()
                            }
                            .fullScreenCover(isPresented: $isDetailBenchPressRecordViewPresented) { RecordsDetailView(coreDataManager: coreDataManager, isPresented: $isDetailBenchPressRecordViewPresented, workoutName: "Bench Press", dietViewModel: DietViewModel())
                            }
                    }
                    
                    if !deadliftWeights.isEmpty {
                        LineChartView(data: deadliftWeights, title: "데드리프트", form: ChartForm.large, lineStartColor: Colors.DarkPurple, lineEndColor: Colors.GradientPurple)
                            .padding()
                            .onLongPressGesture {
                                self.isDetailDeadliftRecordViewPresented.toggle()
                            }
                            .fullScreenCover(isPresented: $isDetailDeadliftRecordViewPresented) { RecordsDetailView(coreDataManager: coreDataManager, isPresented: $isDetailDeadliftRecordViewPresented, workoutName: "Deadlift", dietViewModel: DietViewModel())
                            }
                    }
                }
            }.onAppear {
                self.benchPressWeights = coreDataManager.getBenchPressWeightsArr()
                self.squatWeights = coreDataManager.getSquatWeightsArr()
                self.deadliftWeights = coreDataManager.getDeadliftWeightsArr()
                self.benchPressDate = coreDataManager.getBenchPressDateArr()
                self.squatDate = coreDataManager.getSquatDateArr()
                self.deadliftDate = coreDataManager.getDeadliftDateArr()
            }
            Spacer()
            Divider()
            Button(action: {
                self.workoutViewModel.openVisionObjectTrack()
//                let url = "VisionTracker://"
            }, label: {
                Text("바 패스 분석")
                    .frame(width: 300, height: 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                    )
                    .foregroundColor(.black)
            })
            .padding(.vertical, 10)
            .fullScreenCover(isPresented: $isBarPathAnalyserViewPresented, content: {
                BarPathAnalyserView(isPresented: $isBarPathAnalyserViewPresented)
            })
        }
    }
    
}

struct WorkoutRecordView: View {
    @ObservedObject var coreDataManager: CoreDataManager
    @Binding var isPresented: Bool
    var workoutName: String
    let dateFormatter = DateFormatter()
    
    init(coreDataManager: CoreDataManager, isPresented: Binding<Bool>, workoutName: String) {
        self.coreDataManager = coreDataManager
        self._isPresented = isPresented
        self.workoutName = workoutName
        self.dateFormatter.dateFormat = "yy.MM.dd"
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(workoutName)")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            Divider()
            ForEach(coreDataManager.getWorkoutRecords(workoutName: workoutName), id: \.date) { workoutRecord in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(String(format: "%.1f", workoutRecord.weight))kg")
                            .font(.title)
                        Text(workoutRecord.date, formatter: dateFormatter)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width - 100, height: 40, alignment: .center)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .shadow(radius: 2)
                )
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

struct Workout_Previews: PreviewProvider {
    static var previews: some View {
        Workout()
    }
}
