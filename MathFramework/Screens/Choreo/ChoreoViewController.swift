import UIKit
import ReactiveSwift
import Result
import Overture

public final class ChoreoViewController: UIViewController {

  @IBOutlet var recordButton: UIButton!
  @IBOutlet var playButton: UIButton!
  @IBOutlet var guitarButton: UIButton!

  private let _viewDidLoad = Signal<NSNull, NoError>.pipe()
  public override func viewDidLoad() {
    super.viewDidLoad()

    let inputs = with(CoproductOfSignals<ChoreoInputs>(), concat(
      set(\.[\.viewDidLoad], _viewDidLoad.output),
      set(\.[\.record], recordButton.reactive.controlEvents(.touchUpInside).map { _ in }),
      set(\.[\.play], playButton.reactive.controlEvents(.touchUpInside).map { _ in })
    ))
    let outputs = choreoViewModel(inputs)

    playButton.reactive.title <~ outputs[\.playButtonTitle]
    
  }
}
