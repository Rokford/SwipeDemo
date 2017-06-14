//
//  ViewController.swift
//  SwipeDemoSwift
//
//  Created by Grzegorz Izworski on 06/04/2017.
//

import UIKit
import Affdex
import Koloda

class ViewController: UIViewController, AFDXDetectorDelegate {

    @IBOutlet weak var kolodaView: KolodaView!
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ethnicityLabel: UILabel!
    @IBOutlet weak var attentionLabel: UILabel!
    @IBOutlet weak var smirkLabel: UILabel!
    @IBOutlet weak var smileLabel: UILabel!
    
    
    var detector : AFDXDetector? = nil
    let images: [UIImage] = [#imageLiteral(resourceName: "004-store"), #imageLiteral(resourceName: "001-paper-plane"), #imageLiteral(resourceName: "003-flask"), #imageLiteral(resourceName: "002-form"), #imageLiteral(resourceName: "005-diagram")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        // init manager, create csv table
        let questionsManager = FinanceQuestionsManager.sharedInstance
        
        let firstQuestion = FinanceQuestionsManager.CalibrationQuestion()
        let possiblePositions = firstQuestion.possiblePositions
        
        let secondQuestion = FinanceQuestionsManager.LossAversionQuestion(calibrationPosition: possiblePositions[0].0, calibrationValue: possiblePositions[0].1)
        let secondQuestionPossibleSteps = secondQuestion.possibleExitSteps
        
        let thirdQuestion = FinanceQuestionsManager.UncertanityAversionQuestion(lossAversionExitStep: secondQuestionPossibleSteps[0].0, lossAversionValue: secondQuestionPossibleSteps[0].1)
        let thirdQuestionPossibleSteps = thirdQuestion.possibleExitSteps
        
        let fourthQuestion = FinanceQuestionsManager.EmotionalExperienceQuestion(uncertanityAversionExitStep: thirdQuestionPossibleSteps[0].0, uncertanityAversionValue: thirdQuestionPossibleSteps[0].1)
        let fourthQuestionPossiblePositions = fourthQuestion.getPossiblePositions()
        
        let fifthQuestion = FinanceQuestionsManager.InvestmentTemperamentQuestion(emotionalExperiencePosition: fourthQuestionPossiblePositions[0])
        let fifthQuestionPossiblePositions = fifthQuestion.getPossiblePositions()
        
        let result = questionsManager.getResult(investmentTemperamentPosition: fifthQuestionPossiblePositions[0])
        
        print("\(result)")
        
        // create the detector
        detector = AFDXDetector(delegate:self, using:AFDX_CAMERA_FRONT, maximumFaces:1)
        
        detector?.smile = true
        detector?.attention = true
        detector?.smirk = true

        
        detector?.age = true
        detector?.gender = true
        detector?.ethnicity = true

        detector?.start()
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
                let age = ageString(ageInt: (faceObject.appearance.age.rawValue))
                let gender = genderString(genderInt: (faceObject.appearance.gender.rawValue))
                let eth = faceObject.appearance.ethnicity.rawValue
                
                let attentionValue = faceObject.expressions.attention
                let smileValue = faceObject.expressions.smile
                let smirkValue = faceObject.expressions.smirk
                
                ageLabel.text = "\(age)"
                genderLabel.text = "\(gender)"
                ethnicityLabel.text = "\(eth)"
                
                attentionLabel.text = "\(Int(attentionValue))"
                smileLabel.text = "\(Int(smileValue))"
                smirkLabel.text = "\(Int(smirkValue))"
                }
            }
        } else {
            // handle unprocessed image in this block of code
        }
    }
}

func ageString(ageInt: UInt32) -> String {
    switch ageInt {
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

func genderString(genderInt: UInt32) -> String {
    switch genderInt {
    case 1:
        return "Male"
    case 2:
        return "Female"
    default:
        return "Unknown"
    }
}

extension ViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }
    
    func koloda(koloda: KolodaView, didSelectCardAt index: Int) {
//        UIApplication.sharedApplication.openURL(NSURL(string: "https://yalantis.com/")!)
    }
}

extension ViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return 5
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let uiView = CardOverlayView()
        uiView.imageView.image = images[index]
        
        return uiView
        
//        return UIImageView(image: images[index])
    }
    
//    func koloda(koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//        return Bundle.main.loadNibNamed("OverlayCardView",
//                                                  owner: self, options: nil)?[0] as? OverlayView
//    }
}

