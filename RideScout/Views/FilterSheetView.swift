import SwiftUI

struct FilterSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var maxPrice: Double = 500
    @State private var selectedSort = "Smart (Recommended)"
    @State private var ecoFriendlyOnly = false
    @State private var petFriendly = false
    @State private var wheelchairAccess = false
    @State private var selectedPlatforms: Set<String> = ["Uber", "Ola", "Rapido", "BluSmart", "Namma Yatri"]
    
    let sortOptions = ["Smart (Recommended)", "Price (Low to High)", "ETA (Fastest)", "Carbon Footprint (Lowest)"]
    let platforms = ["Uber", "Ola", "Rapido", "BluSmart", "Namma Yatri", "Metro"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.rsBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Sort By
                        VStack(alignment: .leading, spacing: 12) {
                            Text("SORT BY")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.rsOnSurfaceVariant)
                            
                            VStack(spacing: 0) {
                                ForEach(sortOptions, id: \.self) { option in
                                    Button(action: { selectedSort = option }) {
                                        HStack {
                                            Text(option)
                                                .font(.system(size: 17))
                                                .foregroundColor(.rsOnSurface)
                                            Spacer()
                                            if selectedSort == option {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.rsPrimary)
                                            }
                                        }
                                        .padding()
                                        .background(Color.rsSurface.opacity(0.5))
                                    }
                                    Divider().background(Color.white.opacity(0.05))
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        // Price Range
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("MAX PRICE")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.rsOnSurfaceVariant)
                                Spacer()
                                Text("₹\(Int(maxPrice))")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.rsPrimary)
                            }
                            
                            Slider(value: $maxPrice, in: 50...2000, step: 50)
                                .accentColor(.rsPrimary)
                        }
                        
                        // Platforms
                        VStack(alignment: .leading, spacing: 12) {
                            Text("PLATFORMS")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.rsOnSurfaceVariant)
                            
                            let columns = [GridItem(.flexible()), GridItem(.flexible())]
                            LazyVGrid(columns: columns, spacing: 12) {
                                ForEach(platforms, id: \.self) { platform in
                                    Button(action: {
                                        if selectedPlatforms.contains(platform) {
                                            selectedPlatforms.remove(platform)
                                        } else {
                                            selectedPlatforms.insert(platform)
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: selectedPlatforms.contains(platform) ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(selectedPlatforms.contains(platform) ? .rsPrimary : .rsOnSurfaceVariant)
                                            Text(platform)
                                                .font(.system(size: 15))
                                                .foregroundColor(.rsOnSurface)
                                            Spacer()
                                        }
                                        .padding(12)
                                        .background(Color.rsSurface.opacity(0.7))
                                        .cornerRadius(8)
                                    }
                                }
                            }
                        }
                        
                        // Ride Preferences
                        VStack(alignment: .leading, spacing: 12) {
                            Text("PREFERENCES")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.rsOnSurfaceVariant)
                            
                            VStack(spacing: 0) {
                                ToggleItem(icon: "leaf.fill", iconColor: .rsSuccess, title: "Eco-Friendly Only", subtitle: "EVs and Public Transit", isOn: $ecoFriendlyOnly)
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 56)
                                ToggleItem(icon: "pawprint.fill", iconColor: .orange, title: "Pet Friendly", subtitle: "Drivers who allow pets", isOn: $petFriendly)
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 56)
                                ToggleItem(icon: "figure.roll", iconColor: .blue, title: "Wheelchair Accessible", subtitle: "Vehicles with ramps", isOn: $wheelchairAccess)
                            }
                            .background(Color.rsSurface.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                    }
                    .padding(24)
                }
                
                // Bottom Sticky Apply Button
                VStack {
                    Spacer()
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("Show Results")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.rsPrimary)
                            .cornerRadius(16)
                            .shadow(radius: 10)
                    }
                    .padding(24)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.rsBackground.opacity(0), Color.rsBackground]), startPoint: .top, endPoint: .bottom)
                    )
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Reset") {
                maxPrice = 500
                selectedSort = "Smart (Recommended)"
                selectedPlatforms = ["Uber", "Ola", "Rapido", "BluSmart", "Namma Yatri"]
                ecoFriendlyOnly = false
                petFriendly = false
                wheelchairAccess = false
            })
        }
    }
}

struct ToggleItem: View {
    var icon: String
    var iconColor: Color
    var title: String
    var subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.rsOnSurface)
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.rsOnSurfaceVariant)
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.rsPrimaryContainer)
        }
        .padding(16)
    }
}

#Preview {
    FilterSheetView()
}
