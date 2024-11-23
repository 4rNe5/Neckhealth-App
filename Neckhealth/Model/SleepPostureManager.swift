//
//  SleepPosture.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//


//
//  StressView.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//
import SwiftUI
import CoreMotion
import Combine


class SleepPostureManager: ObservableObject {
    private var motionManager = CMHeadphoneMotionManager()
    private var timer: Timer?
    
    @Published var currentPosture: SleepPosture = .unknown
    @Published var postureHistory: [PostureRecord] = []
    @Published var isMonitoring: Bool = false
    
    struct PostureRecord: Identifiable {
        let id = UUID()
        let posture: SleepPosture
        let timestamp: Date
        let duration: TimeInterval
    }
    
    enum SleepPosture: Hashable {  // Hashable 프로토콜 추가
            case supine      // 바로 누움
            case leftSide    // 왼쪽으로 누움
            case rightSide   // 오른쪽으로 누움
            case prone       // 엎드려 누움
            case unknown     // 알 수 없음
            
            var description: String {
                switch self {
                case .supine: return "바로 누운 자세"
                case .leftSide: return "왼쪽으로 누운 자세"
                case .rightSide: return "오른쪽으로 누운 자세"
                case .prone: return "엎드린 자세"
                case .unknown: return "자세 분석 중"
                }
            }
            
            var recommendation: String {
                switch self {
                case .supine: return "편안한 자세입니다. 목 아래 얇은 베개를 사용하면 더 좋습니다."
                case .leftSide: return "양호한 자세입니다. 무릎 사이에 베개를 끼우면 더 편안할 수 있습니다."
                case .rightSide: return "양호한 자세입니다. 무릎 사이에 베개를 끼우면 더 편안할 수 있습니다."
                case .prone: return "목과 허리에 무리가 갈 수 있는 자세입니다. 자세 변경을 추천드립니다."
                case .unknown: return "자세를 분석중입니다."
                }
            }
        }
    
    init() {
        setupMotionManager()
    }
    
    private func setupMotionManager() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Headphone motion is not available")
            return
        }
    }
    
    func startMonitoring() {
        isMonitoring = true
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { [weak self] motion, error in
            guard let self = self,
                  let motion = motion,
                  error == nil else {
                return
            }
            
            // 자세 분석
            self.analyzePosture(motion: motion)
        }
        
        // 5분마다 자세 기록
        timer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.recordCurrentPosture()
        }
    }
    
    private func analyzePosture(motion: CMDeviceMotion) {
        let pitch = motion.attitude.pitch
        let roll = motion.attitude.roll
        
        // 자세 판단 로직
        let newPosture: SleepPosture = {
            // pitch와 roll 값을 기반으로 자세 판단
            if abs(pitch) < 0.3 && abs(roll) < 0.3 {
                return .supine
            } else if roll > 1.0 {
                return .leftSide
            } else if roll < -1.0 {
                return .rightSide
            } else if abs(pitch) > 1.3 {
                return .prone
            }
            return .unknown
        }()
        
        if newPosture != currentPosture {
            currentPosture = newPosture
            // 급격한 자세 변화 감지 시 알림
            if newPosture == .prone {
                sendPostureAlert()
            }
        }
    }
    
    private func recordCurrentPosture() {
        let record = PostureRecord(
            posture: currentPosture,
            timestamp: Date(),
            duration: 300 // 5분
        )
        postureHistory.append(record)
    }
    
    private func sendPostureAlert() {
        // 알림 발송 로직
        if currentPosture == .prone {
            // 엎드린 자세에 대한 경고
            NotificationManager.shared.sendNotification(
                title: "수면 자세 알림",
                body: "목 건강을 위해 자세를 바로 누운 자세나 옆으로 누운 자세로 변경해주세요."
            )
        }
    }
    
    func stopMonitoring() {
        isMonitoring = false
        motionManager.stopDeviceMotionUpdates()
        timer?.invalidate()
        timer = nil
    }
    
    func generateSleepReport() -> SleepReport {
        // 수면 리포트 생성
        let totalDuration = postureHistory.reduce(0) { $0 + $1.duration }
        let posturePercentages = Dictionary(grouping: postureHistory, by: { $0.posture })
            .mapValues { records in
                let postureDuration = records.reduce(0) { $0 + $1.duration }
                return (postureDuration / totalDuration) * 100
            }
        
        return SleepReport(
            date: Date(),
            totalSleepDuration: totalDuration,
            posturePercentages: posturePercentages,
            recommendations: generateRecommendations(from: posturePercentages)
        )
    }
    
    private func generateRecommendations(from percentages: [SleepPosture: Double]) -> [String] {
        var recommendations: [String] = []
        
        // 자세 분포에 따른 맞춤형 추천사항 생성
        if let pronePercentage = percentages[.prone], pronePercentage > 20 {
            recommendations.append("엎드려 자는 시간이 많습니다. 목 건강을 위해 바로 눕거나 옆으로 누워주세요.")
        }
        
        if let supinePercentage = percentages[.supine], supinePercentage < 30 {
            recommendations.append("바로 누워 자는 시간을 조금 더 늘려보세요.")
        }
        
        return recommendations
    }
}

// 수면 리포트 구조체
struct SleepReport {
    let date: Date
    let totalSleepDuration: TimeInterval
    let posturePercentages: [SleepPostureManager.SleepPosture: Double]
    let recommendations: [String]
}

// 알림 매니저
class NotificationManager {
    static let shared = NotificationManager()
    
    func sendNotification(title: String, body: String) {
        // 로컬 알림 발송 로직
    }
}
