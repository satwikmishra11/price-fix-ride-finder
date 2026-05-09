import SwiftUI

struct AnalyticsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Cross Platform Spend
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Monthly Spend: ₹4,250")
                            .font(.title2)
                            .bold()
                        
                        Text("Aggregated across all platforms via Apple Mail receipt parsing.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Uber")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("₹2,100")
                                    .font(.headline)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Ola")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("₹1,500")
                                    .font(.headline)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Metro")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("₹650")
                                    .font(.headline)
                            }
                        }
                        .padding()
                        .background(Color(UIColor.tertiarySystemBackground))
                        .cornerRadius(12)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    
                    // Eco Tracker
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "leaf.fill")
                                .foregroundColor(.green)
                            Text("Carbon Footprint Tracker")
                                .font(.title3)
                                .bold()
                        }
                        
                        HStack {
                            Text("14.2 kg CO₂ Saved")
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(.green)
                            Spacer()
                        }
                        
                        Text("You've reduced your footprint by taking the Metro 12 times this month instead of a cab.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    
                    // Group Cost Split (Apple Cash Mock)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "dollarsign.circle.fill")
                                .foregroundColor(.blue)
                            Text("Split Fares via Apple Cash")
                                .font(.title3)
                                .bold()
                        }
                        
                        Text("Recent splits")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: -10) {
                            Circle().fill(Color.red).frame(width: 40, height: 40)
                            Circle().fill(Color.blue).frame(width: 40, height: 40)
                            Circle().fill(Color.green).frame(width: 40, height: 40)
                            Spacer()
                            Button(action: {}) {
                                Text("Request ₹150")
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.black)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                }
                .padding()
            }
            .navigationTitle("Intelligence")
        }
    }
}

#Preview {
    AnalyticsView()
}
