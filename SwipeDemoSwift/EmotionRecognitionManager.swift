//
//  EmotionRecognitionManager.swift
//  SwipeDemoSwift
//
//  Created by T556038 on 18/06/17.
//  Copyright © 2017 UBS. All rights reserved.
//

import Foundation
import Affdex

class EmotionRecognitionManager: AFDXDetectorDelegate {
    var detector: AFDXDetector? = nil
    var delegate: EmotionRecognitionDelegate?

    init(withDelegate delegate: EmotionRecognitionDelegate) {
        self.delegate = delegate
        // create the detector
        detector = AFDXDetector(delegate:self, using:AFDX_CAMERA_FRONT, maximumFaces:1)
        
        detector?.smile = true
        detector?.attention = true
        detector?.smirk = true
        
        
        detector?.age = true
        detector?.gender = true
        detector?.ethnicity = true
    }
    
    func start() {
        _ = detector?.start()
    }
    
    func stop() {
        detector?.stop()
    }
    
    func detectorDidStartDetectingFace(face : AFDXFace) {
        // handle new face
    }
    
    func detectorDidStopDetectingFace(face : AFDXFace) {
        // handle loss of existing face
    }
    
    func detector(_ detector : AFDXDetector, hasResults : NSMutableDictionary?, for forImage : UIImage, atTime : TimeInterval) {
        // handle processed and unprocessed images here
        if let results = hasResults {
            // handle processed image in this block of code
            // enumrate the dictionary of faces
            for (_, face) in results {
                if let faceObject = face as? AFDXFace {
                    let result = EmotionRecognitionResult(age: faceObject.appearance.age.rawValue, gender: faceObject.appearance.gender.rawValue, ethnicity: faceObject.appearance.ethnicity.rawValue, attention: faceObject.expressions.attention, smile: faceObject.expressions.smile, smirk: faceObject.expressions.smirk)
                    
                    delegate?.emotionsDetected(result: result)
                }
            }
        } else {
            // handle unprocessed image in this block of code
        }
    }
}
