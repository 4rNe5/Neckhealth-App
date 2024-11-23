//
//  Tab.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//


// 탭 아이템 모델
enum Tab: String, CaseIterable {
    case turtleNeck = "거북목 감지"
    case stress = "스트레스 측정"
    case settings = "설정"
    
    var systemImage: String {
        switch self {
        case .turtleNeck: return "figure.seated.side.right.air.distribution.middle"
        case .stress: return "heart.text.square"
        case .settings: return "gear"
        }
    }
}
