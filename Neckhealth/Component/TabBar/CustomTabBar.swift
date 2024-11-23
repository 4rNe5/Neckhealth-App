//
//  CustomTabBar.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//
import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    @Namespace private var namespace
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                TabItem(
                    systemName: tab.systemImage,
                    title: tab.rawValue,
                    isSelected: selectedTab == tab,
                    namespace: namespace
                )
                .onTapGesture {
                    print("Before: \(selectedTab), Tap: \(tab)")
                    guard selectedTab != tab else {
                        print("Duplicate tap on \(tab.rawValue)")
                        return
                    }
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                        print("After: \(selectedTab)")
                    }
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}
