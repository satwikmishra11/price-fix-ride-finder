import Foundation
import SwiftUI

enum Platform: String, Codable, CaseIterable {
    case uber = "Uber"
    case ola = "Ola"
    case rapido = "Rapido"
    case indrive = "InDrive"
    case nammaYatri = "Namma Yatri"
    case bluSmart = "BluSmart"
    case metro = "Metro"
    case bus = "Bus"
    
    var color: Color {
        switch self {
        case .uber: return .black
        case .ola: return Color(red: 0.5, green: 0.8, blue: 0.2) // Greenish
        case .rapido: return .yellow
        case .indrive: return .green
        case .nammaYatri: return .orange
        case .bluSmart: return .blue
        case .metro: return .purple
        case .bus: return .red
        }
    }
}
