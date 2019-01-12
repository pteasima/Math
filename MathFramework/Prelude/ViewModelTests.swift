import XCTest
import ReactiveSwift
import Result
import Overture
@testable import MathFramework


class ViewModelTests: XCTestCase {

    override func setUp() {

    }

    override func tearDown() {
  }

    func testExample() {

      let viewDidLoad = Signal<(), NoError>.pipe()
      let plus = Signal<(), NoError>.pipe()

      let inputs = with(CoproductOfSignals<CounterInputs>(), concat (
        mut(\.[\.viewDidLoad], viewDidLoad.output),
        mut(\.[\.plus], plus.output)
      ))

      let expectation = self.expectation(description: "JUST WAIT")

      let outputs = choreo.add(viewModel: counterViewModel)(inputs)
      outputs[\.counterText].observeValues {
        print($0)
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        plus.input.send(value: ())
        plus.input.send(value: ())
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        choreo.playback()
      }

      waitForExpectations(timeout: 30, handler: nil)

  }


}

  public struct Choreo {
    public func add<I,O>(viewModel: @escaping ViewModel<I,O>, name: (StaticString) -> String = { String(describing: $0) }, file: StaticString = #file) -> ViewModel<I,O> {
      let vmName = name(file)
      return  { inputs in
        storage[vmName] = (
          observer: { (key: String, value: Any) in
            inputs.raw.input.send(value: (key, value as! I))
        },
          recordedEvents: []
        )
        inputs.raw.output.observeValues{ key, value in
          storage[vmName]?.recordedEvents.append((key, value))
        }
        return viewModel(inputs)
      }
    }

    public func playback() {
      storage.forEach { (arg) in

        let (_, vmInputs) = arg
        vmInputs.recordedEvents.forEach {
          vmInputs.observer($0.0, $0.1)
        }
      }
    }


  }

private var storage: [String: (observer: (String, Any) -> Void, recordedEvents: [(String, Any)])] = [:]

public var choreo = Choreo()

