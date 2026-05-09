import SwiftUI
import Combine

@MainActor
class FareSearchViewModel: ObservableObject {
    @Published var results: [FareResult] = []
    @Published var isLoading = false
    @Published var origin: String = "Current Location"
    @Published var destination: String = "Kempegowda International Airport"
    
    func searchFares() async {
        isLoading = true
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_800_000_000) // 1.8s p50 latency as per PRD
        
        // Mock data
        self.results = [
            FareResult(platform: .nammaYatri, serviceType: "Auto", amount: 180, currency: "INR", surgeMultiplier: 1.0, etaMinutes: 3, vehicleType: "auto", driverRating: 4.8, co2Grams: 50, isCheapest: true),
            FareResult(platform: .rapido, serviceType: "Bike", amount: 195, currency: "INR", surgeMultiplier: 1.2, etaMinutes: 2, vehicleType: "bike", driverRating: 4.6, co2Grams: 30, isCheapest: false),
            FareResult(platform: .uber, serviceType: "UberGo", amount: 450, currency: "INR", surgeMultiplier: 1.4, etaMinutes: 5, vehicleType: "car", driverRating: 4.7, co2Grams: 150, isCheapest: false),
            FareResult(platform: .ola, serviceType: "Mini", amount: 470, currency: "INR", surgeMultiplier: 1.5, etaMinutes: 6, vehicleType: "car", driverRating: 4.5, co2Grams: 150, isCheapest: false),
            FareResult(platform: .metro, serviceType: "Blue Line", amount: 60, currency: "INR", surgeMultiplier: 1.0, etaMinutes: 45, vehicleType: "train", driverRating: nil, co2Grams: 10, isCheapest: false)
        ].sorted { $0.amount < $1.amount }
        
        isLoading = false
    }
}
