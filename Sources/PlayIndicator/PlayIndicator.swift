import SwiftUI

public struct PlayIndicator: View {
    private struct AnimationValues: Identifiable {
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
    private let lineColor: Color
    private let minimalValue: CGFloat = 0.1
    private let values: [AnimationValues]

    private var stopAnimation: Animation {
        Animation.easeOut.delay(0.05)
    }

    public init(state: Binding<AudioState>, lineColor: Color = Color.black) {
        self._state = state
        self.lineColor = lineColor
        self.values = [AnimationValues(id: 1, maxValue: 0.4, animation: Animation.easeIn(duration: 0.175)),
                       AnimationValues(id: 2, maxValue: 0.9, animation: Animation.easeInOut(duration: 0.2)),
                       AnimationValues(id: 3, maxValue: 0.6, animation: Animation.easeOut(duration: 0.175)),
                       AnimationValues(id: 4, maxValue: 0.4, animation: Animation.easeInOut(duration: 0.285))]
    }

    public var body: some View {
        GeometryReader { reader in
            HStack(alignment: .center, spacing: 1) {
                ForEach(self.values) { value in
                    PlaybackBarView(maxValue:
                        self.animating ? (self.state == .play ? value.maxValue : self.minimalValue) : self.minimalValue)
                        .stroke(self.lineColor, lineWidth: reader.size.width / 8)
                        .animation(self.state == .play ? value.animation.repeatForever() : self.stopAnimation)
                }
            }.drawingGroup()
                .opacity(self.state == .stop ? 0.0 : 1.0)
                .animation(Animation.linear)
                .onAppear {
                    self.animating.toggle()
                }
        }
    }
}

private struct PlaybackBarView: Shape {
    var maxValue: CGFloat

    var animatableData: CGFloat {
        get {
            return maxValue
        }
        set {
            maxValue = newValue
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .init(x: rect.midX, y: rect.maxY))
        path.addLine(to: .init(x: rect.midX, y: rect.maxY - (maxValue * rect.height)))
        return path
    }
}
