import SwiftUI

extension Color {
    static let rsBackground = Color(hex: "131315")
    static let rsSurface = Color(hex: "1C1B1D")
    static let rsSurfaceHighlight = Color(hex: "2A2A2C")
    static let rsPrimary = Color(hex: "AEC6FF")
    static let rsPrimaryContainer = Color(hex: "006FEE")
    static let rsSecondary = Color(hex: "FFB59A")
    static let rsTertiary = Color(hex: "41E279")
    static let rsSuccess = Color(hex: "17C964")
    static let rsOnSurface = Color(hex: "E5E1E4")
    static let rsOnSurfaceVariant = Color(hex: "C1C6D7")
    static let rsOutline = Color(hex: "8B90A0")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct GlassPanel: ViewModifier {
    var glowColor: Color? = nil
    
    func body(content: Content) -> some View {
        content
            .background(Color.rsSurface.opacity(0.7))
            .background(Material.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
            )
            .cornerRadius(16)
            .shadow(color: glowColor?.opacity(0.2) ?? Color.clear, radius: 15, x: 0, y: 0)
    }
}

extension View {
    func glassCard(glowColor: Color? = nil) -> some View {
        self.modifier(GlassPanel(glowColor: glowColor))
    }
}

struct TopAppBar: View {
    var title: String
    @State private var showingProfile = false
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Button(action: { showingProfile = true }) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.rsPrimaryContainer)
                }
                
                Text(title)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.rsPrimary)
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "location.fill")
                    .foregroundColor(.rsPrimary)
                    .padding(8)
                    .background(Color.white.opacity(0.05))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 16)
        .background(Color.rsBackground.opacity(0.8))
        .background(Material.ultraThinMaterial)
        .overlay(Rectangle().frame(width: nil, height: 0.5, alignment: .bottom).foregroundColor(Color.white.opacity(0.1)), alignment: .bottom)
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
    }
}
