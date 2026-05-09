import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var mlLearningEnabled = true
    @State private var pushEnabled = true
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.rsBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Profile Header
                        VStack(spacing: 16) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.rsPrimaryContainer)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                            
                            VStack(spacing: 4) {
                                Text("Arjun R.")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.rsOnSurface)
                                Text("arjun@example.com")
                                    .font(.system(size: 15))
                                    .foregroundColor(.rsOnSurfaceVariant)
                            }
                            
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 12))
                                Text("SCOUT PRO ACTIVE")
                                    .font(.system(size: 11, weight: .bold))
                                    .tracking(1)
                            }
                            .foregroundColor(.yellow)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.yellow.opacity(0.1))
                            .overlay(Capsule().stroke(Color.yellow.opacity(0.3), lineWidth: 1))
                            .clipShape(Capsule())
                        }
                        .padding(.top, 24)
                        
                        // Linked Platforms
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Linked Platforms")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.rsOnSurfaceVariant)
                                .padding(.horizontal, 24)
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "car.fill", title: "Uber", value: "Connected", valueColor: .rsSuccess)
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 56)
                                SettingsRow(icon: "car.circle.fill", title: "Ola", value: "Connected", valueColor: .rsSuccess)
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 56)
                                SettingsRow(icon: "bicycle", title: "Rapido", value: "Connect Account", valueColor: .rsPrimary)
                            }
                            .glassCard()
                            .padding(.horizontal, 24)
                        }
                        
                        // Corporate & Payments
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Corporate & Payments")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.rsOnSurfaceVariant)
                                .padding(.horizontal, 24)
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "applelogo", title: "Apple Pay", value: "Default", valueColor: .rsOnSurface)
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 56)
                                SettingsRow(icon: "briefcase.fill", title: "Corporate ERP (SAP)", value: "Not Configured", valueColor: .rsOnSurfaceVariant)
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 56)
                                SettingsRow(icon: "doc.text.fill", title: "GST Invoices", value: "Auto-export to Wallet", valueColor: .rsPrimary)
                            }
                            .glassCard()
                            .padding(.horizontal, 24)
                        }
                        
                        // Intelligence Preferences
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Intelligence & Privacy")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.rsOnSurfaceVariant)
                                .padding(.horizontal, 24)
                            
                            VStack(spacing: 0) {
                                ToggleRow(icon: "brain.head.profile", title: "On-Device ML Learning", subtitle: "Learns commute patterns locally.", isOn: $mlLearningEnabled)
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 56)
                                ToggleRow(icon: "bell.badge.fill", title: "Smart Push Alerts", subtitle: "Surge drops and calendar warnings.", isOn: $pushEnabled)
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 56)
                                SettingsRow(icon: "lock.shield.fill", title: "Data Export", value: "DPDP Compliant", valueColor: .rsPrimary)
                            }
                            .glassCard()
                            .padding(.horizontal, 24)
                        }
                        
                        Button(action: {}) {
                            Text("Sign Out")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .glassCard()
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct SettingsRow: View {
    var icon: String
    var title: String
    var value: String
    var valueColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.rsOnSurfaceVariant)
                .frame(width: 24)
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.rsOnSurface)
            Spacer()
            Text(value)
                .font(.system(size: 15))
                .foregroundColor(valueColor)
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.rsOnSurfaceVariant.opacity(0.5))
        }
        .padding(16)
        .background(Color.rsSurface.opacity(0.7))
    }
}

struct ToggleRow: View {
    var icon: String
    var title: String
    var subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.rsOnSurfaceVariant)
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
        .background(Color.rsSurface.opacity(0.7))
    }
}

#Preview {
    ProfileView()
}
