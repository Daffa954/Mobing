import SwiftUI

struct ListCarView: View {
    @StateObject private var viewModel: CarListViewModel
    @StateObject private var networkManager: NetworkManager
    @EnvironmentObject var authVM: AuthViewModel

    init() {
        let sharedNetworkManager = NetworkManager()
        _networkManager = StateObject(wrappedValue: sharedNetworkManager)
        _viewModel = StateObject(wrappedValue: CarListViewModel(networkManager: sharedNetworkManager))
    }

    var body: some View {
        NavigationStack {
            VStack {

                if viewModel.isLoading && viewModel.cars.isEmpty {
                    ProgressView("Memuat Mobil...")
                        .foregroundStyle(.white)
                } else if viewModel.isShowingNoInternetMessage {
                    VStack {
                        Image(systemName: "wifi.slash")
                            .font(.largeTitle)
                            .foregroundStyle(.red)
                            .padding(.bottom, 8)
                        Text("Tidak ada koneksi internet.")
                            .foregroundStyle(.white)
                            .font(.headline)
                        Text("Silakan periksa pengaturan jaringan Anda.")
                            .foregroundStyle(.gray)
                            .font(.subheadline)
                        Button("Coba Lagi") {
                            Task { await viewModel.fetchCars() }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Capsule().fill(Color.blue))
                        .foregroundStyle(.white)
                        .padding(.top, 20)
                    }
                } else if viewModel.cars.isEmpty {
                    VStack {
                        Image(systemName: "car.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.gray)
                            .padding(.bottom, 8)
                        Text("Tidak ada mobil ditemukan.")
                            .foregroundStyle(.white)
                            .font(.headline)
                        Text("Coba segarkan atau periksa lagi nanti.")
                            .foregroundStyle(.gray)
                            .font(.subheadline)
                        Button("Segarkan") {
                            Task { await viewModel.fetchCars() }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Capsule().fill(Color.green))
                        .foregroundStyle(.white)
                        .padding(.top, 20)
                    }
                }

                if !viewModel.cars.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.cars) { car in
                                NavigationLink {
                                    DetailCarView(carId: car.id)
                                } label: {
                                    CarCardView(car: car)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                    .refreshable {
                        print("🔄 Pull-to-refresh dipicu!")
                        await viewModel.fetchCars()
                    }
                }
            }
            .onAppear {
                print("✅ ListCarView muncul - memanggil fetchCars")
                Task { await viewModel.fetchCars() }
            }
            .navigationTitle("Mobil Tersedia")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

#Preview {
    NavigationView {
        ListCarView()
    }
}
