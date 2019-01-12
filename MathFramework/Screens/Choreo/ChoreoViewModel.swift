import ReactiveSwift
import Result
import Overture

final class ChoreoInputs: NSObject {
  @objc var viewDidLoad = NSNull()
  @objc var record = NSNull()
  @objc var play = NSNull()
  @objc var guitar = NSNull()
}
final class ChoreoOutputs: NSObject {
  @objc var playButtonTitle = ""
}

typealias ChoreoViewModel = ViewModel<ChoreoInputs, ChoreoOutputs>

let choreoViewModel: ChoreoViewModel = { inputs in
  let isPlaying = inputs[\.play]
                  .scan(false) { acc, _ in !acc }

  return with(.init(),
              set(\.[\.playButtonTitle], isPlaying.map { $0 ? "pause" : "play"} )
              )
}
