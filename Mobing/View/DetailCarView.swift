import SwiftUI

import SwiftUI

struct DetailCarView: View {
    @StateObject private var viewModel = CarDetailViewModel()
    let carId: Int
    @State private var isPlacingOrder = false
    var body: some View {
        Group {
            if let car = viewModel.car {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        AsyncImage(url: URL(string: car.imageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 250)
                                .clipped()
                        } placeholder: {
                            Color.gray.frame(height: 250)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text(car.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text(car.brand)
                                .font(.title2)
                                .foregroundColor(.cyan)
                            HStack {
                                Text("$\(car.price, specifier: "%.2f")")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.cyan)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                                    .background(Color.black)
                                    .cornerRadius(6)
                                if car.insentive > 0 {
                                    Text("Save $\(car.insentive, specifier: "%.2f")")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 8)
                                        .background(Color.cyan)
                                        .cornerRadius(6)
                                }
                            }
                        }.padding(.horizontal)
                        
                        Divider().background(Color.cyan.opacity(0.5))
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Specifications")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            HStack {
                                Image(systemName: "calendar")
                                    .frame(width: 30)
                                    .foregroundColor(.cyan)
                                Text("Year")
                                Spacer()
                                Text("\(car.yearBuilt)")
                            }.foregroundColor(.white)
                            HStack {
                                Image(systemName: "speedometer")
                                    .frame(width: 30)
                                    .foregroundColor(.cyan)
                                Text("Distance")
                                Spacer()
                                Text("\(car.totalDistance, specifier: "%.0f")")
                            }.foregroundColor(.white)
                            HStack {
                                Image(systemName: "person")
                                    .frame(width: 30)
                                    .foregroundColor(.cyan)
                                Text("Seller ID")
                                Spacer()
                                Text("\(car.sellerID)")
                            }.foregroundColor(.white)
                        }.padding(.horizontal)
                        
                        Divider().background(Color.cyan.opacity(0.5))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Text(car.description)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                        }.padding(.horizontal)
                        
                        VStack(spacing: 16) {
                            NavigationLink(destination: PlaceOrderView(car: car), isActive: $isPlacingOrder) {
                                EmptyView()
                            }
                            
                            Button(action: {
                                isPlacingOrder = true
                            }) {
                                HStack {
                                    Image(systemName: "phone.fill")
                                    Text("Beli Sekarang")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.cyan)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .fontWeight(.bold)
                            }
                            .padding(.horizontal)
                            .padding(.top)
                        }
                    }.padding(.bottom)
                }
            } else {
                ProgressView("Loading car details...")
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            viewModel.fetchCarById(carId: carId)
        }
        .background(Color.black)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        DetailCarView(carId: 1)
    }
}
