//
//  SleepMonitoringView.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//


import SwiftUI

struct SleepMonitoringView: View {
    @StateObject private var postureManager = SleepPostureManager()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 현재 수면 자세 상태 카드
                CurrentPostureCard(postureManager: postureManager)
                
                // 모니터링 컨트롤
                MonitoringControlPanel(postureManager: postureManager)
                
                if !postureManager.postureHistory.isEmpty {
                    // 자세 히스토리
                    PostureHistoryList(history: postureManager.postureHistory)
                    
                    // 수면 리포트 버튼
                    NavigationLink(destination: SleepReportView(postureManager: postureManager)) {
                        Text("수면 리포트 보기")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("수면 자세 모니터링")
            .padding()
        }
    }
}
