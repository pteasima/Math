import ReactiveSwift
import enum Result.NoError

public typealias RealsItem = String

public func realsViewModel(
  viewDidLoad: Signal<(), NoError>
  ) -> (
  initialSections: Signal<[[RealsItem]], NoError>,
  addItemInSection: Signal<(Int, RealsItem), NoError>
  ) {
    let initialSections = viewDidLoad.map {
      [["foo"]]
    }
  return (
    initialSections: initialSections,
    addItemInSection: .never
    )
}
