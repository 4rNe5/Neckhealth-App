//
//  CurrentPostureCard.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//
import SwiftUI

struct CurrentPostureCard: View {
    @ObservedObject var postureManager: SleepPostureManager
    
    var body: some View {
        VStack(spacing: 12) {
            Text("현재 수면 자세")
                .font(.headline)
            
            Text(postureManager.currentPosture.description)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(postureManager.currentPosture.recommendation)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
