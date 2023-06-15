//
//  HollowCaluculationView.swift
//  SwiftApp_UIver
//
//  Created by user on 2023/06/14.
//

import SwiftUI

struct HollowCalculationView: View {
    @State var outerDiameter = ""
    @State var innerDiameter = ""
    @State var axialForceCalculationResult = ""
    @State var axialForceCalculationLowerResult = ""
    @State var axialForceCalculationUpperResult = ""
    @State var bendingForceCalculationResult = ""
    @State var bendingForceCalculationLowerResult = ""
    @State var bendingForceCalculationUpperResult = ""
    @State var twistForceCalculationResult = ""
    @State var twistForceCalculationLowerResult = ""
    @State var twistForceCalculationUpperResult = ""
    
    let materials = ["軟鋼","アルミ","鋳鉄"]
    @State var selectedMaterial = "軟鋼"
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                TextField("外径を入力(単位mm)", text: $outerDiameter)
                    .font(.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
                Spacer()
            }
            .padding(.bottom, 10)
            
            HStack{
                Spacer()
                TextField("内径を入力(単位mm)", text: $innerDiameter)
                    .font(.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
                Spacer()
            }
            .padding(10)
            HStack{
                Spacer()
                Picker("材質をえらんでください", selection: $selectedMaterial) {
                    ForEach(materials, id: \.self) { material in
                        Text(material)
                    }
                }
                Spacer()
            }
            .padding(10)
            HStack {
                Text("軸力計算値")
                    .padding(.trailing,50)
                Text(axialForceCalculationResult)
                Text("N/μ")

            }
            .font(.title)
            .padding(.top, 10)
            
            HStack {
                Text("校正許容範囲＝")
                    .padding(.trailing,10)
                Text(axialForceCalculationLowerResult)
                Text("〜")
                Text(axialForceCalculationUpperResult)
            }
            .font(.headline)
            .padding(.bottom, 25)
            
            HStack {
                Text("曲げ計算値")
                    .padding(.trailing,50)
                Text(bendingForceCalculationResult)
                Text("Nm/μ")
            }
            .font(.title)
            .padding(.top, 25)
            
            HStack {
                Text("校正許容範囲＝")
                    .padding(.trailing,10)
                Text(bendingForceCalculationLowerResult)
                Text("〜")
                Text(bendingForceCalculationUpperResult)
            }
            .font(.headline)
            .padding(.bottom, 25)
            
            HStack {
                Text("捩り計算値")
                    .padding(.trailing,50)
                Text(twistForceCalculationResult)
                Text("Nm/μ")
            }
            .font(.title)
            .padding(.top, 25)
            
            HStack {
                Text("校正許容範囲＝")
                    .padding(.trailing,10)
                Text(twistForceCalculationLowerResult)
                Text("〜")
                Text(twistForceCalculationUpperResult)
            }
            .font(.headline)
            .padding(.bottom, 25)
            
            HStack {
                Button(action: {
                    guard let doubleOuterDiameter = Double(outerDiameter) else { return }
                    guard let doubleInnerDiameter = Double(innerDiameter) else { return }
                    Calculation(outerDiameter: doubleOuterDiameter, innerDiameter: doubleInnerDiameter)
                }){
                    Text("計算")
                        .font(.title)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .multilineTextAlignment(.center)
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
        }
    }
    
    private func Calculation(outerDiameter: Double, innerDiameter: Double) {
        //選ばれた材質によって縦弾性係数を変更する
        var materialCoefficient:Double = 0
        
        switch selectedMaterial {
        case "軟鋼":
            materialCoefficient = 0.2058
        case "アルミ":
            materialCoefficient = 0.0680
        case "鋳鉄":
            materialCoefficient = 0.1617
        default:
            break
        }
        
        //計算ロジック
        let pi = Double.pi
        let A = pi / 4 * (pow(outerDiameter, 2) - pow(innerDiameter, 2))
        let bendingZp = pi / 32 * ((pow(outerDiameter, 4) - pow(innerDiameter, 4)) / outerDiameter)
        let twistZp = pi / 16 * ((pow(outerDiameter, 4) - pow(innerDiameter, 4)) / outerDiameter)
        let axialResult = 1 / (1 / (A * materialCoefficient) * 2.6)
        let bendingResult = 1 / (1 / (bendingZp * materialCoefficient) * 2)
        let twistResult = 1 / (1 / (twistZp * materialCoefficient) * 5.2)
        
        DispatchQueue.main.async {
            axialForceCalculationResult = String(floor(axialResult * 10) / 10)
            axialForceCalculationLowerResult = String(floor(axialResult * 10 * 0.95) / 10)
            axialForceCalculationUpperResult = String(floor(axialResult * 10 * 1.05) / 10)
            bendingForceCalculationResult = String(floor(bendingResult * 10) / 10)
            bendingForceCalculationLowerResult = String(floor(bendingResult * 10 * 0.95) / 10)
            bendingForceCalculationUpperResult = String(floor(bendingResult * 10 * 1.05) / 10)
            twistForceCalculationResult = String(floor(twistResult * 10) / 10)
            twistForceCalculationLowerResult = String(floor(twistResult * 10 * 0.95) / 10)
            twistForceCalculationUpperResult = String(floor(twistResult * 10 * 1.05) / 10)
        }
    }
}
