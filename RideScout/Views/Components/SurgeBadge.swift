import SwiftUI

struct SurgeBadge: View {
    let multiplier: Double
    
    var body: some View {
        if multiplier > 1.2 {
            HStack(spacing: 4) {
                Image(systemName: "arrow.up.right.circle.fill")
                    .font(.system(size: 10))
                Text(String(format: "%.1fx", multiplier))
                    .font(.system(size: 12, weight: .bold))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.red.opacity(0.15))
            .foregroundColor(.red)
            .cornerRadius(8)
        } else if multiplier > 1.0 {
            HStack(spacing: 4) {
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 10))
                Text(String(format: "%.1fx", multiplier))
                    .font(.system(size: 12, weight: .bold))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.orange.opacity(0.15))
            .foregroundColor(.orange)
            .cornerRadius(8)
        }
    }
}

#Preview {
    SurgeBadge(multiplier: 1.5)
}
