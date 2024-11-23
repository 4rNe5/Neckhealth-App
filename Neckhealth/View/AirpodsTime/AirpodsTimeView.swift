//
//  AirpodsTimeView.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//

import SwiftUI
import CoreData
import HealthKit

struct AirpodsTimeView: View {
    @State private var selectedDate = Date()
    @State private var usageTime: TimeInterval?
    @State private var showingHealthKitPermission = false
    
    private let healthManager = HeadphoneUsageManager.shared
    private let coreDataManager = CoreDataManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            Text("나의")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            Text("에어팟 착용시간")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            if let usage = usageTime {
                Text(formatDuration(usage))
                    .font(.system(size: 36, weight: .bold))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .shadow(radius: 5)
                    )
            } else {
                Text("데이터 없음")
                    .font(.system(size: 36, weight: .bold))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .shadow(radius: 5)
                    )
            }
            
            CalendarView(selectedDate: $selectedDate)
                .padding()
                .onChange(of: selectedDate) { newDate in
                    loadUsageData(for: newDate)
                }
        }
        .onAppear {
            requestHealthKitPermission()
        }
        .alert("HealthKit 권한 필요", isPresented: $showingHealthKitPermission) {
            Button("확인") {}
        } message: {
            Text("에어팟 사용 시간을 기록하기 위해 HealthKit 접근 권한이 필요합니다.")
        }
    }
    
    private func requestHealthKitPermission() {
        healthManager.requestAuthorization { success, error in
            if success {
                loadUsageData(for: selectedDate)
            } else {
                showingHealthKitPermission = true
            }
        }
    }
    
    private func loadUsageData(for date: Date) {
        if let savedUsage = coreDataManager.getUsage(for: date) {
            usageTime = savedUsage
        } else {
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            healthManager.fetchHeadphoneUsageTime(start: startOfDay, end: endOfDay) { duration, error in
                if let duration = duration {
                    usageTime = duration
                    coreDataManager.saveUsage(date: date, duration: duration)
                } else {
                    usageTime = nil
                }
            }
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        return "\(hours)h \(minutes)m"
    }
}
