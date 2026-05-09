import SwiftUI

struct SurgeForecastView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Surge Alert Banner
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                        VStack(alignment: .leading) {
                            Text("High Surge Detected")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Uber is 1.8x. Likely surge-free in ~30 min.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                    }
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(16)
                    
                    Text("Surge Heatmap (Next 2 Hours)")
                        .font(.title3)
                        .bold()
                        .padding(.top)
                    
                    // Mock Graph
                    VStack {
                        HStack(alignment: .bottom, spacing: 12) {
                            ForEach(0..<12) { i in
                                VStack {
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(i < 3 ? Color.red : (i < 6 ? Color.orange : Color.green))
                                        .frame(width: 20, height: CGFloat.random(in: 30...150))
                                    Text("\(10 + (i * 10))m")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .frame(height: 180)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    
                    // Smart Alerts
                    Text("Smart Commute Learning")
                        .font(.title3)
                        .bold()
                        .padding(.top)
                    
                    HStack(spacing: 16) {
                        Image(systemName: "brain.head.profile")
                            .font(.largeTitle)
                            .foregroundColor(.purple)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Core ML Intelligence")
                                .font(.headline)
                            Text("We noticed you usually leave for 'Work' at 9:15 AM. Fares drop by 20% if you leave at 9:00 AM instead.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                }
                .padding()
            }
            .navigationTitle("Surge Radar")
        }
    }
}

#Preview {
    SurgeForecastView()
}
