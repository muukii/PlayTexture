//
//  SampleCardViewController.swift
//  PlayTexture
//
//  Created by muukii on 3/20/18.
//  Copyright © 2018 muukii. All rights reserved.
//

import UIKit
import AsyncDisplayKit

final class SampleCardViewController : CodeBasedViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    let node = CardNode(
      image: UIImage(named: "sample")!,
      title: "Lorem Ipsum",
      detail: "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
    )

    view.addSubnode(node)

    let layout = node.calculateLayoutThatFits(
      ASSizeRange(
        min: .init(width: 0.0, height: 0),
        max: .init(width: 240.0, height: .infinity)
      )
    )

    node.frame.size = layout.size
    node.view.center.x = view.bounds.midX
    node.view.center.y = view.bounds.midY

  }
}

extension SampleCardViewController {

  private final class CardNode : ASDisplayNode {

    private let imageNode: ASImageNode = .init()
    private let titleNode: ASTextNode = .init()
    private let detailNode: ASTextNode = .init()

    init(image: UIImage, title: String, detail: String) {

      super.init()

      titleNode.attributedText = NSAttributedString(
        string: title,
        attributes: [
          .font : UIFont.boldSystemFont(ofSize: 16),
          .foregroundColor : UIColor.white,
        ]
      )

      detailNode.attributedText = NSAttributedString(
        string: detail,
        attributes: [
          .font : UIFont.systemFont(ofSize: 14),
          .foregroundColor : UIColor.white,
        ]
      )

      imageNode.image = image

      automaticallyManagesSubnodes = true

    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

      return
        ASRatioLayoutSpec(
          ratio: 1.6180339887499,
          child: ASBackgroundLayoutSpec(
            child: ASInsetLayoutSpec(
              insets: .init(top: 8, left: 8, bottom: 8, right: 8),
              child: ASStackLayoutSpec(
                direction: .vertical,
                spacing: 8,
                justifyContent: .end,
                alignItems: .start,
                children: [
                  titleNode,
                  detailNode,
                  ]
              )
            ),
            background: imageNode
          )
      )
    }
  }
}
