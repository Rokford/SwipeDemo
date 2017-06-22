//
//  ViewController.swift
//  SwipeDemoSwift
//
//  Created by Grzegorz Izworski on 06/04/2017.
//

import UIKit
import Affdex
import Koloda

class ViewController: UIViewController, EmotionRecognitionDelegate {

    @IBOutlet weak var kolodaView: KolodaView!
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ethnicityLabel: UILabel!
    @IBOutlet weak var attentionLabel: UILabel!
    @IBOutlet weak var smirkLabel: UILabel!
    @IBOutlet weak var smileLabel: UILabel!
    
    var emotionRecognitionManager: EmotionRecognitionManager?
    
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
        
        emotionRecognitionManager = EmotionRecognitionManager(withDelegate: self)
        emotionRecognitionManager?.start()
    }
    
    func finishAndShowResultsScreen() {
        emotionRecognitionManager?.stop()
        performSegue(withIdentifier: "showResults", sender: self)
    }
    
    // emotion detection delegates
    func emotionsDetected(result: EmotionRecognitionResult) {
        ageLabel.text = result.getAgeString()
        genderLabel.text = result.getGenderString()
        ethnicityLabel.text = result.getEthnicityString()
        
        attentionLabel.text = result.getAttentionString()
        smileLabel.text = result.getSmileString()
        smirkLabel.text = result.getSmirkString()
    }
    
    func emotionsDetectionFailed() {
        // TODO
    }
}

// -------------------

extension ViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
//        kolodaView.resetCurrentCardIndex()
        
        finishAndShowResultsScreen()
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

