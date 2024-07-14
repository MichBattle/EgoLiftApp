import SwiftUI

struct WaterIntakeWidget: View {
    @State private var dailyGoal: Double = UserDefaults.standard.double(forKey: "dailyGoal") == 0 ? 2000 : UserDefaults.standard.double(forKey: "dailyGoal")
    @State private var waterConsumed: Double = UserDefaults.standard.double(forKey: "waterConsumed")
    @State private var isEditingGoal: Bool = false
    @State private var newDailyGoal: Double = 2000 // Default value for picker
    @State private var showResetAlert: Bool = false

    let goalOptions: [Double] = Array(stride(from: 1000.0, to: 10000.0, by: 1000.0))

    var body: some View {
        VStack {
            HStack {
                CircularProgressBar(progress: waterConsumed / dailyGoal)
                    .frame(width: 110, height: 110)
                    .onTapGesture {
                        showResetAlert = true
                    }
                    .alert(isPresented: $showResetAlert) {
                        Alert(
                            title: Text("Reset Water Intake"),
                            message: Text("Are you sure you want to reset your water intake?"),
                            primaryButton: .destructive(Text("Reset")) {
                                waterConsumed = 0
                                UserDefaults.standard.set(waterConsumed, forKey: "waterConsumed")
                            },
                            secondaryButton: .cancel()
                        )
                    }

                VStack(alignment: .center) {
                    if isEditingGoal {
                        Picker("Select Goal", selection: $newDailyGoal) {
                            ForEach(goalOptions, id: \.self) { goal in
                                Text("\(Int(goal)) ml").tag(goal)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(WheelPickerStyle())
                    } else {
                        VStack {
                            Text("Water goal")
                                .font(.headline)
                                .onTapGesture {
                                    newDailyGoal = dailyGoal
                                    isEditingGoal.toggle()
                                }
                            Text("\(Int(dailyGoal)) ml")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.leading, -15)  // Reduced leading padding

                Spacer()

                VStack {
                    Button(action: {
                        waterConsumed += 500
                        if waterConsumed > dailyGoal { waterConsumed = dailyGoal }
                        UserDefaults.standard.set(waterConsumed, forKey: "waterConsumed")
                    }) {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }

                    Button(action: {
                        waterConsumed -= 500
                        if waterConsumed < 0 { waterConsumed = 0 }
                        UserDefaults.standard.set(waterConsumed, forKey: "waterConsumed")
                    }) {
                        Image(systemName: "minus.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)

            if isEditingGoal {
                HStack {
                    Button(action: {
                        dailyGoal = newDailyGoal
                        UserDefaults.standard.set(dailyGoal, forKey: "dailyGoal")
                        isEditingGoal.toggle()
                    }) {
                        Text("Save")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        isEditingGoal.toggle()
                    }) {
                        Text("Cancel")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            loadData()
        }
    }

    private func loadData() {
        dailyGoal = UserDefaults.standard.double(forKey: "dailyGoal")
        waterConsumed = UserDefaults.standard.double(forKey: "waterConsumed")
    }
}

struct CircularProgressBar: View {
    var progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10.0)
                .opacity(0.3)
                .foregroundColor(Color.gray)

            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(progress >= 1.0 ? Color.green : Color.blue)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)

            Text(String(format: "%.0f%%", min(progress, 1.0) * 100.0))
                .font(progress >= 1.0 ? .title : .largeTitle)
                .bold()
        }
    }
}
