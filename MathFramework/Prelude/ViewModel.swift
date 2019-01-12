import ReactiveSwift
import Result
import Overture

//todo: eventually we can have just one cached value of Values running around (or other optimizations...)
public struct CoproductOfSignals<Values: NSObject> {
  public var raw = Signal<(String, Values), NoError>.pipe()

  private subscript<Value>(raw kp: ReferenceWritableKeyPath<Values, Value>) -> Signal<Value, NoError> {
    get {
      return raw.output.filterMap {
        if $0.0 == kp._kvcKeyPathString {
          return $0.1[keyPath: kp]
        } else {
          return nil
        }
        }
        .on(event: {print($0)})
    }
    set {
      newValue.map { v -> (String, Values) in
        //using overture lenses makes compiler drunk
        let values = Values()
        values[keyPath: kp] = v
        return (kp._kvcKeyPathString!, values)
        }

        .observe(raw.input)
    }
  }
  public subscript(_ kp: ReferenceWritableKeyPath<Values, NSNull>) -> Signal<(), NoError> {
    get { return self[raw: kp].map { _ in } }
    set { self[raw: kp] = newValue.map { .init() } }
  }
  public subscript<Value>(_ kp: ReferenceWritableKeyPath<Values, Value>) -> Signal<Value, NoError> {
    get { return self[raw: kp] }
    set { self[raw: kp] = newValue
    }
  }
  
}

public typealias ViewModel<I, O> = (CoproductOfSignals<I>) -> CoproductOfSignals<O> where I: NSObject, O: NSObject


