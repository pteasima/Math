import ReactiveSwift
import Result
import Overture

final class CounterInputs: NSObject {
  @objc var viewDidLoad = NSNull.init()
  @objc var plus = NSNull.init()
  @objc var minus = NSNull.init()
}
final class CounterOutputs: NSObject {
  @objc var counterText = ""
  @objc var isMinusEnabled = false
}

typealias CounterViewModel = ViewModel<CounterInputs, CounterOutputs>
//
let counterViewModel: CounterViewModel = { inputs in
  let state = Signal.merge(
    inputs[\.viewDidLoad].map { _ in 0},
    inputs[\.plus].map { _ in 1 },
    inputs[\.minus].map { -1 }
    ).scan(0, +)

  return with(CoproductOfSignals<CounterOutputs>(), concat(
    set(\.[\.counterText], state.map(String.init(describing:))),
    set(\.[\.isMinusEnabled], state.map { $0 > 0 }.skipRepeats())
  ))
}
