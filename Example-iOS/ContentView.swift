import PlayIndicator
import SwiftUI

struct ContentView: View {
    @State var state: PlayIndicator.AudioState = .stop

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

            PlayIndicator(state: self.$state, lineColor: .black)
                .frame(width: 18, height: 18)
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
