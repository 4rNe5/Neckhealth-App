import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .turtleNeck
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                TurtleNeckView()
                    .tag(Tab.turtleNeck)
                
                StressView()
                    .tag(Tab.stress)
                
                SettingsView()
                    .tag(Tab.settings)
            }
            
            CustomTabBar(selectedTab: $selectedTab)
                .padding(.bottom, 20)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// 예시 뷰들
struct TurtleNeckView: View {
    var body: some View {
        Color.blue.opacity(0.1)
            .overlay(Text("거북목 감지"))
    }
}

struct StressView: View {
    var body: some View {
        Color.green.opacity(0.1)
            .overlay(Text("스트레스 측정"))
    }
}

struct SettingsView: View {
    var body: some View {
        Color.orange.opacity(0.1)
            .overlay(Text("설정"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
