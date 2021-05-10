//
//  ViewController.swift
//  Instagrid
//
//  Created by Pierre-Alexandre on 30/04/2021.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Oulets
    
    @IBOutlet weak var instagridLabel: UILabel!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var displayView: UIView!
    
    @IBOutlet weak var swipeArrow: UILabel!
    @IBOutlet weak var swipeLabel: UILabel!
    
    @IBOutlet weak var upRowMainView: UIView!
    @IBOutlet weak var upRowSecondView: UIView!
    @IBOutlet weak var downRowMainView: UIView!
    @IBOutlet weak var downRowSecondView: UIView!
    
    @IBOutlet weak var upRowMainPic: UIImageView!
    @IBOutlet weak var upRowMainButton: UIButton!
    @IBOutlet weak var upRowSecondPic: UIImageView!
    @IBOutlet weak var upRowSecondButton: UIButton!
    @IBOutlet weak var downRowMainPic: UIImageView!
    @IBOutlet weak var downRowMainButton: UIButton!
    @IBOutlet weak var downRowSecondPic: UIImageView!
    @IBOutlet weak var downRowSecondButton: UIButton!
    
    @IBOutlet weak var firstPic: UIImageView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondPic: UIImageView!
    @IBOutlet weak var secondbutton: UIButton!
    @IBOutlet weak var thirdPic: UIImageView!
    @IBOutlet weak var thirdButton: UIButton!
    
    // MARK: Properties
    
    enum Orientation: CaseIterable { case isPortrait, isLandscape }
    enum Setting { case first, second, third }
    enum Frame { case first, second, third }

    var currentOrientation: Orientation {
        return UIDevice.current.orientation.isPortrait ? .isPortrait : .isLandscape
    }
    var currentSetting: Setting = .first {
        didSet { didSetCurrentSetting() }
    }
    var currentFrame: Frame = .first {
        didSet { didSetCurrentFrame() }
    }
    
    // MARK: Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttons: [UIButton?] =
            [upRowMainButton, upRowSecondButton,
             downRowMainButton, downRowSecondButton]
        for button in buttons {
            button?.layer.borderWidth = 10
            button?.layer.borderColor = #colorLiteral(red: 0, green: 0.4076067805, blue: 0.6132292151, alpha: 1)
        }
        
        addSwipeGesture()
        //_setPortrait()
        _firstSetting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setSwipeOrientation()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        setSwipeOrientation()
    }
    
    // MARK: Actions
    
    @IBAction func didCallFirstButton(_ sender: Any) {
        currentSetting = .first
    }
    @IBAction func didCallSecondButton(_ sender: Any) {
        currentSetting = .second
    }
    @IBAction func didCallThirdButton(_ sender: Any) {
        currentSetting = .third
    }
    
    // MARK: Frame functions
    
    private func didSetCurrentFrame() {
        let views: [UIView?] =
            [upRowMainView, upRowSecondView,
             downRowMainView, downRowSecondView]
        var isHiddenValue = [Bool]()
        switch currentFrame {
        case .first:
            isHiddenValue = [false, true, false, false]
        case .second:
            isHiddenValue = [false, false, false, true]
        case .third:
            isHiddenValue = [false, false, false, false]
        }
        guard views.count == isHiddenValue.count else {
            fatalError("Guard check failed")
        }
        for index in 0...views.count - 1 {
            views[index]?.isHidden = isHiddenValue[index]
        }
    }
    
    // MARK: Settings functions
    
    func didSetCurrentSetting() {
        _resetSetting()
        switch currentSetting {
        case .first: _firstSetting()
        case .second: _secondSetting()
        case .third: _thirdSetting()
        }
    }
    private func _resetSetting() {
        let pics: [UIImageView?] = [firstPic, secondPic, thirdPic]
        for pic in pics { pic?.isHidden = true }
    }
    private func _firstSetting () {
        firstPic.isHidden = false
        firstPic.image = #imageLiteral(resourceName: "Selected")
        currentFrame = .first
    }
    private func _secondSetting () {
        secondPic.isHidden = false
        secondPic.image = #imageLiteral(resourceName: "Selected")
        currentFrame = .second
    }
    private func _thirdSetting () {
        thirdPic.isHidden = false
        thirdPic.image = #imageLiteral(resourceName: "Selected")
        currentFrame = .third
    }
    
    // MARK: Orientation functions
    
    func setSwipeOrientation() {
        if currentOrientation == .isPortrait {
            _setPortrait()
        } else { _setLandscape() }
    }
    private func _setPortrait() {
        (swipeArrow.text, swipeLabel.text) = ("<", "Swipe up to share")
        swipeArrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    }
    private func _setLandscape() {
        (swipeArrow.text, swipeLabel.text) = ("<", "Swipe left to share")
        swipeArrow.transform = CGAffineTransform(rotationAngle: 0)
    }
    
    // MARK: Gesture functions
    
    func addSwipeGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(performSwipe))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(performSwipe))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func performSwipe(_ sender: UISwipeGestureRecognizer) {
        var factor: (x: CGFloat, y: CGFloat)
        switch (currentOrientation, sender.state, sender.direction) {
        case (.isPortrait, .ended, .up): factor = (0, 0 - UIScreen.main.bounds.height)
        case (.isLandscape, .ended, .left): factor = (0 - UIScreen.main.bounds.width, 0)
        default: return
        }
        
        UIView.animate(withDuration: 0.5) {
            self.displayView.transform = CGAffineTransform(translationX: factor.x, y: factor.y)
        } completion: { (completed) in
            if completed {
                _ = self.export()
                UIView.animate(withDuration: 0.5) {
                    self.displayView.transform = .identity
                }
            }
        }
    }
    
    private func export() -> Bool {
        guard let export = self.displayView else { return false }
        let renderer = UIGraphicsImageRenderer(size: export.bounds.size)
        let image = renderer.image { ctx in
            export.drawHierarchy(in: export.bounds, afterScreenUpdates: true)
        }
        let items: [Any] = [image]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
        return true
    }

}

