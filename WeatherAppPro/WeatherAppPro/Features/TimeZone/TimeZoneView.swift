//
//  TimeZoneView.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


struct TimeZoneView: View {
    @StateObject private var viewModel: TimeZoneViewModel
    @EnvironmentObject private var router: Router
    
    init(location: LocationEntity) {
        _viewModel = StateObject(wrappedValue: Container.shared.makeTimeZoneViewModel(location: location))
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.weatherBackground(for: "Cloudy"))
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                if viewModel.viewState.isLoading {
                    loadingView
                } else {
                    timeZoneContent
                }
            }
            .padding()
        }
        .navigationTitle("Time Zone")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchTimeZone()
        }
    }
    
    // MARK: - Subviews
    
    private var timeZoneContent: some View {
        VStack(spacing: 24) {
            locationCard
            timeCard
            timezoneInfoCard
        }
    }
    
    private var locationCard: some View {
        LiquidGlassCard {
            VStack(spacing: 12) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 50))
                    .foregroundStyle(.white)
                
                Text(viewModel.locationName)
                    .font(.title)
                    .foregroundStyle(.white)
                
                Text(viewModel.country)
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding()
        }
    }
    
    private var timeCard: some View {
        LiquidGlassCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "clock.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                    Text("Local Time")
                        .font(AppTheme.Typography.headline)
                        .foregroundStyle(.white)
                    Spacer()
                }
                
                Text(viewModel.localTime)
                    .font(.system(size: 48, weight: .thin, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
            }
            .padding()
        }
    }
    
    private var timezoneInfoCard: some View {
        LiquidGlassCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "globe")
                        .font(.title2)
                        .foregroundStyle(.white)
                    Text("Time Zone")
                        .font(AppTheme.Typography.headline)
                        .foregroundStyle(.white)
                    Spacer()
                }
                
                InfoRow(label: "Time Zone ID", value: viewModel.timeZone)
                
                Divider()
                    .background(.white.opacity(0.2))
                
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundStyle(.white.opacity(0.6))
                    Text("Times shown are based on the location's local time zone.")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
            .padding()
        }
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
                .foregroundStyle(.white)
            Spacer()
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.white.opacity(0.7))
            Spacer()
            Text(value)
                .foregroundStyle(.white)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        TimeZoneView(location: .sampleLima)
            .environmentObject(Router())
    }
}