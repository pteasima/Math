import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

public final class CounterViewController: UIViewController {

  
  @IBOutlet var minusButton: UIButton!
  @IBOutlet var counterLabel: UILabel!
  @IBOutlet var plusButton: UIButton!

  private var _viewDidLoad = Signal<NSNull, NoError>.pipe()
  public override func viewDidLoad() {
    super.viewDidLoad()

    var inputs = CoproductOfSignals<CounterInputs>()
    inputs[\.viewDidLoad] = _viewDidLoad.output
    inputs[\.plus] = plusButton.reactive.controlEvents(.touchUpInside).map { _ in }
    inputs[\.minus] = minusButton.reactive.controlEvents(.touchUpInside).map { _ in }

    let outputs = counterViewModel(inputs)

    counterLabel.reactive.text <~ outputs[\.counterText]
    minusButton.reactive[\.isEnabled] <~ outputs[\.isMinusEnabled]

    _viewDidLoad.input.send(value: .init())

  }
}
