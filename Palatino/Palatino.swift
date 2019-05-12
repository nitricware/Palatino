//
//  Palatino.swift
//  Palatino
//
//  Created by Kurt Höblinger on 20.12.18.
//  Copyright © 2018 Kurt Höblinger. All rights reserved.
//
//  Version 1
//  Plans for Version 2: Add Large Number Support

import Foundation

class Palatino {
    //    I    1
    //    V    5
    //    X    10
    //    L    50
    //    C    100
    //    D    500
    //    M    1000
    
    func convertArabicNumberToLatin(input: Int) -> String {
        if input == 0 {
            return "NULLA"
        }
        
        let thousands = getThousand(input: input)
        let hundreds = detectHundreds(input: thousands.remain!)
        let tens = detectTens(input: hundreds.remain!)
        let ones = detectOnes(input: tens.remain!)
        
        return thousands.string! + hundreds.string! + tens.string! + ones.string!
    }
    
    func getThousand(input: Int) -> romanPartialNumber {
        let thousands = input/1000
        let remain = input%1000
        let string = String(repeating: "M", count: thousands)
        
        let returnStruct = romanPartialNumber(
            unit: "M",
            count: thousands,
            remain: remain,
            string: string
        )
        return returnStruct
    }
    
    func detectHundreds(input: Int) -> romanPartialNumber {
        if input >= 900 {
            return self.createSingleLatinPartialNumber(latin: "CM", arabic: 900, input: input)
        } else if input >= 800 {
            return self.createSingleLatinPartialNumber(latin: "DCCC", arabic: 800, input: input)
        } else if input >= 700 {
            return self.createSingleLatinPartialNumber(latin: "DCC", arabic: 700, input: input)
        } else if input >= 600 {
            return self.createSingleLatinPartialNumber(latin: "DC", arabic: 600, input: input)
        } else if input >= 500 {
            return self.createSingleLatinPartialNumber(latin: "D", arabic: 500, input: input)
        } else if input >= 400 {
            return self.createSingleLatinPartialNumber(latin: "CD", arabic: 400, input: input)
        } else if input >= 300 {
            return self.createSingleLatinPartialNumber(latin: "CCC", arabic: 300, input: input)
        } else if input >= 200 {
            return self.createSingleLatinPartialNumber(latin: "CC", arabic: 200, input: input)
        } else if input >= 100 {
            return self.createSingleLatinPartialNumber(latin: "C", arabic: 100, input: input)
        } else {
            return self.createSingleLatinPartialNumber(latin: "", arabic: 0, input: input)
        }
    }
    
    func detectTens(input: Int) -> romanPartialNumber {
        if input >= 90{
            return self.createSingleLatinPartialNumber(latin: "XC", arabic: 90, input: input)
        } else if input >= 80 {
            return self.createSingleLatinPartialNumber(latin: "LXXX", arabic: 80, input: input)
        } else if input >= 70 {
            return self.createSingleLatinPartialNumber(latin: "LXX", arabic: 70, input: input)
        } else if input >= 60 {
            return self.createSingleLatinPartialNumber(latin: "LX", arabic: 60, input: input)
        } else if input >= 50 {
            return self.createSingleLatinPartialNumber(latin: "L", arabic: 50, input: input)
        } else if input >= 40 {
            return self.createSingleLatinPartialNumber(latin: "XL", arabic: 40, input: input)
        } else if input >= 30 {
            return self.createSingleLatinPartialNumber(latin: "XXX", arabic: 30, input: input)
        } else if input >= 20 {
            return self.createSingleLatinPartialNumber(latin: "XX", arabic: 20, input: input)
        } else if input >= 10 {
            return self.createSingleLatinPartialNumber(latin: "X", arabic: 10, input: input)
        } else {
            return self.createSingleLatinPartialNumber(latin: "", arabic: 0, input: input)
        }
    }
    
    func detectOnes(input: Int) -> romanPartialNumber {
        if input >= 9{
            return self.createSingleLatinPartialNumber(latin: "IX", arabic: 90, input: input)
        } else if input >= 8 {
            return self.createSingleLatinPartialNumber(latin: "VIII", arabic: 80, input: input)
        } else if input >= 7 {
            return self.createSingleLatinPartialNumber(latin: "VII", arabic: 70, input: input)
        } else if input >= 6 {
            return self.createSingleLatinPartialNumber(latin: "VI", arabic: 60, input: input)
        } else if input >= 5 {
            return self.createSingleLatinPartialNumber(latin: "V", arabic: 50, input: input)
        } else if input >= 4 {
            return self.createSingleLatinPartialNumber(latin: "IV", arabic: 40, input: input)
        } else if input >= 3 {
            return self.createSingleLatinPartialNumber(latin: "III", arabic: 30, input: input)
        } else if input >= 2 {
            return self.createSingleLatinPartialNumber(latin: "II", arabic: 20, input: input)
        } else if input >= 1 {
            return self.createSingleLatinPartialNumber(latin: "I", arabic: 10, input: input)
        } else {
            return self.createSingleLatinPartialNumber(latin: "", arabic: 0, input: input)
        }
    }
    
    func createSingleLatinPartialNumber(latin: String, arabic: Int, input: Int) -> romanPartialNumber {
        return romanPartialNumber(
            unit: latin,
            count: 1,
            remain: input - arabic,
            string: latin
        )
    }
    
    func calculateArabicNumberFromLatinNumber(latin: String) -> Int {
        let l: [Character: Int] = [
            "M": 1000,
            "D": 500,
            "C": 100,
            "L": 50,
            "X": 10,
            "V": 5,
            "I": 1
        ]
        let a = Array(latin.reversed())
        var b = Array<Int>()
        var x = 0
        
        a.forEach { c in
            b.append(l[c]!)
        }
        
        for i in 0...b.count-1 {
            if i == b.count-1 {
                // Last (actually first) letter, it will always be added
                x += b[i]
            } else {
                // Any other letter - it will always be added
                x += b[i]
                if b[i] > b[i+1] {
                    // If, however, the following letter is smaller than the current one
                    // it must be subtracted from the sum (twice, because it will be added
                    // in the next round. We could also check for the LAST letter the next round
                    // and if it is bigger, we won't add it and just skip it.
                    // Same shit, different name...
                    x -= b[i+1]*2
                }
            }
        }
        return x
    }
}
