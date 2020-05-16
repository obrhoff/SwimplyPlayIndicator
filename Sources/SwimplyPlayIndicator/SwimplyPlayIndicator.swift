import SwiftUI

public struct SwimplyPlayIndicator: View {
    struct AnimationValue: Identifiable {
        let id: Int
        let maxValue: CGFloat
        let animation: Animation
    }

    public enum AudioState {
        case stop
        case play
        case pause
    }

    @Binding private var state: AudioState
    @State private var animating: Bool = false
    private let minimalValue: CGFloat = 0.1
    public let lineColor: Color
    public let lineCount: Int

    private var stopAnimation: Animation {
        Animation.easeOut(duration: 0.2)
    }

    private var opacity: Double {
        state == .stop ? 0.0 : 1.0
    }

    private var opacityAnimation: Animation? {
        Animation.linear
    }

    private var animationValues: [AnimationValue] {
        let valueRange: ClosedRange<CGFloat> = (0.2 ... 1.0)
        let speedRange: ClosedRange<Double> = (0.7 ... 1.2)
        let animations: [Animation] = [.easeIn, .easeOut, .easeInOut, .linear]
        let values = (0 ..< lineCount).compactMap { (id) -> AnimationValue? in
            guard let animation = animations.randomElement() else { return nil }
            return AnimationValue(id: id, maxValue: CGFloat.random(in: valueRange),
                                  animation: animation.speed(Double.random(in: speedRange)))
        }
        return values
    }

    public init(state: Binding<AudioState>, lineCount: Int = 4, lineColor: Color = Color.black) {
        self._state = state
        self.lineCount = lineCount
        self.lineColor = lineColor
    }

    public var body: some View {
        GeometryReader { reader in
            HStack(alignment: .center, spacing: 1) {
                ForEach(self.animationValues) { value in
                    LineView(maxValue:
                        self.state == .play ? value.maxValue : self.minimalValue)
                        .stroke(self.lineColor, lineWidth: reader.size.width / 8)
                        .animation(self.state == .play ? value.animation.repeatForever() : Animation.easeOut(duration: 0.3))
                }
            }

        }.opacity(self.opacity)
            .drawingGroup()
            .animation(Animation.linear)
    }
}

private extension SwimplyPlayIndicator {
    struct LineView: Shape {
        var maxValue: CGFloat

        var animatableData: CGFloat {
            get { maxValue }
            set { maxValue = newValue }
        }

        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: .init(x: rect.midX, y: rect.maxY))
            path.addLine(to: .init(x: rect.midX, y: rect.maxY - (maxValue * rect.height)))
            return path
        }
    }
}
