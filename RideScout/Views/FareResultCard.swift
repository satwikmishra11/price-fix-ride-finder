import SwiftUI

struct FareResultCard: View {
    let result: FareResult
    
    var body: some View {
        HStack(spacing: 16) {
            // Platform Icon
            Circle()
                .fill(result.platform.color)
                .frame(width: 48, height: 48)
                .overlay(
                    Text(String(result.platform.rawValue.prefix(1)))
                        .font(.title3).bold()
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(result.platform.rawValue)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("•")
                        .foregroundColor(.secondary)
                    Text(result.serviceType)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.blue)
                        .font(.caption)
                    Text("\(result.etaMinutes) min away")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if let rating = result.driverRating {
                        Text("•")
                            .foregroundColor(.secondary)
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", rating))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("₹\(Int(result.amount))")
                    .font(.title3)
                    .fontWeight(.heavy)
                
                SurgeBadge(multiplier: result.surgeMultiplier)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }
}
