import Combine
import SwiftUI

public struct SwimplyPlayIndicator: View {
    fileprivate struct AnimationValue: Identifiable {
        let id: Int
        let maxValue: CGFloat
        let animation: Animation
    }

    public enum AudioState {
        case stop
        case play
        case pause
    }

    public enum Style {
        case legacy
        case modern
    }

    @Binding private var state: AudioState
    @State private var opacity: Double = 0.0
    private let color: Color
    private let count: Int
    private let style: Style

    private var animationValues: [AnimationValue] {
        let valueRange: ClosedRange<CGFloat> = (0.7 ... 1.0)
        let speedRange: ClosedRange<Double> = (0.6 ... 1.2)
        let animations: [Animation] = [.easeIn, .easeOut, .easeInOut, .linear]
        let values = (0 ..< count)
            .compactMap { (id) -> AnimationValue? in
                animations
                    .randomElement()
                    .map { animation -> AnimationValue in
                        AnimationValue(id: id, maxValue: CGFloat.random(in: valueRange),
                                       animation: animation.speed(Double.random(in: speedRange)))
                    }
            }
        return values
    }

    public init(state: Binding<AudioState>, count: Int = 4, color: Color = Color.black, style: Style = .modern) {
        _state = state
        self.count = count
        self.color = color
        self.style = style
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 2) {
            ForEach(self.animationValues) { animationValue in
                BarView(state: $state, animationValue: animationValue, color: color, style: style)
            }
        }
        .opacity(opacity)
        .drawingGroup()
        .frame(idealWidth: 18, idealHeight: 18)
        .onAppear {
            self.opacity = 0.0
        }
        .onReceive(Just(state), perform: { _ in
            withAnimation(.linear) {
                self.opacity = state == .stop ? 0.0 : 1.0
            }
        })
    }
}

private struct BarView: View {
    @State private var heightValue: CGFloat = 0.0
    @Binding private var state: SwimplyPlayIndicator.AudioState
    private let color: Color
    private let animationValue: SwimplyPlayIndicator.AnimationValue
    private let style: SwimplyPlayIndicator.Style

    init(state: Binding<SwimplyPlayIndicator.AudioState>, animationValue: SwimplyPlayIndicator.AnimationValue, color: Color = Color.black, style: SwimplyPlayIndicator.Style) {
        self.animationValue = animationValue
        self.style = style
        self.color = color
        _state = state
    }

    var body: some View {
        LineView(maxValue: heightValue, style: style)
            .fill(color)
            .onAppear {
                heightValue = 0.0
            }
            .onReceive(Just(state).throttle(for: 0.5, scheduler: RunLoop.main, latest: true), perform: { _ in
                let animation = state == .play
                    ? animationValue.animation.repeatForever()
                    : Animation.easeOut(duration: 0.3)

                withAnimation(animation) {
                    self.heightValue = state == .play ? animationValue.maxValue : 0.0
                }
            })
    }
}

private struct LineView: Shape {
    var maxValue: CGFloat = 0.0
    let style: SwimplyPlayIndicator.Style

    var animatableData: CGFloat {
        get {
            maxValue
        }
        set {
            maxValue = newValue
        }
    }

    func path(in rect: CGRect) -> Path {
        let cornerRadius = style == .legacy ? 0 : (rect.width / 2)
        let height = max(rect.width, maxValue * rect.height)
        let lineRect = CGRect(x: 0, y: rect.maxY - height, width: rect.width, height: height)
        return Path(roundedRect: lineRect, cornerRadius: cornerRadius)
    }
}
