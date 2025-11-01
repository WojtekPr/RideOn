//
//  MetricView.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 01/11/2025.
//

// MetricView.swift
import SwiftUI

struct MetricView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.largeTitle)
                .fontWeight(.black)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}


#Preview {
    MetricView(title: "Dystans", value: "10.5 km")
}
