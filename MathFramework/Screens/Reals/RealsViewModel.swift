import ReactiveSwift
import enum Result.NoError

public typealias RealsItem = String

public func realsViewModel(
  viewDidLoad: Signal<(), NoError>,
  addTapped: Signal<(), NoError>
  ) -> (
  initialSections: Signal<[[RealsItem]], NoError>,
  addItemInSection: Signal<(Int, RealsItem), NoError>
  ) {
    let initialSections = viewDidLoad.map {
      [["foo"]]
    }

    let addItemInSection = addTapped.map {
      (0, "bar")
    }
  return (
    initialSections: initialSections,
    addItemInSection: addItemInSection
    )
}
