//
//  EmotionRecognitionDelegate.swift
//  SwipeDemoSwift
//
//  Created by T556038 on 18/06/17.
//  Copyright © 2017 UBS. All rights reserved.
//

import Foundation

protocol EmotionRecognitionDelegate {
    func emotionsDetected(result: EmotionRecognitionResult)
    func emotionsDetectionFailed()
}
