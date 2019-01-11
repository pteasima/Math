import UIKit
import ReactiveSwift
import Result
import ReactiveCocoa
import Overture

public final class RealsViewController: UICollectionViewController {
  public override func viewDidLoad() {
    super.viewDidLoad()

    let start = Signal<(), NoError>.pipe()
    let (
    initialSections,
    addItemInSection
    ) = realsViewModel(
      viewDidLoad: start.output,
      addTapped: addTappedPipe.output
      )

    

    self.reactive[\.sections] <~ initialSections
    addItemInSection
      .take(during: reactive.lifetime)
      .observeValues { [unowned self] (section, newItem) in
        self.sections[section].append(newItem)
        self.collectionView.insertItems(at: [IndexPath(item: self.sections[section].count - 1, section: section)])
    }


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
    return with(collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.labelCell, for: indexPath)!,
                set(\LabelCell.label.text, sections[indexPath.section][indexPath.item])
    )
  }


  //UIBarButtonItem ReactiveCocoa integration sucks, so use regular IBAction
  private let addTappedPipe = Signal<(), NoError>.pipe()
  @IBAction func addTapped() {
    addTappedPipe.input.send(value: ())
  }
}

private let itemSize = 30
final class RealsLayout: UICollectionViewLayout {

  override var collectionViewContentSize: CGSize {
    return CGSize(
      //all sections should be same width so just take first
      width: collectionView!.numberOfItems(inSection: 0) * itemSize,
      height: collectionView!.numberOfSections * itemSize
    )
  }

  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    let frame = CGRect(
      origin: CGPoint(
        x: indexPath.item * itemSize,
        y: indexPath.section * itemSize),
      size: CGSize(width: itemSize, height: itemSize)
    )
    return with(UICollectionViewLayoutAttributes(forCellWith: indexPath),
                set(\.frame, frame)
    )
  }
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    //TODO: optimize
    return Array(0..<collectionView!.numberOfSections).flatMap { section in
      Array(0..<collectionView!.numberOfItems(inSection: section)).compactMap {
        layoutAttributesForItem(at: IndexPath(item: $0, section: section))
      }
    }
  }
}
