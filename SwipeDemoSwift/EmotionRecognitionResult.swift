//
//  EmotionRecognitionResult.swift
//  SwipeDemoSwift
//
//  Created by T556038 on 18/06/17.
//  Copyright © 2017 UBS. All rights reserved.
//

import Foundation
import UIKit

class EmotionRecognitionResult {
    let age: UInt32
    let gender: UInt32
    let ethnicity: UInt32
    let attention: CGFloat
    let smile: CGFloat
    let smirk: CGFloat
    
    init(age: UInt32, gender: UInt32, ethnicity: UInt32, attention: CGFloat, smile: CGFloat, smirk: CGFloat) {
        self.age = age
        self.gender = gender
        self.ethnicity = ethnicity
        self.attention = attention
        self.smile = smile
        self.smirk = smirk
    }
    
    func getAgeString() -> String {
        switch age {
        case 1:
            return "Under 18"
        case 2:
            return "18 - 24"
        case 3:
            return "25 - 34"
        case 4:
            return "35 - 44"
        case 5:
            return "45 - 54"
        case 6:
            return "55 - 64"
        case 7:
            return "65 or more"
        default:
            return "Unknown"
        }
    }
    
    func getGenderString() -> String {
        switch gender {
        case 1:
            return "Male"
        case 2:
            return "Female"
        default:
            return "Unknown"
        }
    }

    func getEthnicityString() -> String {
        return String(ethnicity)
    }
    
    func getAttentionString() -> String {
        return String(describing: attention)
    }
    
    func getSmileString() -> String {
        return String(describing: smile)
    }
    
    func getSmirkString() -> String {
        return String(describing: smirk)
    }
}
