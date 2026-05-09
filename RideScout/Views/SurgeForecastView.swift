import SwiftUI

struct SurgeForecastView: View {
    @State private var showingHeatmap = false
    @State private var showingAlertDetails = false
    @State private var selectedAlert: String? = nil
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.rsBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Spacer().frame(height: 80)
                    
                    // Extreme Surge Status
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("CURRENT STATUS")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.rsOnSurfaceVariant)
                                Text("Extreme Surge")
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundColor(.rsOnSurface)
                            }
                            Spacer()
                            HStack(spacing: 4) {
                                Image(systemName: "bolt.fill").font(.system(size: 14))
                                Text("2.4x").font(.system(size: 11, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color(hex: "CD4802"))
                            .clipShape(Capsule())
                        }
                        
                        ZStack(alignment: .bottomTrailing) {
                            Rectangle()
                                .fill(Color.rsSurfaceHighlight)
                                .frame(height: 192)
                                .cornerRadius(12)
                                .overlay(
                                    Image(systemName: "map.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(40)
                                        .foregroundColor(.white.opacity(0.1))
                                )
                            
                            Button(action: { showingHeatmap = true }) {
                                HStack {
                                    Image(systemName: "map")
                                    Text("Open Heatmap")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                                .foregroundColor(.rsBackground)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(8)
                                .padding(16)
                            }
                        }
                    }
                    .padding()
                    .glassCard()
                    .padding(.horizontal, 24)
                    
                    // Surge Forecast
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Surge Forecast")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.rsOnSurface)
                            Spacer()
                            Text("Next 60m")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.rsOnSurfaceVariant)
                        }
                        
                        VStack {
                            Spacer()
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: 80))
                                path.addQuadCurve(to: CGPoint(x: 100, y: 40), control: CGPoint(x: 50, y: 70))
                                path.addQuadCurve(to: CGPoint(x: 200, y: 20), control: CGPoint(x: 150, y: 10))
                                path.addQuadCurve(to: CGPoint(x: 300, y: 60), control: CGPoint(x: 250, y: 80))
                                path.addQuadCurve(to: CGPoint(x: 400, y: 30), control: CGPoint(x: 350, y: 40))
                            }
                            .stroke(Color.rsSecondary, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                            .frame(height: 100)
                            .padding(.horizontal, -20)
                            
                            Divider().background(Color.white.opacity(0.05)).padding(.top, 16)
                            
                            HStack {
                                Text("NOW").font(.system(size: 11, weight: .bold)).foregroundColor(.rsOnSurfaceVariant)
                                Spacer()
                                Text("15m").font(.system(size: 11, weight: .bold)).foregroundColor(.rsOnSurfaceVariant)
                                Spacer()
                                Text("30m").font(.system(size: 11, weight: .bold)).foregroundColor(.rsOnSurfaceVariant)
                                Spacer()
                                Text("45m").font(.system(size: 11, weight: .bold)).foregroundColor(.rsOnSurfaceVariant)
                                Spacer()
                                Text("1.2x").font(.system(size: 11, weight: .bold)).foregroundColor(.rsSecondary)
                            }
                            .padding(.top, 8)
                        }
                        .padding()
                        .frame(height: 128)
                        .glassCard()
                    }
                    .padding(.horizontal, 24)
                    
                    // Surge-Free Windows
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Surge-Free Windows")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.rsOnSurface)
                            .padding(.horizontal, 24)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                Spacer().frame(width: 8)
                                
                                Button(action: { showDetails("LIKELY NORMAL") }) {
                                    WindowCard(status: "LIKELY NORMAL", color: .rsTertiary, time: "In 12 min", platform: "UberX / Lyft")
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Button(action: { showDetails("PRICE DROP") }) {
                                    WindowCard(status: "PRICE DROP", color: .rsPrimary, time: "In 24 min", platform: "Uber Black")
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Spacer().frame(width: 8)
                            }
                        }
                    }
                    
                    Spacer().frame(height: 100)
                }
            }
            
            TopAppBar(title: "Surge Radar")
        }
        .sheet(isPresented: $showingHeatmap) {
            NavigationView {
                Text("Full Interactive City Heatmap View").navigationTitle("Heatmap")
                    .navigationBarItems(trailing: Button("Close") { showingHeatmap = false })
            }
        }
        .alert(isPresented: $showingAlertDetails) {
            Alert(title: Text("Window Alert: \(selectedAlert ?? "")"), message: Text("We will notify you via Apple Watch and iPhone Notification when this window arrives."), dismissButton: .default(Text("Got it")))
        }
    }
    
    private func showDetails(_ alert: String) {
        selectedAlert = alert
        showingAlertDetails = true
    }
}

struct WindowCard: View {
    var status: String
    var color: Color
    var time: String
    var platform: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(status)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(color)
            Text(time)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.rsOnSurface)
            Text(platform)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.rsOnSurfaceVariant)
        }
        .padding(16)
        .frame(minWidth: 180, alignment: .leading)
        .background(Color.rsSurface.opacity(0.7))
        .background(Material.ultraThinMaterial)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
        )
        .overlay(
            Rectangle()
                .fill(color)
                .frame(width: 4)
                .padding(.vertical, 16),
            alignment: .leading
        )
    }
}

#Preview { SurgeForecastView() }
