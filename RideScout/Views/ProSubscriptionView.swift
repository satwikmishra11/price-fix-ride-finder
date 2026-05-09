import SwiftUI

struct ProSubscriptionView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Image(systemName: "star.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.yellow)
                    .padding(.bottom, 20)
                
                Text("RideScout Pro ★")
                    .font(.largeTitle)
                    .bold()
                
                Text("Unlock the full Apple ecosystem.")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 40)
                
                VStack(alignment: .leading, spacing: 20) {
                    FeatureRow(icon: "bell.badge.fill", title: "Predictive Surge Alerts", subtitle: "Get Watch notifications when fares drop.")
                    FeatureRow(icon: "wallet.pass.fill", title: "Apple Wallet Receipts", subtitle: "Auto-export GST invoices to Wallet.")
                    FeatureRow(icon: "car.top.radiowaves.rear.left", title: "CarPlay Dashboard", subtitle: "Hands-free booking via Siri while driving.")
                    FeatureRow(icon: "shield.lefthalf.filled", title: "Driver Trust Scoring", subtitle: "Filter out drivers below 3.8 stars.")
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                Button(action: {
                    // Apple Pay flow mock
                }) {
                    HStack {
                        Image(systemName: "applelogo")
                        Text("Pay  ₹149 / month")
                            .bold()
                    }
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(16)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title2)
                .frame(width: 30)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    ProSubscriptionView()
}
