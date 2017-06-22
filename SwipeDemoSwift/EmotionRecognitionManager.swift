//
//  EmotionRecognitionManager.swift
//  SwipeDemoSwift
//
//  Created by T556038 on 18/06/17.
//  Copyright © 2017 UBS. All rights reserved.
//

import Foundation
import Affdex

class EmotionRecognitionManager: NSObject, AFDXDetectorDelegate {
    static let sharedInstance = EmotionRecognitionManager()
    
    private var detector: AFDXDetector? = nil
    private var delegate: EmotionRecognitionDelegate?
    
    private var latestEmotions = [EmotionRecognitionResult]()
    
    // emoji
    enum Emoji {
        case laughing
        case smiley
        case relaxed
        case wink
        case flushed
        case disappointed
        case rage
        case scream
        case neutral
    }
    
    let emojiDictionary = [Emoji.laughing: "😄",
                           Emoji.smiley: "🙂",
                           Emoji.relaxed: "😌",
                           Emoji.wink: "😉",
                           Emoji.flushed: "😳",
                           Emoji.disappointed: "😞",
                           Emoji.rage: "😠",
                           Emoji.scream: "😱",
                           Emoji.neutral: "😐"]
    
    override private init() {
        super.init()
        detector = AFDXDetector(delegate: self, using: AFDX_CAMERA_FRONT, maximumFaces:1)
        
        detector?.lipPress = true
        detector?.chinRaise = true
        detector?.joy = true
        detector?.browFurrow = true
        detector?.browRaise = true
        
        detector?.setDetectEmojis(true)
    }
    
    func setDelegate(_ delegate: EmotionRecognitionDelegate) {
        EmotionRecognitionManager.sharedInstance.delegate = delegate
    }
    
    // ----------------- manager methods
    func start() {
        _ = detector?.start()
    }
    
    func stop() {
        detector?.stop()
    }
    
    func getConfidenceLevel() -> Int? {
        if !latestEmotions.isEmpty {
            let confidenceLevel = calculateConfidenceLevel()
            latestEmotions.removeAll()
            return confidenceLevel
        }
        
        return nil
    }
    
    // ----------------- affectiva delegates
    func detectorDidStartDetectingFace(face: AFDXFace) {
        // handle new face
    }
    
    func detectorDidStopDetectingFace(face: AFDXFace) {
        // handle loss of existing face
    }
    
    func detector(_ detector: AFDXDetector, hasResults: NSMutableDictionary?, for forImage: UIImage, atTime: TimeInterval) {
        
        if let results = hasResults {
            for (_, face) in results {
                if let faceObject = face as? AFDXFace {
                    let result = EmotionRecognitionResult(lipPress: faceObject.expressions.lipPress, chinRaise: faceObject.expressions.chinRaise, joy: faceObject.emotions.joy)
                    
                    // add latest emotions results, store only 4
                    if latestEmotions.count == 4 {
                        latestEmotions.remove(at: 0)
                    }
                    latestEmotions.append(result)
                    
                    // when user is confused call delegate
                    if isUserConfused(faceObject: faceObject) {
                        delegate?.confusionDetected()
                    }
                    
                    // inform delegate about emoji update
                    delegate?.emojiUpdated(emoji: getEmojiImage(faceObject: faceObject))
                }
            }
        } else {
            delegate?.emotionsDetectionFailed()
        }
    }
    
    // ----------------- helpers
    private func isUserConfused(faceObject: AFDXFace) -> Bool {
        let maxLevel: Float = 95
        if Float(faceObject.expressions.browFurrow) > maxLevel || Float(faceObject.expressions.browRaise) > maxLevel {
            return true
        }
        return false
    }
    
    private func getEmojiImage(faceObject: AFDXFace) -> UIImage? {
        var currentMax: Float = 0
        var emoji = Emoji.neutral
        
        var currentToCheck: Float = Float(faceObject.emojis.laughing)
        if currentToCheck > currentMax {
            currentMax = currentToCheck
            emoji = Emoji.laughing
        }
        
        currentToCheck = Float(faceObject.emojis.smiley)
        if currentToCheck > currentMax {
            currentMax = currentToCheck
            emoji = Emoji.smiley
        }
        
        currentToCheck = Float(faceObject.emojis.relaxed)
        if currentToCheck > currentMax {
            currentMax = currentToCheck
            emoji = Emoji.relaxed
        }
        
        currentToCheck = Float(faceObject.emojis.wink)
        if currentToCheck > currentMax {
            currentMax = currentToCheck
            emoji = Emoji.wink
        }
        
        currentToCheck = Float(faceObject.emojis.flushed)
        if currentToCheck > currentMax {
            currentMax = currentToCheck
            emoji = Emoji.flushed
        }
        
        currentToCheck = Float(faceObject.emojis.disappointed)
        if currentToCheck > currentMax {
            currentMax = currentToCheck
            emoji = Emoji.disappointed
        }
        
        currentToCheck = Float(faceObject.emojis.rage)
        if currentToCheck > currentMax {
            currentMax = currentToCheck
            emoji = Emoji.rage
        }
        
        currentToCheck = Float(faceObject.emojis.scream)
        if currentToCheck > currentMax {
            currentMax = currentToCheck
            emoji = Emoji.scream
        }
        
        return emojiDictionary[emoji]!.image()
    }
    
    private func calculateConfidenceLevel() -> Int {
        let initialConfidenceLevel = 50
        
        var lipPress: Float = 0
        var chinRaise: Float = 0
        var joy: Float = 0
        
        // sum
        for result in latestEmotions {
            lipPress += result.lipPress
            chinRaise += result.chinRaise
            joy += result.joy
        }
        
        // calcualte average
        let count = Float(latestEmotions.count)
        let averageLipPress = lipPress/count
        let averageChinRasie = chinRaise/count
        let averageJoy = joy/count
        
        // calculate negative confidence (based on lip and chin changes), than scale from 0-100 to 0-50
        let scaleFactor: Float = 2
        let negativeConfidence = (averageLipPress + averageChinRasie)/(2*scaleFactor)
        let positiveConfidence = averageJoy/scaleFactor
        
        return initialConfidenceLevel + Int(positiveConfidence) - Int(negativeConfidence)
    }
    
    class EmotionRecognitionResult {
        let lipPress: Float
        let chinRaise: Float
        let joy: Float
        
        init(lipPress: CGFloat, chinRaise: CGFloat, joy: CGFloat) {
            self.lipPress = Float(lipPress)
            self.chinRaise = Float(chinRaise)
            self.joy = Float(joy)
        }
    }
}
