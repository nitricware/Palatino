//
//  ViewController.swift
//  Palatino
//
//  Created by Kurt Höblinger on 19.12.18.
//  Copyright © 2018 Kurt Höblinger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let notificationFeedbackGenerator = UINotificationFeedbackGenerator()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func zeroButtonPress(_ sender: Any) {
        numberKeyPressed(number: 0)
    }
    @IBAction func oneButtonPress(_ sender: Any) {
        numberKeyPressed(number: 1)
    }
    @IBAction func twoButtonPress(_ sender: Any) {
        numberKeyPressed(number: 2)
    }
    @IBAction func threeButtonPress(_ sender: Any) {
        numberKeyPressed(number: 3)
    }
    @IBAction func fourButtonPress(_ sender: Any) {
        numberKeyPressed(number: 4)
    }
    @IBAction func fiveButtonPress(_ sender: Any) {
        numberKeyPressed(number: 5)
    }
    @IBAction func sixButtonPress(_ sender: Any) {
        numberKeyPressed(number: 6)
    }
    @IBAction func sevenButtonPress(_ sender: Any) {
        numberKeyPressed(number: 7)
    }
    @IBAction func eightButtonPress(_ sender: Any) {
        numberKeyPressed(number: 8)
    }
    @IBAction func nineButtonPress(_ sender: Any) {
        numberKeyPressed(number: 9)
    }
    @IBAction func clearButtonPress(_ sender: Any) {
        clearKeyPressed()
    }
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var arabicFigures: UILabel!
    @IBOutlet weak var latinFigures: UILabel!
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        let t = NSLocalizedString("ERROR_TOO_BIG_TITLE", comment: "Title for Error Alert.")
        let m = NSLocalizedString("ERROR_TOO_BIG_TEXT", comment: "Body for Error Alert.")
        
        let alert = UIAlertController(title: t, message: m, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func numberKeyPressed(number: Int) -> Void {
        // Prepare taptic engine in case some error occurs
        notificationFeedbackGenerator.prepare()
        // TODO: Implement Figure Length Cap with animation
        // Creating new empty var "newFigure" to be filled with the new, compiled figure
        var newFigure: String
        var buttonState: Bool
        // Converting the number Int to a String, since a label only takes a String
        let numberString = String(number)
        // Load the currently displayed text into a let
        if let oldFigure = self.arabicFigures.text {
            // If the currently displayed figure is just a zero, replace it with new newly pressed figure button. If not, append the new figure to the old one
            if oldFigure == "0" {
                newFigure = numberString
                buttonState = true
            } else {
                // Shake arabic figures if it would become a four digit number
                if Int(oldFigure + numberString)! > 4999 || oldFigure.count > 3{
                    self.errorAnimation()
                    
                    newFigure = oldFigure
                    
                    buttonState = false
                } else {
                    newFigure = oldFigure + numberString
                    buttonState = true
                }
            }
        } else {
            newFigure = numberString
            buttonState = true
        }
        
        // Write the new figure into the label
        self.arabicFigures.text = newFigure
        // Show or hide the button depending on preceeing action
        self.infoButton.isHidden = buttonState
        // Convert Number Instantly
        let convert = Palatino()
        let latin = convert.convertArabicNumberToLatin(input: Int(newFigure)!)
        self.latinFigures.text = latin
    }
    
    func errorAnimation() -> Void {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.arabicFigures.center.x - 10, y: self.arabicFigures.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.arabicFigures.center.x + 10, y: self.arabicFigures.center.y))
        
        self.arabicFigures.layer.add(animation, forKey: "position")
        // Send haptic feedback
        notificationFeedbackGenerator.notificationOccurred(.error)
    }
    
    func clearKeyPressed() -> Void {
        self.arabicFigures.text = "0"
        self.infoButton.isHidden = true
        self.latinFigures.text = "NULLA"
    }
}

