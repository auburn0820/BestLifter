//
//  OnWorkOut.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/04/20.
//

import SwiftUI

struct OnWorkOut: View {
    @State private var isBlur: Bool = false
    @State private var isCancelModal: Bool = false
    @State private var isCancelView: Bool = false
    @State private var isWorkoutView: Bool = false
    @State private var isWorkoutDone: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var onWorkoutViewModel = OnWorkoutViewModel()
    @ObservedObject var coreDataManager: CoreDataManager = .shared
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        GeometryReader { (geometry) in
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.easeOut(duration: 0.1)) {
                                self.isBlur.toggle()
                                self.isCancelView.toggle()
                            }
                        }, label: {
                            Text("취소")
                                .foregroundColor(Color.black)
                                .font(.system(size: 20, weight: .regular, design: .default))
                        })
                        .frame(width: 50, height: 30, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(lineWidth: 2)
                        )
                        
                        Button(action: {
                            withAnimation(.easeOut(duration: 0.1)) {
                                self.isBlur.toggle()
                                self.isWorkoutDone.toggle()
                            }
                        }, label: {
                            Text("확인")
                                .foregroundColor(Color.black)
                                .font(.system(size: 20, weight: .regular, design: .default))
                        })
                        .frame(width: 50, height: 30, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(lineWidth: 2)
                        )
                        .padding(.trailing, 20)
                    }
                    Text("Workout")
                        .font(.largeTitle)
                        .padding(.top, 20)
                        .padding(.leading, 20)
                        .frame(width: geometry.size.width, alignment: .leading)
                    
                    Text(onWorkoutViewModel.timerString)
                        .padding(.top, 20)
                        .padding(.leading, 20)
                        .frame(width: geometry.size.width, alignment: .leading)
                    
                    Divider()
                        .background(Color.black)
                        .padding()
                    
                    WorkoutList(onWorkoutViewModel: self.onWorkoutViewModel)
                    Divider()
                        .background(Color.black)
                    Button(action: {
                        self.isWorkoutView.toggle()
                    }, label: {
                        Text("운동 추가")
                            .foregroundColor(Color.black)
                            .frame(width: geometry.size.width - 40, height: 30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(lineWidth: 2)
                            )
                    })
                    .fullScreenCover(isPresented: $isWorkoutView) {
                        WorkoutsView(onWorkoutViewModel: onWorkoutViewModel)
                    }
                    .foregroundColor(Color.black)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    Spacer()
                }
            }
            .blur(radius: self.isBlur ? 10 : 0)
            .onAppear {
                onWorkoutViewModel.timerStart()
                onWorkoutViewModel.setDate()
            }
            
            if isCancelView {
                alertView
                    .padding()
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .transition(.asymmetric(insertion: .scale, removal: .scale))
            }
            
            if isWorkoutDone {
                workoutInsertAlertView
                    .padding()
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .transition(.asymmetric(insertion: .scale, removal: .scale))
            }
        }
    }
    
    var alertView: some View {
        ZStack {
            VStack() {
                Text("운동을 취소하시겠습니까?")
                    .padding(.bottom, 30)
                HStack(spacing: 30) {
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.1)) {
                            self.isBlur.toggle()
                            self.isCancelView.toggle()
                            self.presentationMode.wrappedValue.dismiss()
                            self.onWorkoutViewModel.program.excercises.removeAll()
                        }
                    }, label: {
                        Text("YES")
                            .foregroundColor(Color.red)
                    })
                    .frame(width: 60, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2)
                    )
                    
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.1)) {
                            self.isBlur.toggle()
                            self.isCancelView.toggle()
                        }
                    }, label: {
                        Text("NO")
                            .foregroundColor(Color.black)
                    })
                    .frame(width: 60, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2)
                    )
                }
            }
            .frame(width: 300, height: 200, alignment: .center)
            .background(Color.white.cornerRadius(10.0))
            .overlay(
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(lineWidth: 2)
            )
        }
    }
    
    var workoutInsertAlertView: some View {
        ZStack {
            VStack() {
                Text("운동을 완료하시겠습니까?")
                    .padding(.bottom, 30)
                HStack(spacing: 30) {
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.1)) {
                            withAnimation(.easeOut(duration: 0.1)) {
                                self.isWorkoutDone.toggle()
                                self.isBlur.toggle()
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            coreDataManager.addRoutine(totalWeight: onWorkoutViewModel.totalWeight, excercises: onWorkoutViewModel.program.excercises)
                            onWorkoutViewModel.saveBestSet()
                            profileViewModel.updateSBDWeights()
                        }
                    }, label: {
                        Text("YES")
                            .foregroundColor(Color.red)
                    })
                    .frame(width: 60, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2)
                    )
                    
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.1)) {
                            self.isWorkoutDone.toggle()
                            self.isBlur.toggle()
                        }
                    }, label: {
                        Text("NO")
                            .foregroundColor(Color.black)
                    })
                    .frame(width: 60, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2)
                    )
                }
            }
            .frame(width: 300, height: 200, alignment: .center)
            .background(Color.white.cornerRadius(10.0))
            .overlay(
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(lineWidth: 2)
            )
        }
    }
}

struct WorkoutsView: View {
    @ObservedObject var onWorkoutViewModel: OnWorkoutViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 20) {
                ForEach(onWorkoutViewModel.workouts, id: \.self) { workout in
                    Button(action: {
                        onWorkoutViewModel.addWorkout(name: workout)
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text(workout)
                            .foregroundColor(Color.black)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 60)
                    })
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2)
                    )
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        Divider()
            .background(Color.black)
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("취소")
                .foregroundColor(Color.black)
                .font(.system(size: 20, weight: .regular, design: .default))
                .frame(width: UIScreen.main.bounds.width - 40, height: 40)
        })
        .overlay(
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(lineWidth: 2)
        )
    }
}

struct WorkoutList: View {
    @ObservedObject var onWorkoutViewModel: OnWorkoutViewModel
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                // 운동 이력 리스트
                ScrollView(.vertical, showsIndicators: false, content: {
                    // 뷰 구조체가 겹쳐지는 문제가 발생함. 뷰 배열에 여러 개의 뷰를 담아야 함.
                    ForEach(onWorkoutViewModel.program.excercises, id: \.id) { workout in
                        WorkoutComponent(onWorkoutViewModel: onWorkoutViewModel, name: workout.name)
                            .frame(width: UIScreen.main.bounds.width)
                            .padding(.bottom, 10)
                            .animation(.easeOut(duration: 0.2))
                    }.animation(.easeOut(duration: 0.2))
                })
            }
        }
    }
}

struct WorkoutComponent: View {
    @ObservedObject var onWorkoutViewModel: OnWorkoutViewModel
    var name: String
    var sets: [Set]
    
    init(onWorkoutViewModel: OnWorkoutViewModel, name: String) {
        self.onWorkoutViewModel = onWorkoutViewModel
        self.name = name
        self.sets = onWorkoutViewModel.getSets(name: name)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text(name)
                .font(.system(size: 20))
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .padding(.leading, 20)
                .padding(.bottom, 10)
            
            SetComponents(onWorkoutViewModel: onWorkoutViewModel, name: name)
        }
    }
}

struct SetComponents: View {
    @ObservedObject var onWorkoutViewModel: OnWorkoutViewModel
    var sets: [Set]
    var name: String
    @State var curSet: Int = 0
    
    init(onWorkoutViewModel: OnWorkoutViewModel, name: String) {
        self.onWorkoutViewModel = onWorkoutViewModel
        self.name = name
        self.sets = onWorkoutViewModel.getSets(name: name)
    }
    
    var body: some View {
        ForEach(sets, id: \.setNum) { set in
            SetComponent(onWorkoutViewModel: onWorkoutViewModel, set: set, name: name)
        }
    
        Button(action: {
            onWorkoutViewModel.addSet(name: self.name, reps: -1, weight: -1)
            self.curSet += 1
        }, label: {
            Text("세트 추가")
                .foregroundColor(Color.black)
                .frame(width: 200, height: 25, alignment: .center)
        })
        .overlay(
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(lineWidth: 2)
        )
        .padding(.top, 10)
    }
    
    var setDeleteView: some View {
        Text("Hello, World!")
    }
}

struct SetComponent: View {
    @State var set: Set
    @State var weights: String = ""
    @State var reps: String = ""
    @State var checked: Bool = false
    @ObservedObject var onWorkoutViewModel: OnWorkoutViewModel
    var name: String
    
    init(onWorkoutViewModel: OnWorkoutViewModel, set: Set, name: String) {
        self.set = set
        self.onWorkoutViewModel = onWorkoutViewModel
        self.name = name
    }
    
    var body: some View {
        HStack {
            Text("\(set.setNum)")
                .padding(.leading, 20)
            HStack(spacing: 10) {
                TextField("Reps", text: $reps)
                    .multilineTextAlignment(.center)
                    .frame(height: 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2)
                    )
                    .background(Color.white.cornerRadius(10.0))
                TextField("Weights", text: $weights)
                    .multilineTextAlignment(.center)
                    .frame(height: 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2)
                    )
                    .background(Color.white.cornerRadius(10.0))
                
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            Button(action: {
                if self.reps != "", self.weights != "" {
                    self.checked.toggle()
                    self.onWorkoutViewModel.totalWeight += Int(weights)!
                    self.onWorkoutViewModel.totalVolume += (Int(weights)! * Int(reps)!)
                    self.onWorkoutViewModel.modifySetRepsAndWeights(name: name, setNum: set.setNum - 1, weight: Double(weights)!, reps: Int(reps)!)
                }
            }, label: {
                Image("checked")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(checked ? Color.white : Color.black)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
            })
            .cornerRadius(10.0)
            .frame(width: 30, height: 30)
            .background(checked ? Color.blue.cornerRadius(10.0) : Color.white.cornerRadius(10.0))
            .overlay(
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(lineWidth: 2)
            )
            
            Button("...", action: {
                onWorkoutViewModel.deleteSet(id: set.id, name: name)
            })
            .cornerRadius(10.0)
            .frame(width: 30, height: 30)
            .background(checked ? Color.blue.cornerRadius(10.0) : Color.white.cornerRadius(10.0))
            .overlay(
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(lineWidth: 2)
            )
            .padding(.trailing, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 20, height: 40)
        .background(checked ? Color.gray.cornerRadius(10.0) : Color.white.cornerRadius(10.0))
    }
}

struct OnWorkOut_Previews: PreviewProvider {
    static var previews: some View {
        OnWorkOut(profileViewModel: ProfileViewModel())
    }
}
