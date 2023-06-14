//
//  SolidCalculationView.swift
//  SwiftApp_UIver
//
//  Created by user on 2023/06/14.
//

import SwiftUI

struct SolidCalculationView: View {
    @State var diameter = ""
    @State var axialForceCalculationResult = ""
    @State var axialForceCalculationLowerResult = ""
    @State var axialForceCalculationUpperResult = ""
    @State var bendingForceCalculationResult = ""
    @State var bendingForceCalculationLowerResult = ""
    @State var bendingForceCalculationUpperResult = ""
    @State var twistForceCalculationResult = ""
    @State var twistForceCalculationLowerResult = ""
    @State var twistForceCalculationUpperResult = ""
    
    let materials = ["軟鉄","アルミ","鋳鉄"]
    @State var selectedMaterial = "軟鉄"
    
    var body: some View {
        //        Text("中実丸棒を計算するページ")
        VStack {
            HStack {
                Spacer()
                TextField("直径を入力(単位mm)", text: $diameter)
                    .font(.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
                Spacer()
            }
            .padding(25)
            HStack {
                Spacer()
                Picker("材質", selection: $selectedMaterial) {
                    ForEach(materials, id: \.self) { material in
                        Text(material)
                    }
                }
                Spacer()
            }
            .padding(25)
            HStack {
                Text("軸力計算値")
                    .padding(.trailing,50)
                Text(axialForceCalculationResult)
                Text("N/μ")
            }
            .font(.title)
            .padding(.top, 25)
            HStack {
                Text("校正許容範囲＝")
                    .padding(.trailing,10)
                Text(axialForceCalculationLowerResult)
                Text("〜")
                Text(axialForceCalculationUpperResult)
            }
            .font(.callout)
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
            .font(.callout)
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
            .font(.callout)
            .padding(.bottom, 25)
//            Spacer()
            HStack {
                Button(action: {
                    guard let doubleDiameter = Double(diameter) else { return }
                    Calculation(diameter: doubleDiameter)
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
            .padding(.bottom, 200)
//            Spacer()
        }
    }
    
    private func Calculation(diameter: Double) {
        //選ばれた材質によって縦弾性係数を変更する
        var materialCoefficient:Double = 0
        
        switch selectedMaterial {
        case "軟鉄":
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
        let A = pi / 4 * pow(diameter, 2)
        let bendingZp = pi / 32 * pow(diameter, 3)
        let twistZp = pi / 16 * pow(diameter, 3)
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
