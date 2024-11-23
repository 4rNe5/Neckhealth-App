//
//  SleepReportView.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//
import SwiftUI


struct SleepReportView: View {
    let postureManager: SleepPostureManager
    
    var body: some View {
        let report = postureManager.generateSleepReport()
        
        ScrollView {
            VStack(spacing: 20) {
                // 총 수면 시간
                VStack {
                    Text("총 수면 시간")
                        .font(.headline)
                    Text("\(Int(report.totalSleepDuration / 3600))시간 \(Int((report.totalSleepDuration.truncatingRemainder(dividingBy: 3600)) / 60))분")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // 자세별 비율
                VStack(alignment: .leading, spacing: 10) {
                    Text("자세별 비율")
                        .font(.headline)
                    
                    ForEach(Array(report.posturePercentages.keys.sorted { $0.description < $1.description }), id: \.self) { posture in
                        if let percentage = report.posturePercentages[posture] {
                            PosturePercentageRow(posture: posture, percentage: percentage)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // 추천사항
                if !report.recommendations.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("추천사항")
                            .font(.headline)
                        
                        ForEach(report.recommendations, id: \.self) { recommendation in
                            Text("• \(recommendation)")
                                .font(.subheadline)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("수면 리포트")
    }
}
