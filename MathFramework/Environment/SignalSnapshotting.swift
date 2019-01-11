
import UIKit
import ReactiveSwift
import Result
import ReactiveCocoa
import SnapshotTesting
import Overture

typealias SnapshotTime = Int //like in RxTest

extension Snapshotting where Value: SignalProtocol, Format == String {
  static func events(timeout: Double) -> Snapshotting {
    return Snapshotting<String, String>.lines
      .asyncPullback { signal in
        return Async { callback in
          var dis: Disposable?
          var events: [Signal<Value.Value, Value.Error>.Event] = []
          dis = signal.signal.observe {
            events.append($0)
          }
          DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            callback(events.map(String.init(describing:)).joined(separator: "\n"))
          }
        }
    }
  }
}

protocol SignalKeyPathEraser {
  subscript<Value>(any kp: KeyPath<Self, Signal<Value, NoError>>) -> Signal<Any, NoError> { get }
}
extension SignalKeyPathEraser {
  subscript<Value>(any kp: KeyPath<Self, Signal<Value, NoError>>) -> Signal<Any, NoError> {
    get {
      return self[keyPath: kp].map { $0 }
    }
  }
}



func keyedLines<Value>(from keysAndSnaps: [(String, Snapshotting<Value, String>)]) -> Snapshotting<Value, String> {
  return Snapshotting<String, String>.lines.asyncPullback { input in
        return Async { callback in
          //todo: Async.merge
          var result: String = ""
          var done = 0 {
            didSet {
              if done >= keysAndSnaps.count {
                callback(result)
              }
            }
          }

          keysAndSnaps.forEach { (arg) in
            let (key, snap) = arg
            snap.snapshot(input).run {
              result.append( "\n" + key + ":" + $0)
              done += 1
            }
          }
        }
      }
    }

extension Snapshotting where Value: SignalKeyPathEraser, Format == String {
  static func signals(from keyPaths: [KeyPath<Value, Signal<Any, NoError>>]) -> Snapshotting {
      return keyedLines(from: keyPaths.map { (kp: KeyPath<Value, Signal<Any, NoError>>) -> (String, Snapshotting) in
        Swift.dump(kp)
        return ("fuck", Snapshotting<Signal<Any,NoError>, String>.events(timeout: 3)
          .pullback(get(\Value.[any: kp])))
      })
  }
}

