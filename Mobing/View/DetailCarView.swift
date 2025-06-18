import SwiftUI
import SceneKit

struct DetailCarView: View {
    @StateObject private var viewModel = CarDetailViewModel()
    let carId: Int
    @State private var isPlacingOrder = false
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        //MARK: 3D

        Group {
            if let car = viewModel.car {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Car3DView(sceneName: "cybertruck")
                            .frame(height: 300)
                        
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
struct Car3DView: UIViewRepresentable {
    let sceneName: String
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        
        // Force high resolution rendering
        sceneView.layer.contentsScale = UIScreen.main.scale
        sceneView.contentScaleFactor = UIScreen.main.scale
        
        if let scene = SCNScene(named: "\(sceneName).scn") {
            sceneView.scene = scene
            
            // Maximum antialiasing
            sceneView.antialiasingMode = .multisampling2X
            
            // Enable temporal antialiasing if available
            if #available(iOS 13.0, *) {
                sceneView.isTemporalAntialiasingEnabled = true
            }
            
            // Disable automatic lighting and set up custom lighting for better quality
            sceneView.autoenablesDefaultLighting = false
            
            // Add high-quality lighting
            setupLighting(for: scene)
            
            // Camera controls
            sceneView.allowsCameraControl = true
            
            // Force continuous rendering for smooth interaction
            sceneView.rendersContinuously = true
            
            // Set background
            sceneView.backgroundColor = UIColor.clear
            
            // Additional quality settings
            sceneView.showsStatistics = false // Remove if you want to see stats
            
            
            // Set up better material properties if needed
            optimizeSceneMaterials(scene)
        }
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // Ensure scale factor is maintained
        uiView.contentScaleFactor = UIScreen.main.scale
        uiView.layer.contentsScale = UIScreen.main.scale
    }
    
    private func setupLighting(for scene: SCNScene) {
        // Remove existing lights
        scene.rootNode.childNodes.forEach { node in
            if node.light != nil {
                node.removeFromParentNode()
            }
        }
        
        // Add ambient light
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.color = UIColor.white
        ambientLight.intensity = 800 // Increased for better visibility
        let ambientNode = SCNNode()
        ambientNode.light = ambientLight
        scene.rootNode.addChildNode(ambientNode)
        
        // Add main directional light (front)
        let frontLight = SCNLight()
        frontLight.type = .directional
        frontLight.color = UIColor.white
        frontLight.intensity = 1000
        frontLight.castsShadow = true
        frontLight.shadowRadius = 3
        frontLight.shadowColor = UIColor.black.withAlphaComponent(0.3)
        let frontNode = SCNNode()
        frontNode.light = frontLight
        frontNode.position = SCNVector3(0, 5, 30) // Front lighting
        frontNode.look(at: SCNVector3(0, 0, 0))
        scene.rootNode.addChildNode(frontNode)
        
        // Add side lighting (left)
        let leftLight = SCNLight()
        leftLight.type = .omni
        leftLight.color = UIColor.white
        leftLight.intensity = 600
        let leftNode = SCNNode()
        leftNode.light = leftLight
        leftNode.position = SCNVector3(0, 5, 30)
        scene.rootNode.addChildNode(leftNode)
        
        // Add side lighting (right)
        let rightLight = SCNLight()
        rightLight.type = .omni
        rightLight.color = UIColor.white
        rightLight.intensity = 600
        let rightNode = SCNNode()
        rightNode.light = rightLight
        rightNode.position = SCNVector3(8, 3, 0)
        scene.rootNode.addChildNode(rightNode)
        
        // Add back lighting
        let backLight = SCNLight()
        backLight.type = .omni
        backLight.color = UIColor.white
        backLight.intensity = 8000
        let backNode = SCNNode()
        backNode.light = backLight
        backNode.position = SCNVector3(0, 3, -8)
        scene.rootNode.addChildNode(backNode)
    }
    
    private func optimizeSceneMaterials(_ scene: SCNScene) {
        scene.rootNode.enumerateChildNodes { node, _ in
            if let geometry = node.geometry {
                for material in geometry.materials {
                    // Enable better texture filtering
                    material.diffuse.wrapS = .repeat
                    material.diffuse.wrapT = .repeat
                    material.diffuse.minificationFilter = .linear
                    material.diffuse.magnificationFilter = .linear
                    material.diffuse.mipFilter = .linear
                    
                    // Fix transparency issues for windshield/glass parts
                    if material.transparency < 1.0 || material.diffuse.contents is UIColor {
                        // This might be glass/windshield material
                        material.transparencyMode = .aOne
                        material.blendMode = .alpha
                        material.isDoubleSided = true // Important for glass
                        material.cullMode = .front
                        
                        // Make glass more visible
                        if material.transparency < 0.3 {
                            material.transparency = 0.3 // Make it more visible
                        }
                        
                        // Add slight tint to make glass visible
                        if material.diffuse.contents == nil {
                            material.diffuse.contents = UIColor.cyan.withAlphaComponent(0.1)
                        }
                    } else {
                        // Regular car body materials
                        material.lightingModel = .physicallyBased
                        material.isDoubleSided = false
                        material.cullMode = .back
                    }
                    
                    // Ensure all materials are properly lit
                    material.locksAmbientWithDiffuse = true
                    
                    // If you have normal maps, enable them properly
                    if material.normal.contents != nil {
                        material.normal.intensity = 1.0
                    }
                    
                    // Fix any completely transparent materials
                    if material.transparency == 0.0 {
                        material.transparency = 1.0
                    }
                }
            }
        }
}
}

#Preview {
    NavigationStack {
        DetailCarView(carId: 1)
    }
}
