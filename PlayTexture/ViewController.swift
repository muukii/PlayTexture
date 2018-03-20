//
//  ViewController.swift
//  PlayTexture
//
//  Created by muukii on 3/20/18.
//  Copyright © 2018 muukii. All rights reserved.
//

import UIKit

import AsyncDisplayKit

class ViewController: UIViewController {

  private let collectionNode: ASCollectionNode = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.sectionInset = .zero

    let node = ASCollectionNode(collectionViewLayout: layout)
    node.view.alwaysBounceVertical = true

    return node
  }()

  private var items: [PushItem] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    view.addSubnode(collectionNode)
    collectionNode.view.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      collectionNode.view.topAnchor.constraint(equalTo: view.topAnchor),
      collectionNode.view.rightAnchor.constraint(equalTo: view.rightAnchor),
      collectionNode.view.leftAnchor.constraint(equalTo: view.leftAnchor),
      collectionNode.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      ])

    items.append(.init(
      title: "Card",
      detail: "",
      viewControllerFactory: {
        SampleCardViewController()
    }))

    defer {
      collectionNode.delegate = self
      collectionNode.dataSource = self
      collectionNode.view.delaysContentTouches = false
    }
  }

}

extension ViewController : ASCollectionDelegateFlowLayout, ASCollectionDataSource {

  func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
    return 1
  }

  func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {

    let item = items[indexPath.item]

    return {
      CellNode(title: item.title, detail: item.detail)
    }
  }

  func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {

    return ASSizeRange(
      min: .init(width: collectionNode.bounds.width, height: 0),
      max: .init(width: collectionNode.bounds.width, height: .infinity)
    )
  }

  func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {

    let item = items[indexPath.item]

    let controller = item.viewControllerFactory()

    navigationController?.pushViewController(controller, animated: true)

  }
}

extension ViewController {

  private struct PushItem {
    let title: String
    let detail: String
    let viewControllerFactory: () -> UIViewController
  }

  private final class CellNode : ASCellNode {

    private let titleNode: ASTextNode = .init()
    private let detailNode: ASTextNode = .init()

    init(title: String, detail: String) {
      super.init()

      backgroundColor = .white

      titleNode.attributedText = NSAttributedString(string: title)
      detailNode.attributedText = NSAttributedString(string: detail)

      addSubnode(titleNode)
      addSubnode(detailNode)

      // You can use following code instead of above code.
      // automaticallyManagesSubnodes = true
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

      let stack =
        ASStackLayoutSpec(
          direction: .vertical,
          spacing: 8,
          justifyContent: .start,
          alignItems: .start,
          children: [
            titleNode,
            detailNode,
          ]
      )

      let inset =
        ASInsetLayoutSpec(
          insets: .init(top: 16, left: 16, bottom: 16, right: 16),
          child: stack
      )

      return inset

    }

    override var isHighlighted: Bool {
      didSet {
        UIView.animate(
          withDuration: 0.2,
          delay: 0,
          options: [.beginFromCurrentState],
          animations: {
            if self.isHighlighted {
              self.view.backgroundColor = .init(white: 0.95, alpha: 1)
            } else {
              self.view.backgroundColor = .white

            }
        },
          completion: nil
        )
      }
    }
  }
}
