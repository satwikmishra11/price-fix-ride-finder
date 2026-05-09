import SwiftUI

struct PlannerView: View {
    @State private var showingCalendarSyncAlert = false
    @State private var showingRouteDetails = false
    @State private var showingScheduleRideAction = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.rsBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Spacer().frame(height: 80)
                    
                    // Calendar Sync Header
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "calendar.badge.clock")
                                .foregroundColor(.rsPrimary)
                                .font(.system(size: 20))
                            Text("Apple Calendar Sync")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.rsOnSurfaceVariant)
                            Spacer()
                            Toggle("", isOn: .constant(true))
                                .labelsHidden()
                                .tint(.rsPrimaryContainer)
                        }
                        
                        Text("RideScout is monitoring traffic for 3 upcoming events today. You'll be alerted 45 mins before you need to leave.")
                            .font(.system(size: 13))
                            .foregroundColor(.rsOnSurfaceVariant)
                            .lineSpacing(4)
                    }
                    .padding()
                    .glassCard()
                    .padding(.horizontal, 24)
                    
                    // Timeline Agenda
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Today's Itinerary")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.rsOnSurface)
                            .padding(.horizontal, 24)
                        
                        // Event 1: High Priority (Airport)
                        Button(action: { showingScheduleRideAction = true }) {
                            TimelineEventCard(
                                eventTime: "4:00 PM",
                                eventTitle: "Flight to DEL (Indigo)",
                                location: "Kempegowda Airport, T1",
                                leaveTime: "Leave by 1:15 PM",
                                recommendationTitle: "Cheapest: Vayu Vajra Bus",
                                recommendationPrice: "₹250",
                                isCritical: true
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 24)
                        
                        // Event 2: Meeting (Multi-Modal Suggestion)
                        Button(action: { showingRouteDetails = true }) {
                            TimelineEventCard(
                                eventTime: "10:30 AM",
                                eventTitle: "Client Pitch",
                                location: "WeWork Galaxy",
                                leaveTime: "Leave by 9:45 AM",
                                recommendationTitle: "Fastest: Metro + Auto",
                                recommendationPrice: "₹85",
                                isCritical: false,
                                surgeWarning: "Avoid 10:00 AM (1.5x Surge Expected)"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 24)
                    }
                    
                    // Saved Commute Routines
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Commute Routines")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.rsOnSurface)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 12) {
                            RoutineCard(
                                icon: "briefcase.fill",
                                title: "Work Commute",
                                subtitle: "Auto-books every weekday at 8:30 AM",
                                status: "Active",
                                statusColor: .rsSuccess
                            )
                            
                            RoutineCard(
                                icon: "dumbbell.fill",
                                title: "Gym Routine",
                                subtitle: "Alerts when Rapido drops below ₹50",
                                status: "Monitoring",
                                statusColor: .rsPrimary
                            )
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer().frame(height: 100)
                }
            }
            
            TopAppBar(title: "Planner")
        }
        .actionSheet(isPresented: $showingScheduleRideAction) {
            ActionSheet(
                title: Text("Schedule Ride to Airport"),
                message: Text("Would you like to lock in this fare and schedule a pickup for 1:15 PM?"),
                buttons: [
                    .default(Text("Schedule Uber Reserve")),
                    .default(Text("Remind me at 1:00 PM")),
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $showingRouteDetails) {
            NavigationView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Multi-Modal Route Breakdown")
                        .font(.title2)
                        .bold()
                        .padding(.top)
                    
                    HStack(alignment: .top) {
                        VStack(spacing: 4) {
                            Image(systemName: "tram.fill").foregroundColor(.blue)
                            Rectangle().fill(Color.blue).frame(width: 2, height: 40)
                            Image(systemName: "figure.walk").foregroundColor(.gray)
                        }
                        VStack(alignment: .leading, spacing: 30) {
                            VStack(alignment: .leading) {
                                Text("Namma Metro (Purple Line)").bold()
                                Text("Indiranagar to MG Road (₹25)").font(.caption).foregroundColor(.secondary)
                            }
                            VStack(alignment: .leading) {
                                Text("Walk to WeWork").bold()
                                Text("3 mins (0.2 km)").font(.caption).foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Route Details")
                .navigationBarItems(trailing: Button("Done") { showingRouteDetails = false })
            }
        }
    }
}

struct TimelineEventCard: View {
    var eventTime: String
    var eventTitle: String
    var location: String
    var leaveTime: String
    var recommendationTitle: String
    var recommendationPrice: String
    var isCritical: Bool
    var surgeWarning: String? = nil
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack {
                Text(eventTime.split(separator: " ")[0])
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.rsOnSurface)
                Text(eventTime.split(separator: " ")[1])
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.rsOnSurfaceVariant)
            }
            .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(eventTitle)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.rsOnSurface)
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                        Text(location)
                    }
                    .font(.system(size: 13))
                    .foregroundColor(.rsOnSurfaceVariant)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(isCritical ? .rsSecondary : .rsPrimary)
                        Text(leaveTime)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(isCritical ? .rsSecondary : .rsPrimary)
                    }
                    
                    if let surge = surgeWarning {
                        Text(surge)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.rsSecondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.rsSecondary.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    HStack {
                        Text(recommendationTitle)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.rsOnSurface)
                        Spacer()
                        Text(recommendationPrice)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.rsTertiary)
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(8)
                }
            }
            .padding(16)
            .glassCard(glowColor: isCritical ? .rsSecondary : .rsPrimaryContainer)
            .overlay(
                Rectangle()
                    .fill(isCritical ? Color.rsSecondary : Color.rsPrimary)
                    .frame(width: 4)
                    .padding(.vertical, 16),
                alignment: .leading
            )
        }
    }
}

struct RoutineCard: View {
    var icon: String
    var title: String
    var subtitle: String
    var status: String
    var statusColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.rsPrimary)
                .frame(width: 48, height: 48)
                .background(Color.rsPrimary.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.rsOnSurface)
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(.rsOnSurfaceVariant)
            }
            
            Spacer()
            
            Text(status.uppercased())
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(statusColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(statusColor.opacity(0.1))
                .cornerRadius(4)
        }
        .padding()
        .glassCard()
    }
}

#Preview { PlannerView() }
