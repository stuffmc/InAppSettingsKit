import SwiftUI
import InAppSettingsKit

struct IASKView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> IASKAppSettingsViewController {
        .init()
    }
    
    func updateUIViewController(_ uiViewController: IASKAppSettingsViewController, context: Context) {
    }
}

@main
struct IASKSwiftUISample: App {
    var body: some Scene {
        WindowGroup {
            Tabs()
        }
    }
}

struct Tabs: View {
    @State private var showingSheet = false
    @State private var showingModal = false

    var body: some View {
        TabView {
            Tab("Feature", systemImage: "star") {
                NavigationStack {
                    VStack(spacing: 30) {
                        NavigationLink("Show Settings (Push)") {
                            IASKView()
                        }
                        Button("Show Settings (Modal)") {
                            showingModal.toggle()
                        }
                        .sheet(isPresented: $showingModal) {
                            NavigationStack {
                                IASKView()
                            }
                        }
                    }
                    .bold()
                    .navigationTitle(Text("SwiftUI IASK Sample"))
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        Button("Settings") {
                            showingSheet.toggle()
                        }
                        .sheet(isPresented: $showingSheet) {
                            IASKView()
                        }
                    }
                }
            }
            Tab("Settings", systemImage: "gearshape.2.fill") {
                IASKView()
            }
        }
    }
}

#Preview {
    Tabs()
}
