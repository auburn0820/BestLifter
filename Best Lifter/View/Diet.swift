//
//  Diet.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/04/19.
//

import SwiftUI
//import SwiftUICharts

struct Diet: View {
    @ObservedObject var dietViewModel: DietViewModel
    @ObservedObject var onDietViewModel: OnDietViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @State var bodyWeightToInput: String = ""
    @State var bodyWeightInputViewToggle: Bool = false
    @State var dailyNutretionInputViewToggle: Bool = false
    @State var bodyWeightRecordsView: Bool = false
    @State var calorieState: CGFloat
    
    init(dietViewModel: DietViewModel, profileViewModel: ProfileViewModel, onDietViewModel: OnDietViewModel) {
        self.dietViewModel = dietViewModel
        self.profileViewModel = profileViewModel
        self.onDietViewModel = onDietViewModel
        self.calorieState = dietViewModel.calorieCGFloat
    }
    
    var body: some View {
        VStack {
            ScrollView {
                if !dietViewModel.bodyWeights.isEmpty {
                    LineChartView(data: dietViewModel.bodyWeights, title: "체중", form: ChartForm.large, lineStartColor: Color.pink.opacity(0.5), lineEndColor: Color.pink)
                        .padding()
                        .onLongPressGesture {
                            self.bodyWeightRecordsView.toggle()
                        }
                        .fullScreenCover(isPresented: $bodyWeightRecordsView) {
                            RecordsDetailView(coreDataManager: CoreDataManager.shared, isPresented: $bodyWeightRecordsView, dietViewModel: dietViewModel)
                        }
                }
                Divider()
                VStack(spacing: 80) {
                    HStack {
                        ActivityRingView(mainColor: .green, name: "calorie", icon: Image( "kcal"), dietViewModel: self.dietViewModel)
                        ActivityRingView(mainColor: Color.red, name: "carb", icon: Image("carb"), dietViewModel: self.dietViewModel)
                    }
                    
                    HStack {
                        ActivityRingView(mainColor: Color.blue, name: "protein", icon: Image("protein"), dietViewModel: self.dietViewModel)
                        ActivityRingView(mainColor: Color.yellow, name: "fat", icon: Image("fat"), dietViewModel: self.dietViewModel)
                    }
                }
                .padding(.vertical, 20)
                Divider()
                VStack(spacing: 10) {
                    Button(action: {
                        self.dailyNutretionInputViewToggle.toggle()
//                        self.test = 0.8
                    }, label: {
                        Text("영양 설정")
                            .frame(width: 300, height: 30, alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                            )
                            .foregroundColor(.black)
                    })
                    .fullScreenCover(isPresented: self.$dailyNutretionInputViewToggle, content: {
                        DailyCalorieSettingView(dietViewModel: dietViewModel, isPresented: $dailyNutretionInputViewToggle)
                    })
                    
                    Button(action: {
                        self.bodyWeightInputViewToggle.toggle()
                    }, label: {
                        Text("체중 추가")
                            .frame(width: 300, height: 30, alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                            )
                            .foregroundColor(.black)
                    })
                    .fullScreenCover(isPresented: self.$bodyWeightInputViewToggle, content: {
                        BodyWeightInputView(isPresented: $bodyWeightInputViewToggle, bodyWeightToInput: $bodyWeightToInput, dietViewModel: dietViewModel, profileViewModel: profileViewModel)
                    })
                    
                    Button(action: {
                        self.dietViewModel.setTakedProperteisToZero()
                        self.dietViewModel.setNutritionCGFloat()
                        self.onDietViewModel.meals.meals[0].foods.removeAll()
                        self.onDietViewModel.meals.meals[1].foods.removeAll()
                        self.onDietViewModel.meals.meals[2].foods.removeAll()
                        
                    }, label: {
                        Text("초기화")
                            .frame(width: 300, height: 30, alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                            )
                            .foregroundColor(.black)
                    })
                }
                .padding(.bottom, 10)
            }
            .onAppear {
                dietViewModel.setNutritionCGFloat()
//                print("calorie rate: \(dietViewModel.calorieCGFloat)")
            }
        }
    }
}

struct BodyWeightInputView: View {
    @Binding var isPresented: Bool
    @Binding var bodyWeightToInput: String
    @ObservedObject var dietViewModel: DietViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        TextField("체중", text: $bodyWeightToInput)
            .multilineTextAlignment(.center)
            .frame(width: 300, height: 30, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
            )
            .keyboardType(.numberPad)
        
        VStack(spacing: 10) {
            Button(action: {
                if !bodyWeightToInput.isEmpty, let weight = Double(bodyWeightToInput) {
                    self.dietViewModel.addBodyWeights(weight: weight, profileViewModel: profileViewModel)
                }
                self.bodyWeightToInput = ""
                self.isPresented.toggle()
                
            }, label: {
                Text("추가")
                    .frame(width: 200, height: 30, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                    )
                    .foregroundColor(.black)
            })
            
            Button(action: {
                self.bodyWeightToInput = ""
                self.isPresented.toggle()
            }, label: {
                Text("취소")
                    .frame(width: 200, height: 30, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                    )
                    .foregroundColor(.black)
            })
        }
    }
}

struct DailyCalorieSettingView: View {
    @ObservedObject var dietViewModel: DietViewModel
    @Binding var isPresented: Bool
    @State var calorieString: String = ""
    @State var carbsString: String = ""
    @State var proteinsString: String = ""
    @State var fatsString: String = ""
    
    var body: some View {
        TextField("칼로리", text: $calorieString)
            .multilineTextAlignment(.center)
            .frame(width: 300, height: 30, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
            )
            .keyboardType(.numberPad)
        
        TextField("탄수화물", text: $carbsString)
            .multilineTextAlignment(.center)
            .frame(width: 300, height: 30, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
            )
            .keyboardType(.numberPad)
        
        TextField("단백질", text: $proteinsString)
            .multilineTextAlignment(.center)
            .frame(width: 300, height: 30, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
            )
            .keyboardType(.numberPad)
        
        TextField("지방", text: $fatsString)
            .multilineTextAlignment(.center)
            .frame(width: 300, height: 30, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
            )
            .keyboardType(.numberPad)
        
        VStack(spacing: 10) {
            Button(action: {
                dietViewModel.setUserNutritionInfo(calorie: calorieString, carbs: carbsString, proteins: proteinsString, fats: fatsString)
                isPresented.toggle()
            }, label: {
                Text("확인")
                    .frame(width: 200, height: 30, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                    )
                    .foregroundColor(.black)
            })
            
            Button(action: {
                isPresented.toggle()
            }, label: {
                Text("취소")
                    .frame(width: 200, height: 30, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                    )
                    .foregroundColor(.black)
            })
        }
    }
}

struct ActivityRingView: View {
    @ObservedObject var dietViewModel: DietViewModel
    @State var progress: CGFloat = 0.0
    @State var icon: Image
    var name: String
    
    var mainColor: Color
    var colors: [Color]
    
    init(mainColor: Color, name: String, icon: Image, dietViewModel: DietViewModel) {
        self.colors = [mainColor, mainColor.opacity(0.8)]
        self.mainColor = mainColor
        self.name = name
        self.dietViewModel = dietViewModel
        self.icon = icon
    }
    
    func setRate(name: String) {
        self.progress = dietViewModel.nutiritionRate(name: name)
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .stroke(mainColor.opacity(0.4), lineWidth: 15)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: colors),
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: 15, lineCap: .round)
            ).rotationEffect(.degrees(-90))
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(progress > 0.95 ? mainColor.opacity(0.5): mainColor.opacity(0))
                .offset(y: -150)
                .rotationEffect(Angle.degrees(360 * Double(progress)))
                .shadow(color: progress > 0.96 ? Color.black.opacity(0.1): Color.clear, radius: 3, x: 4, y: 0)
            icon
                .renderingMode(.template)
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
                .foregroundColor(self.mainColor)
        }
        .frame(idealWidth: 150, idealHeight: 150, alignment: .center)
        .onAppear {
            setRate(name: self.name)
        }
    }
}

struct Diet_Previews: PreviewProvider {
    static var previews: some View {
        Diet(dietViewModel: DietViewModel(), profileViewModel: ProfileViewModel(), onDietViewModel: OnDietViewModel())
    }
}
