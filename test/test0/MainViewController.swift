//
//  MainViewController.swift
//  test
//
//  Created by Aleksandr Fetisov on 03.12.2020.
//

import UIKit

class MainViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var mainView: MainView!
    @IBOutlet weak var longGR: UILongPressGestureRecognizer!
    @IBOutlet weak var panGR: UIPanGestureRecognizer!
    
    var cardPressed: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func handleLong(_ recognizer: UILongPressGestureRecognizer) {
        mainView.transitionView.isHidden = false
        cardPressed?.isHidden = false
        
        let location = recognizer.location(in: mainView.stackView)
        guard let deckIndex = mainView.stackView.subviews.firstIndex(where: { $0.frame.contains(location)}) else { return }
        let deck = mainView.stackView.subviews[deckIndex].subviews
        let newX = location.x - mainView.stackView.subviews[deckIndex].frame.origin.x
        let subLocation = CGPoint(x: newX, y: location.y)
        guard let cardIndex = deck.lastIndex(where: { $0.frame.contains(subLocation)}) else { return }
        let card = deck[cardIndex]
        card.isHidden = true
        cardPressed = card
        
        mainView.transitionView.frame.size = card.frame.size
        mainView.transitionView.backgroundColor = card.backgroundColor
        mainView.transitionView.clipsToBounds = true
        mainView.transitionView.layer.cornerRadius = mainView.transitionView.frame.height / 12
        mainView.transitionView.layer.borderColor = UIColor.gray.cgColor
        mainView.transitionView.layer.borderWidth = 1
        mainView.transitionView.center.x = recognizer.location(in: view).x
        mainView.transitionView.center.y = recognizer.location(in: view).y
        
        recognizer.state = .recognized
        
    }
    
    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
        guard let recognizerView = recognizer.view else { return }
        let translation = recognizer.translation(in: view)
        recognizerView.center.x += translation.x
        recognizerView.center.y += translation.y
        recognizer.setTranslation(.zero, in: view)
        
        if recognizer.state == .ended {
            let point = CGPoint(x: recognizerView.center.x, y: recognizerView.center.y)
            if mainView.resultView.frame.contains(point) {
                mainView.resultView.backgroundColor = mainView.transitionView.backgroundColor
            } else {
                cardPressed?.isHidden = false
            }
            mainView.transitionView.isHidden = true
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
//        if gestureRecognizer == self.longGR && otherGestureRecognizer == self.panGR {
//            return true
//        }
//        return false
    }
    

    
     

}

