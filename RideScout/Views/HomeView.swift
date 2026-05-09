import SwiftUI
import MapKit

struct HomeView: View {
    @StateObject private var viewModel = FareSearchViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 12.9716, longitude: 77.5946), // Bengaluru
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // Background Map
                Map(coordinateRegion: $region, showsUserLocation: true)
                    .ignoresSafeArea()
                
                // Bottom Sheet for Fares
                VStack(spacing: 0) {
                    // Pull Indicator
                    Capsule()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 40, height: 5)
                        .padding(.top, 8)
                        .padding(.bottom, 12)
                    
                    // Header / Search Bar
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "location.fill").foregroundColor(.blue)
                            Text(viewModel.origin).font(.subheadline)
                            Spacer()
                        }
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(10)
                        
                        HStack {
                            Image(systemName: "mappin.and.ellipse").foregroundColor(.red)
                            Text(viewModel.destination).font(.subheadline)
                            Spacer()
                        }
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(10)
                        
                        // Multi-modal option toggle (mock)
                        HStack {
                            Image(systemName: "tram.fill").foregroundColor(.purple)
                            Text("Include Metro & Walk routes")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Toggle("", isOn: .constant(true)).labelsHidden()
                        }
                        .padding(.horizontal, 4)
                        .padding(.top, 4)
                    }
                    .padding(.horizontal)
                    
                    // Results List
                    ScrollView {
                        VStack(spacing: 12) {
                            if viewModel.isLoading {
                                ProgressView("Fetching real-time fares...")
                                    .padding(.top, 40)
                            } else {
                                ForEach(viewModel.results) { result in
                                    Button(action: {
                                        // Deep link booking handoff mock
                                        print("Deep linking to \(result.platform.rawValue)")
                                    }) {
                                        FareResultCard(result: result)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(maxHeight: 400) // Bottom sheet height
                }
                .background(Color(UIColor.systemBackground))
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .shadow(radius: 10)
            }
            .navigationTitle("RideScout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task { await viewModel.searchFares() }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .task {
            await viewModel.searchFares()
        }
    }
}

// Helper to round specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    HomeView()
}
