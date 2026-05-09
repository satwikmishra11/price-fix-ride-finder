import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            SurgeForecastView()
                .tabItem {
                    Label("Surge Radar", systemImage: "waveform.path.ecg")
                }
            
            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.fill")
                }
            
            ProSubscriptionView()
                .tabItem {
                    Label("Scout Pro", systemImage: "star.fill")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
}
