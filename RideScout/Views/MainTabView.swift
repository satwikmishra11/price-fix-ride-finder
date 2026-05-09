import SwiftUI

struct MainTabView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(Color.rsSurface.opacity(0.8))
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor(Color.rsOnSurfaceVariant.opacity(0.6))
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(Color.rsOnSurfaceVariant.opacity(0.6))]
        itemAppearance.selected.iconColor = UIColor(Color.rsPrimary)
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color.rsPrimary)]
        
        appearance.stackedLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            SurgeForecastView()
                .tabItem {
                    Label("Surge", systemImage: "bolt.fill")
                }
            
            PlannerView()
                .tabItem {
                    Label("Planner", systemImage: "calendar")
                }
            
            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.fill")
                }
        }
        .accentColor(.rsPrimary)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MainTabView()
}
