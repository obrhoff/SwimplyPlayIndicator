import SwiftUI
import SwimplyPlayIndicator

struct ContentView: View {
    @State var state: SwimplyPlayIndicator.AudioState = .stop

    var body: some View {
        VStack {
            Button("Play") {
                self.state = .play
            }
            Button("Pause") {
                self.state = .pause
            }

            Button("Stop") {
                self.state = .stop
            }

            SwimplyPlayIndicator(state: self.$state, lineColor: .white)
                .frame(width: 18, height: 18)
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
