import SwiftUI

struct AnalyticsView: View {
    @State private var showingReportAlert = false
    @State private var showingTrendInfo = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.rsBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Spacer().frame(height: 80)
                    
                    // Monthly Spend
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("TOTAL MONTHLY SPEND")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.rsOnSurfaceVariant)
                                Text("$1,248.50")
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundColor(.rsOnSurface)
                            }
                            Spacer()
                            Button(action: { showingTrendInfo = true }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "arrow.down").font(.system(size: 14))
                                    Text("12.4%").font(.system(size: 13, weight: .bold))
                                }
                                .foregroundColor(.rsSuccess)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.rsSuccess.opacity(0.1))
                                .overlay(Capsule().stroke(Color.rsSuccess.opacity(0.2), lineWidth: 1))
                                .clipShape(Capsule())
                            }
                        }
                        
                        HStack(alignment: .bottom, spacing: 2) {
                            ForEach([0.4, 0.55, 0.45, 0.7, 0.6, 0.85, 1.0], id: \.self) { val in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(val == 1.0 ? Color.rsPrimary : Color.rsPrimary.opacity(0.2))
                                    .frame(height: 64 * val)
                            }
                        }
                        .frame(height: 64)
                        
                        Text("vs. $1,425.00 last month")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.rsOnSurfaceVariant)
                    }
                    .padding()
                    .glassCard()
                    .padding(.horizontal, 24)
                    
                    // Grid
                    VStack(spacing: 12) {
                        // Eco Report Card
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Eco-Report Card")
                                    .font(.system(size: 17, weight: .semibold))
                                Spacer()
                                Text("ECO-HERO")
                                    .font(.system(size: 11, weight: .bold))
                                    .tracking(1)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color.rsSuccess)
                                    .clipShape(Capsule())
                            }
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("CO2 SAVED").font(.system(size: 11, weight: .bold)).foregroundColor(.rsOnSurfaceVariant)
                                    Text("42.8 kg").font(.system(size: 20, weight: .bold)).foregroundColor(.rsSuccess)
                                }
                                Spacer()
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("TREE EQUIVALENT").font(.system(size: 11, weight: .bold)).foregroundColor(.rsOnSurfaceVariant)
                                    Text("2.4 Trees").font(.system(size: 20, weight: .bold)).foregroundColor(.rsSuccess)
                                }
                                Spacer()
                            }
                        }
                        .padding()
                        .glassCard(glowColor: .rsSuccess)
                        .overlay(Rectangle().fill(Color.rsSuccess).frame(width: 4).padding(.vertical, 16), alignment: .leading)
                        
                        // Insights
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Efficiency Insight")
                                .font(.system(size: 17, weight: .semibold))
                            Text("By switching 3 work trips to the \"Eco-Saver\" option last week, you saved an average of $8.20 per ride and reduced your carbon footprint by 4.2kg.")
                                .font(.system(size: 15))
                                .foregroundColor(.rsOnSurfaceVariant)
                                .lineSpacing(4)
                            
                            Button(action: { showingReportAlert = true }) {
                                HStack {
                                    Text("Download Full Report")
                                    Image(systemName: "square.and.arrow.down")
                                }
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.rsPrimaryContainer)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.rsPrimary.opacity(0.1))
                                .cornerRadius(12)
                            }
                            .padding(.top, 8)
                        }
                        .padding()
                        .glassCard()
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer().frame(height: 100)
                }
            }
            
            TopAppBar(title: "Analytics")
        }
        .alert(isPresented: $showingReportAlert) {
            Alert(title: Text("Report Saved"), message: Text("Your full PDF report has been saved to the Files app."), dismissButton: .default(Text("Awesome")))
        }
        .alert(isPresented: $showingTrendInfo) {
            Alert(title: Text("Spending Trend"), message: Text("You are spending 12.4% less on transport this month mainly due to increased Metro usage."), dismissButton: .default(Text("Got it")))
        }
    }
}

#Preview { AnalyticsView() }
