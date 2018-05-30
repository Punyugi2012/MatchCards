//
//  GameMenuViewController.swift
//  MatchCards
//
//  Created by punyawee  on 27/5/61.
//  Copyright © พ.ศ. 2561 Punyugi. All rights reserved.
//

import UIKit

class GameMenuViewController: UIViewController {
    
    var modeGame: ModeGame!
    @IBOutlet weak var fastestMedium: UILabel!
    @IBOutlet weak var fastestHard: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFastestTime()
    }
    func setFastestTime() {
        if let medium = UserDefaults.standard.value(forKey: KeyFastestTime.fastestMedium.rawValue) {
            fastestMedium.text = "Fastest Time Medium: \(medium)"
        }
        else {
            fastestMedium.text = "Fastest Time Medium: - "
        }
        if let hard = UserDefaults.standard.value(forKey: KeyFastestTime.fastestHard.rawValue) {
            fastestHard.text = "Fastest Time Hard: \(hard)"
        }
        else {
            fastestHard.text = "Fastest Time Hard: - "
        }
    }
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        setFastestTime()
    }
    @IBAction func selectedMediumMode(_ sender: UIButton) {
        modeGame = .medium
        performSegue(withIdentifier: "ToPlayGame", sender: self)
    }
    @IBAction func selectedHardMode(_ sender: UIButton) {
        modeGame = .hard
        performSegue(withIdentifier: "ToPlayGame", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToPlayGame" {
            if let destination = segue.destination as? MatchCardViewController {
                switch modeGame {
                    case .medium:
                        destination.modeGame = .medium
                    case .hard:
                        destination.modeGame = .hard
                    default:
                        break
                }
            }
        }
    }
 

}
