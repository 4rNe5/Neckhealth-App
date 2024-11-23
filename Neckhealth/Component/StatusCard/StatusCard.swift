//
//  StatusCard.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//
import SwiftUI

struct StatusCard: View {
    let type: StatusType
    let message: String
    let subMessage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: type.icon)
                    .foregroundColor(type.color)
                    .frame(width: 30, height: 30)
                Text(type.title)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            Text(message)
                .font(.subheadline)
            
            Text(subMessage)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}
