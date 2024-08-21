import SwiftUI

public struct SwimplyPlayIndicator: View {
    fileprivate struct BarInfo: Identifiable {
        let id: Int
        let maxValue: CGFloat
        let animationDuration: Double
    }

    public enum AudioState {
        case stop
        case play
        case pause
    }

    public enum Style: Sendable {
        case legacy
        case modern
    }

    @Binding private var state: AudioState
    @State private var barInfos: [BarInfo] = []
    private let color: Color
    private let count: Int
    private let style: Style

    public init(
        state: Binding<AudioState>,
        count: Int = 4,
        color: Color = .black,
        style: Style = .modern
    ) {
        _state = state
        self.count = count
        self.color = color
        self.style = style
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 2) {
            ForEach(barInfos) { barInfo in
                BarView(state: $state, barInfo: barInfo, color: color, style: style)
            }
        }
        .frame(idealWidth: 18, idealHeight: 18)
        .opacity(state == .stop ? 0 : 1)
        .animation(.easeInOut(duration: 0.3), value: state)
        .onAppear {
            barInfos = generateBarInfos()
        }
    }

    private func generateBarInfos() -> [BarInfo] {
        (0 ..< count).map { id in
            BarInfo(
                id: id,
                maxValue: CGFloat.random(in: 0.7 ... 1.0),
                animationDuration: Double.random(in: 0.3 ... 0.8)
            )
        }
    }
}

private struct BarView: View {
    @Binding var state: SwimplyPlayIndicator.AudioState
    let barInfo: SwimplyPlayIndicator.BarInfo
    let color: Color
    let style: SwimplyPlayIndicator.Style

    var body: some View {
        LineView(maxValue: state == .play ? barInfo.maxValue : 0, style: style)
            .fill(color)
            .animation(
                state == .play ?
                    .easeInOut(duration: barInfo.animationDuration)
                    .repeatForever(autoreverses: true) :
                    .easeOut(duration: 0.3),
                value: state
            )
    }
}

private struct LineView: Shape {
    var maxValue: CGFloat
    let style: SwimplyPlayIndicator.Style

    var animatableData: CGFloat {
        get { maxValue }
        set { maxValue = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let cornerRadius = style == .legacy ? 0 : (rect.width / 2)
        let height = max(rect.width, maxValue * rect.height)
        let lineRect = CGRect(x: 0, y: rect.maxY - height, width: rect.width, height: height)
        return Path(roundedRect: lineRect, cornerRadius: cornerRadius)
    }
}
