//
//  PalatinoSequenceChecker.swift
//  Palatino
//
//  Created by Kurt Höblinger on 03.01.19.
//  Copyright © 2019 Kurt Höblinger. All rights reserved.
//

import Foundation

extension Palatino {
    func getArabicNumberFromRomanFigure(roman: Character) -> Int {
        let l: [Character: Int] = [
            "M": 1000,
            "D": 500,
            "C": 100,
            "L": 50,
            "X": 10,
            "V": 5,
            "I": 1
        ]
        
        return l[roman]!
    }
    
    func getRomanFigureFromArabicNumber(arabic: Int) -> Character {
        let l: [Int: Character] = [
            1000: "M",
            500: "D",
            100: "C",
            50: "L",
            10: "X",
            5: "V",
            1: "I"
        ]
        
        return l[arabic]!
    }
    
    func getLastRomanFigureFromString(string: String) -> Character {
        return Character(String(string.suffix(1)))
    }
    
    func getBeforeLastFigureFromString(string: String) -> Character {
        let c = String(string.suffix(2))
        return Character(String(c.prefix(1)))
    }
    
    func getFirstFigureFromArabicNumber(number: Int) -> Int {
        let s = String(number)
        return Int(String(s.prefix(1)))!
    }
    
    func getConsecutiveOccurancesOfFigure(string: String, figure: Character) -> Int {
        var i = 0
        var counter = 0
        string.forEach() { chara in
            if chara == figure {
                if i > 0 {
                    let beforeA = self.getArabicNumberFromRomanFigure(roman: self.getBeforeLastFigureFromString(string: string))
                    let figureA = self.getArabicNumberFromRomanFigure(roman: figure)
                    
                    if beforeA > figureA*10 || beforeA == figureA {
                        counter += 1
                    }
                } else {
                    counter += 1
                }
            }
            i += 1
        }
        return counter
    }
    
    func canReduce(figure: Character) -> Bool {
        if self.getFirstFigureFromArabicNumber(number: self.getArabicNumberFromRomanFigure(roman: figure)) == 1 {
            
            return true
        }
        
        return false
    }
    
    func isNumberAlreadyInString(string:String,figure:Character) -> Bool {
        if string.contains(figure) {
            return true
        }
        return false
    }
    
    func figureDoesAlreadyReduceOtherFigure(string: String, figure: Character) -> Bool {
        if canReduce(figure: figure) && figure != "M" {
            let reducedV1 = String(figure) + String(self.getRomanFigureFromArabicNumber(arabic: self.getArabicNumberFromRomanFigure(roman: figure)*10))
            let reducedV2 = String(figure) + String(self.getRomanFigureFromArabicNumber(arabic: self.getArabicNumberFromRomanFigure(roman: figure)*5))
            
            if string.contains(reducedV1) || string.contains(reducedV2) {
                return true
            }
        }
        return false
    }
    
    func figureWouldSucceedIncompatibleReducedNumber(string: String, figure: Character) -> Bool {
        let before = getBeforeLastFigureFromString(string: string)
        let beforeA = getArabicNumberFromRomanFigure(roman: before)
        
        let last = getLastRomanFigureFromString(string: string)
        let lastA = getArabicNumberFromRomanFigure(roman: last)
        if string.count > 1 {
            if  beforeA < lastA {
                let reduced = lastA - beforeA
                
                if getFirstFigureFromArabicNumber(number: lastA) == 5 {
                    if getArabicNumberFromRomanFigure(roman: figure) * 8 > reduced {
                        return true
                    }
                } else if getFirstFigureFromArabicNumber(number: lastA) == 1 {
                    if getArabicNumberFromRomanFigure(roman: figure) * 10 > reduced {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func figureCanNotBeReduced(string: String, figure: Character) -> Bool {
        var reducer = ""
        var enhancer = ""
        let arab = getArabicNumberFromRomanFigure(roman: figure)
        if arab <= 10 && arab > 1 {
            reducer = "I"
            enhancer = "V"
        } else if arab <= 100 && arab > 10 {
            reducer = "X"
            enhancer = "L"
        } else if arab <= 1000 && arab > 100 {
            reducer = "C"
            enhancer = "D"
        }
        
        if string.contains(reducer + reducer) || string.contains(enhancer + reducer) {
            return true
        }
        
        return false
    }
    
    func hasIncompatibleReducer(string: String, figure: Character) -> Bool {
        let newA = self.getArabicNumberFromRomanFigure(roman: self.getLastRomanFigureFromString(string: string))
        if self.getFirstFigureFromArabicNumber(number: newA) == 5 && getArabicNumberFromRomanFigure(roman: figure) > newA {
            return true
        }
        return false
    }
    
    func charFitsInSequence(string: String, figure: Character) -> Bool {
        var disallowed = 0
        var errors: [String] = []
        let last = getLastRomanFigureFromString(string: string)
        let lastA = getArabicNumberFromRomanFigure(roman: last)
        let newA = getArabicNumberFromRomanFigure(roman: figure)
        
        if newA > lastA*10 {
            disallowed += 1
            errors.append("The figure is incompatible with the last figure becuase it is smaller than 10 times the last figure.")
        }
        
        if self.getFirstFigureFromArabicNumber(number: newA) == 1 {
            if getConsecutiveOccurancesOfFigure(string: string, figure: figure) > 2 && figure != "M" {
                disallowed += 1
                errors.append("This number already occures 3 times. It can't appear 4 or more times.")
            } else if getConsecutiveOccurancesOfFigure(string: string, figure: figure) > 3 && figure != "M" {
                disallowed += 1
                errors.append("This number already occures 4 times. It can't appear 5 or more times.")
            }
        }
        
//        if figureDoesAlreadyReduceOtherFigure(string: string, figure: figure) {
//            disallowed += 1
//            errors.append("This figure already reduces anoter figure and therefor can't appear at this place in the sequence")
//        }
        
        if self.getFirstFigureFromArabicNumber(number: newA) == 5 {
            if self.isNumberAlreadyInString(string: string, figure: figure) {
                disallowed += 1
                errors.append("This number already occures once. It can't appear twice or more times.")
            }
        }
        
        if self.hasIncompatibleReducer(string: string, figure: figure) {
            disallowed += 1
            errors.append("The preceeding figure cannot reduce this figure.")
        }
        
        if self.figureWouldSucceedIncompatibleReducedNumber(string: string, figure: figure) {
            disallowed += 1
            errors.append("This number would succeed an incompatible already reduced number.")
        }
        
        if self.figureCanNotBeReduced(string: string, figure: figure) {
            disallowed += 1
            errors.append("The corresponding reducer already appears twice, so this number cannot be reduced anymore.")
        }
        
        //print(errors)
        
        if disallowed > 0 {
            return false
        }
        
        return true
    }
}
