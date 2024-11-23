// 예시 뷰들
struct TurtleNeckView: View {
    var body: some View {
        Color.blue.opacity(0.1)
            .overlay(Text("거북목 감지"))
    }
}