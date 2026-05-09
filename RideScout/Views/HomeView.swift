import SwiftUI

struct HomeView: View {
    @State private var showingPinAlert = false
    @State private var showingAllRoutes = false
    @State private var showingNewRide = false
    @State private var selectedFare: String? = nil
    @State private var showingFareAction = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.rsBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    Spacer().frame(height: 80)
                    
                    // Search Section
                    Button(action: { showingNewRide = true }) {
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass").foregroundColor(.rsPrimary)
                            Text("Where to?")
                                .font(.system(size: 17))
                                .foregroundColor(.rsOnSurfaceVariant.opacity(0.5))
                            Spacer()
                            Divider().background(Color.white.opacity(0.1)).frame(height: 24)
                            Button(action: { showingPinAlert = true }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "location.north.fill").font(.system(size: 12))
                                    Text("Pin").font(.system(size: 13, weight: .semibold))
                                }
                                .foregroundColor(.rsPrimary)
                            }
                        }
                        .padding()
                        .glassCard()
                        .padding(.horizontal, 24)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Smart Commute Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Smart Commute")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.rsOnSurface)
                            Spacer()
                            Button("View All") { showingAllRoutes = true }
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.rsPrimary)
                        }
                        .padding(.horizontal, 24)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                Spacer().frame(width: 12)
                                
                                Button(action: { handleFareSelection("Home to Office") }) {
                                    SmartCommuteCard(icon: "house.fill", iconColor: .rsPrimary, badge: "Cheapest", badgeColor: .rsTertiary, title: "Home to Office", price: "₹142", providerIcon: "car.fill", providerText: "UBERGO • 4 MIN")
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Button(action: { handleFareSelection("Home to Gym") }) {
                                    SmartCommuteCard(icon: "figure.walk", iconColor: .rsSecondary, badge: nil, badgeColor: .clear, title: "Home to Gym", price: "₹89", providerIcon: "bicycle", providerText: "RAPIDO • 2 MIN", borderColor: .rsSecondary.opacity(0.3))
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Spacer().frame(width: 12)
                            }
                        }
                    }
                    
                    // Unified Fare List
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Unified Fare List")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.rsOnSurface)
                            Spacer()
                            Button(action: { showingAllRoutes = true }) {
                                Image(systemName: "line.3.horizontal.decrease")
                                    .foregroundColor(.rsOnSurfaceVariant)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        VStack(spacing: 12) {
                            FareButton(title: "UberGo", subtitle: "4 min • Uber", price: "₹164", eta: "EST. 10:24", icon: "car.fill", iconBg: .white.opacity(0.05), iconColor: .rsOnSurface, surgeBadge: "Surge 1.2x") { handleFareSelection("UberGo") }
                            
                            FareButton(title: "BluSmart EV", subtitle: "8 min • Eco-Friendly", price: "₹148", eta: "SCHEDULED", icon: "bolt.car.fill", iconBg: .rsPrimary.opacity(0.2), iconColor: .rsPrimary, borderColor: .rsPrimary.opacity(0.2)) { handleFareSelection("BluSmart EV") }
                            
                            FareButton(title: "Bike Lite", subtitle: "1 min • Rapido", price: "₹62", eta: "QUICKEST", icon: "bicycle", iconBg: Color.yellow.opacity(0.1), iconColor: .yellow, borderColor: Color.yellow.opacity(0.3), priceColor: .rsTertiary) { handleFareSelection("Bike Lite") }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer().frame(height: 100)
                }
            }
            
            TopAppBar(title: "RideScout")
            
            // FAB
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { showingNewRide = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color.rsPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(radius: 10)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 100)
                }
            }
        }
        .alert(isPresented: $showingPinAlert) {
            Alert(title: Text("Location Pinned"), message: Text("Current location saved to quick access."), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showingAllRoutes) {
            NavigationView {
                Text("All Routes & Filters Configuration").navigationTitle("Filters")
                    .navigationBarItems(trailing: Button("Done") { showingAllRoutes = false })
            }
        }
        .sheet(isPresented: $showingNewRide) {
            NavigationView {
                Text("Ride Search Builder View").navigationTitle("New Search")
                    .navigationBarItems(trailing: Button("Cancel") { showingNewRide = false })
            }
        }
        .actionSheet(isPresented: $showingFareAction) {
            ActionSheet(
                title: Text("Book \(selectedFare ?? "Ride")?"),
                message: Text("You will be seamlessly redirected to the target app via universal links."),
                buttons: [
                    .default(Text("Confirm Booking")),
                    .cancel()
                ]
            )
        }
    }
    
    private func handleFareSelection(_ title: String) {
        selectedFare = title
        showingFareAction = true
    }
}

struct FareButton: View {
    var title, subtitle, price, eta, icon: String
    var iconBg, iconColor: Color
    var borderColor: Color = .clear
    var priceColor: Color = .rsOnSurface
    var surgeBadge: String? = nil
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            FareListItem(title: title, subtitle: subtitle, price: price, eta: eta, icon: icon, iconBg: iconBg, iconColor: iconColor, borderColor: borderColor, priceColor: priceColor, surgeBadge: surgeBadge)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SmartCommuteCard: View {
    var icon: String
    var iconColor: Color
    var badge: String?
    var badgeColor: Color
    var title: String
    var price: String
    var providerIcon: String
    var providerText: String
    var borderColor: Color = .clear
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 40, height: 40)
                    .background(iconColor.opacity(0.1))
                    .cornerRadius(10)
                
                Spacer()
                
                if let badge = badge {
                    Text(badge.uppercased())
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(badgeColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(badgeColor.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.rsOnSurfaceVariant)
                Text(price)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.rsOnSurface)
            }
            
            HStack(spacing: 4) {
                Image(systemName: providerIcon)
                    .font(.system(size: 12))
                Text(providerText)
                    .font(.system(size: 11, weight: .bold))
            }
            .foregroundColor(.rsOnSurfaceVariant.opacity(0.6))
        }
        .padding(16)
        .frame(width: 200)
        .background(Color.rsSurface.opacity(0.7))
        .background(Material.ultraThinMaterial)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor == .clear ? Color.white.opacity(0.15) : borderColor, lineWidth: 0.5)
        )
    }
}

struct FareListItem: View {
    var title: String
    var subtitle: String
    var price: String
    var eta: String
    var icon: String
    var iconBg: Color
    var iconColor: Color
    var borderColor: Color = .clear
    var priceColor: Color = .rsOnSurface
    var surgeBadge: String? = nil
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(iconColor)
                .frame(width: 48, height: 48)
                .background(iconBg)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 0.5))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.rsOnSurface)
                    
                    if let surge = surgeBadge {
                        Text(surge.uppercased())
                            .font(.system(size: 9, weight: .bold))
                            .tracking(0.5)
                            .foregroundColor(Color(hex: "5B1B00"))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.rsSecondary)
                            .cornerRadius(4)
                    }
                }
                Text(subtitle)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.rsOnSurfaceVariant)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(price)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(priceColor)
                Text(eta)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.rsOnSurfaceVariant)
            }
        }
        .padding()
        .glassCard(glowColor: borderColor != .clear ? borderColor : nil)
    }
}

#Preview { HomeView() }
