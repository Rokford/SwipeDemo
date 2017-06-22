//
//  EmotionRecognitionDelegate.swift
//  SwipeDemoSwift
//
//  Created by T556038 on 18/06/17.
//  Copyright © 2017 UBS. All rights reserved.
//

import UIKit
import Foundation

protocol EmotionRecognitionDelegate {
    func emojiUpdated(emoji: UIImage?)
    func confusionDetected()
    func emotionsDetectionFailed()
}
