//
//  MainView.swift
//  test
//
//  Created by Aleksandr Fetisov on 03.12.2020.
//

import UIKit

class MainView: UIView {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultViewLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var transitionView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        makeView()
        //setupTransitionView()
    }
    
    override func layoutSubviews() {
        resultView.clipsToBounds = true
        resultView.layer.cornerRadius = resultView.frame.height / 12
    }
    
    func setupTransitionView() {
        transitionView.frame = scrollView.frame
        transitionView.backgroundColor = .gray
      
    }
    
    func makeView() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        let decksCount = 9
        for _ in 0..<decksCount {
            let view = createDeck()
            stackView.addArrangedSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            guard let subview = stackView.arrangedSubviews.last else { return }
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: subview.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: subview.centerYAnchor)
            ])
        }
        stackView.autoresizesSubviews = false
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        // костыль для конфликта AutoLayout и Frames (не вычисляется subview.height)
        _ = stackView.subviews.map { $0.frame.size = CGSize(width: 108, height: 243)}
    }
    
    func createDeck() -> UIView {
        var deckView = UIView()
        let cards = createPackOfCards()
        guard let card = cards.first else { return deckView }
        let deckWidth = card.frame.width
        let cardHeight = card.frame.height
        let offset: CGFloat = ceil(cardHeight * 0.33)
        let deckHeight = (cardHeight - offset) * CGFloat((cards.count - 1)) + cardHeight
        let frame = CGRect(x: 0, y: 0, width: deckWidth, height: deckHeight)
        deckView = UIView(frame: frame)
        
        _ = cards.map { deckView.addSubview($0) }
        return deckView
    }
    
    func createPackOfCards() -> [UIView] {
        let width: CGFloat = 108
        let height: CGFloat = 81
        let offset: CGFloat = ceil(height * 0.33)
        let secondOriginY = height - offset
        let thirdOriginY = height - offset + secondOriginY
        let fourthOriginY = height - offset + thirdOriginY
        let originYArray: [CGFloat] = [.zero, secondOriginY, thirdOriginY, fourthOriginY]
        let viewColors = [UIColor.green, UIColor.blue, UIColor.yellow, UIColor.red]
        var cardsArray = [UIView]()
        _ = zip(originYArray, viewColors).map { originY, color in
            let rect = CGRect(x: 0, y: originY, width: width, height: height)
            let view = UIView(frame: rect)
            view.clipsToBounds = true
            view.layer.cornerRadius = view.frame.height / 12
            view.backgroundColor = color
            cardsArray.append(view)
        }
        return cardsArray
    }
    
}
