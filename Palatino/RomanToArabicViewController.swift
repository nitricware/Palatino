//
//  LatinToArabicViewController.swift
//  Palatino
//
//  Created by Kurt Höblinger on 26.12.18.
//  Copyright © 2018 Kurt Höblinger. All rights reserved.
//

import UIKit

class RomanToArabicViewController: UIViewController {
    var errorType: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var romanNumberLabel: UILabel!
    @IBOutlet weak var arabicNumberLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func mButtonPressed(_ sender: Any) {
        self.numberKeyPressed(number: "M")
    }
    @IBAction func cButtonPressed(_ sender: Any) {
        self.numberKeyPressed(number: "C")
    }
    @IBAction func dButtonPressed(_ sender: Any) {
        self.numberKeyPressed(number: "D")
    }
    @IBAction func xButtonPressed(_ sender: Any) {
        self.numberKeyPressed(number: "X")
    }
    @IBAction func lButtonPressed(_ sender: Any) {
        self.numberKeyPressed(number: "L")
    }
    @IBAction func iButtonPressed(_ sender: Any) {
        self.numberKeyPressed(number: "I")
    }
    @IBAction func vButtonPressed(_ sender: Any) {
        self.numberKeyPressed(number: "V")
    }
    @IBAction func clearButtonPressed(_ sender: Any) {
        self.clearKeyPressed()
    }
    @IBAction func infoButtonPressed(_ sender: Any) {
        var t: String
        var m: String
        
        if errorType == 1 {
            t = NSLocalizedString("ERROR_TOO_BIG_TITLE", comment: "Title for Error Alert.")
            m = NSLocalizedString("ERROR_TOO_BIG_TEXT", comment: "Body for Error Alert.")
        } else if errorType == 2 {
            t = NSLocalizedString("ERROR_WRONG_SEQUENCE_TITLE", comment: "Title for Error Alert.")
            m = NSLocalizedString("ERROR_WRONG_SEQUENCE_TEXT", comment: "Body for Error Alert.")
        } else {
            t = "Unknown Error"
            m = "I don't know how you managed to do so, but congratulations you hit an error I never implemented..."
        }
        
        let alert = UIAlertController(title: t, message: m, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func numberKeyPressed(number: String) {
        let oldNumber = romanNumberLabel.text!
        let palatino = Palatino()
        var newNumber: String = ""
        var arabic: Int = 0
        var buttonState: Bool
        
        if oldNumber == "NULLA" {
            newNumber = number
            arabic = palatino.calculateArabicNumberFromLatinNumber(latin: newNumber)
            buttonState = true
        } else {
            newNumber = oldNumber + number
            arabic = palatino.calculateArabicNumberFromLatinNumber(latin: newNumber)
            buttonState = true
            if arabic > 4999 {
                newNumber = oldNumber
                arabic = Int(arabicNumberLabel.text!)!
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.07
                animation.repeatCount = 4
                animation.autoreverses = true
                animation.fromValue = NSValue(cgPoint: CGPoint(x: self.romanNumberLabel.center.x - 10, y: self.romanNumberLabel.center.y))
                animation.toValue = NSValue(cgPoint: CGPoint(x: self.romanNumberLabel.center.x + 10, y: self.romanNumberLabel.center.y))
                
                self.romanNumberLabel.layer.add(animation, forKey: "position")
                
                self.errorType = 1
                
                buttonState = false
            } else if !palatino.charFitsInSequence(string: oldNumber, figure: Character(number)) {
                newNumber = oldNumber
                arabic = Int(arabicNumberLabel.text!)!
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.07
                animation.repeatCount = 4
                animation.autoreverses = true
                animation.fromValue = NSValue(cgPoint: CGPoint(x: self.romanNumberLabel.center.x - 10, y: self.romanNumberLabel.center.y))
                animation.toValue = NSValue(cgPoint: CGPoint(x: self.romanNumberLabel.center.x + 10, y: self.romanNumberLabel.center.y))
                
                self.romanNumberLabel.layer.add(animation, forKey: "position")
                
                self.errorType = 2
                
                buttonState = false
            }
        }
        
        romanNumberLabel.text = newNumber
        arabicNumberLabel.text = String(arabic)
        infoButton.isHidden = buttonState
    }
    
    func clearKeyPressed() {
        romanNumberLabel.text = "NULLA"
        arabicNumberLabel.text = "0"
        infoButton.isHidden = true
    }
}
