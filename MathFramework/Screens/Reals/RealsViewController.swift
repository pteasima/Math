import UIKit
import ReactiveSwift
import Result
import ReactiveCocoa

public final class RealsViewController: UICollectionViewController {
  public override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .green

    let start = Signal<(), NoError>.pipe()
    let (
    initialSections,
    addItemInSection
    ) = realsViewModel(viewDidLoad: start.output)



    start.input.send(value: ())
  }

  //TODO: look for something like RxDataSources for ReactiveSwift?
  public var sections: [[RealsItem]] = []

  public override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return sections.count

  }
  public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sections[section].count
  }
  public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reu, for: <#T##IndexPath#>)
//    return cell
    fatalError()
  }
}
