import SwiftUI

struct RootView: View {
    @State private var selectedTab: Tab = .turtleNeck
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                TurtleNeckView()
                    .tag(Tab.turtleNeck)
                
                SleepMonitoringView()
                    .tag(Tab.stress)
                
                SettingsView()
                    .tag(Tab.settings)
            }
            .animation(nil, value: selectedTab)
            
            CustomTabBar(selectedTab: $selectedTab)
                .padding(.bottom, 20)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
