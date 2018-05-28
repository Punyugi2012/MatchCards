//
//  CardCollectionViewCell.swift
//  MatchCards
//
//  Created by punyawee  on 26/5/61.
//  Copyright © พ.ศ. 2561 Punyugi. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    func setupCell(frontImg f: UIImage?, backImg b: UIImage?) {
        frontImage.image = f
        backImage.image = b
    }
    func filpCard() {
        UIView.transition(from: backImage, to: frontImage, duration: 0.4, options: [.transitionFlipFromLeft, .showHideTransitionViews, .allowUserInteraction])
    }
    func filpBackCard() {
        UIView.transition(from: frontImage, to: backImage, duration: 0.4, options: [.transitionFlipFromRight, .showHideTransitionViews, .allowUserInteraction])
    }
}
