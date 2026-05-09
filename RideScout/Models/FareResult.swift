import Foundation

struct FareResult: Identifiable, Codable {
    var id: String { "\(platform.rawValue)-\(serviceType)" }
    let platform: Platform
    let serviceType: String
    let amount: Double
    let currency: String
    let surgeMultiplier: Double
    let etaMinutes: Int
    let vehicleType: String
    let driverRating: Double?
    let co2Grams: Int?
    let isCheapest: Bool
}
