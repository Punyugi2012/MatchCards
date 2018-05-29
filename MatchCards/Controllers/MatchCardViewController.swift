//
//  MathGameViewController.swift
//  MatchCards
//
//  Created by punyawee  on 26/5/61.
//  Copyright © พ.ศ. 2561 Punyugi. All rights reserved.
//

import UIKit
import Darwin

class MatchCardViewController: UIViewController {
    var matchCardModel: MatchCardModel!
    var cards = [Card]()
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var countTimeLbl: UILabel!
    @IBOutlet weak var fastestTimeLbl: UILabel!
    @IBOutlet weak var myLoader: UIActivityIndicatorView!
    var fCardIndexpath: IndexPath?
    var sCardIndexpath: IndexPath?
    var milliseconds: Float = 0.0
    var isCountedTime = false
    var secondsMinTime: Float = 0.0
    var timer: Timer?
    var modeGame: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        setModeGame()
        setTimeBar()
        setCounterTime()
        setMyLoader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.setGame()
        }
    }
    func setModeGame() {
        if modeGame == 0 {
            matchCardModel = MatchCardModel(numOfPairCards: 5)
        }
        else {
            matchCardModel = MatchCardModel(numOfPairCards: 10)
        }
    }
    func setGame() {
        cards = matchCardModel.getAllCards()
        myCollectionView.reloadData()
        preparePlayGame()
    }
    func preparePlayGame() {
        myCollectionView.allowsSelection = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.myLoader.stopAnimating()
            for cell in self.myCollectionView.visibleCells {
                if let cardCell = cell as? CardCollectionViewCell {
                    cardCell.filpCard()
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + (modeGame == 0 ? 2 : 4)) {
            for cell in self.myCollectionView.visibleCells {
                if let cardCell = cell as? CardCollectionViewCell {
                    cardCell.filpBackCard()
                }
            }
            self.myCollectionView.allowsSelection = true
        }
    }
}

extension MatchCardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCollectionViewCell {
            if let frontImg = UIImage(named: "card\(cards[indexPath.row].identifier)"),
                let backImg = UIImage(named: "back") {
                cardCell.setupCell(frontImg: frontImg, backImg: backImg)
            }
            else {
                cardCell.setupCell(frontImg: nil, backImg: nil)
            }
            return cardCell
        }
        return UICollectionViewCell()
    }
    func filpBackSelectedTwoCard(fIndexPath f: IndexPath, sIndexPath s: IndexPath) {
        if let fSelectedCard = myCollectionView.cellForItem(at: f) as? CardCollectionViewCell,
            let sSelectedCard = myCollectionView.cellForItem(at: s) as? CardCollectionViewCell {
            fSelectedCard.filpBackCard()
            sSelectedCard.filpBackCard()
            cards[f.row].isFilp = false
            cards[s.row].isFilp = false
            fCardIndexpath = nil
            sCardIndexpath = nil
        }
    }
    func fadeOutSelectedTwoCard(fIndexPath f: IndexPath, sIndexPath s: IndexPath) {
        if let fSelectedCard = myCollectionView.cellForItem(at: f) as? CardCollectionViewCell,
            let sSelectedCard = myCollectionView.cellForItem(at: s) as? CardCollectionViewCell {
            UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
                fSelectedCard.alpha = 0
                sSelectedCard.alpha = 0
            }) { (success) in
                fSelectedCard.filpBackCard()
                sSelectedCard.filpBackCard()
            }
            fCardIndexpath = nil
            sCardIndexpath = nil
        }
    }
    func isMathCard(fIndexPath f: IndexPath, sIndexPath s: IndexPath) -> Bool {
        let fCard = cards[f.row]
        let sCard = cards[s.row]
        if fCard.identifier == sCard.identifier {
            fCard.isMatch = true
            sCard.isMatch = true
            return true
        }
        return false
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cardCell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell {
            let card = cards[indexPath.row]
            if !card.isFilp && !card.isMatch {
                onCouterTime()
                cardCell.filpCard()
                card.isFilp = true
                if let fIndexPath = fCardIndexpath, let sIndexPath = sCardIndexpath {
                   filpBackSelectedTwoCard(fIndexPath: fIndexPath, sIndexPath: sIndexPath)
                }
                if fCardIndexpath == nil {
                    fCardIndexpath = indexPath
                }
                else if sCardIndexpath == nil {
                    sCardIndexpath = indexPath
                    if isMathCard(fIndexPath: fCardIndexpath!, sIndexPath: sCardIndexpath!) {
                        fadeOutSelectedTwoCard(fIndexPath: fCardIndexpath!, sIndexPath: sCardIndexpath!)
                        if matchCardModel.isFinishedGame() {
                            offCouterTime()
                            myLoader.startAnimating()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                self.setGame()
                            }
                        }
                    }
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: myCollectionView.bounds.width / 6, height: self.myCollectionView.frame.size.height / (modeGame == 0 ? 2 : 4) - 10) 
    }
}

extension MatchCardViewController {
    func setTimeBar() {
        countTimeLbl.text = "\(milliseconds)"
        if let fastestTime = UserDefaults.standard.value(forKey: (modeGame == 0 ? "fastestMedium":"fastestHard")) as? Float {
            secondsMinTime = fastestTime
            fastestTimeLbl.text = "\(secondsMinTime)"
        }
        else {
            secondsMinTime = Float.greatestFiniteMagnitude
            fastestTimeLbl.text = "-"
        }
    }
    func setFastestTimeLbl(newFastest n: Float) {
        fastestTimeLbl.text = "\(n)"
        UIView.animate(withDuration: 0.5, animations: {
            self.fastestTimeLbl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (success) in
            self.fastestTimeLbl.transform = CGAffineTransform.identity
        }
    }
    func setCounterTime() {
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    @objc func timerElapsed() {
        if isCountedTime {
            milliseconds += 1
            let seconds = "\( milliseconds / 1000)"
            countTimeLbl.text = "\(seconds)"
        }
    }
    func saveFastestTime(time t: Float) {
        UserDefaults.standard.set(t, forKey: (modeGame == 0 ? "fastestMedium":"fastestHard"))
    }
    func onCouterTime() {
        if !isCountedTime {
            milliseconds = 0.0
            isCountedTime = true
        }
    }
    func offCouterTime() {
        if isCountedTime {
            isCountedTime = false
            if secondsMinTime > milliseconds / 1000 {
                secondsMinTime = milliseconds / 1000
                saveFastestTime(time: secondsMinTime)
                setFastestTimeLbl(newFastest: secondsMinTime)
            }
        }
    }
}

extension MatchCardViewController {
    func setMyLoader() {
        myLoader.startAnimating()
        myLoader.hidesWhenStopped = true
    }
}

