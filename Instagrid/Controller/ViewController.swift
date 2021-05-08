//
//  ViewController.swift
//  Instagrid
//
//  Created by Pierre-Alexandre on 30/04/2021.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Oulets
    
    @IBOutlet weak var swipeArrow: UILabel!
    @IBOutlet weak var swipeLabel: UILabel!
    
    @IBOutlet weak var upRowMainButton: UIButton!
    @IBOutlet weak var upRowSecondButton: UIButton!
    @IBOutlet weak var downRowMainButton: UIButton!
    @IBOutlet weak var downRowSecondButton: UIButton!
    
    @IBOutlet weak var firstPic: UIImageView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondPic: UIImageView!
    @IBOutlet weak var secondbutton: UIButton!
    @IBOutlet weak var thirdPic: UIImageView!
    @IBOutlet weak var thirdButton: UIButton!
    
    // MARK: Properties

    enum Setting { case first, second, third }
    enum Frame { case first, second, third }

    var currentSetting: Setting = .first {
        didSet { _didSetCurrentSetting() }
    }
    var currentFrame: Frame = .first {
        didSet { _didSetCurrentFrame() }
    }
    
    // MARK: Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setDefaultButtons()
        _firstSetting()
    }
    
    private func _setDefaultButtons() {
        let buttons: [UIButton?] =
            [upRowMainButton, upRowSecondButton,
             downRowMainButton, downRowSecondButton]
        for button in buttons {
            button?.layer.borderWidth = 10
            button?.layer.borderColor = #colorLiteral(red: 0, green: 0.4076067805, blue: 0.6132292151, alpha: 1)
        }
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
    
    // MARK: Main functions
    
    private func _didSetCurrentSetting() {
        _resetSetting()
        switch currentSetting {
        case .first: _firstSetting()
        case .second: _secondSetting()
        case .third: _thirdSetting()
        }
    }
    
    private func _didSetCurrentFrame() {
        let buttons: [UIButton?] =
            [upRowMainButton, upRowSecondButton,
            downRowMainButton, downRowSecondButton]
        var isHiddenValue = [Bool]()
        switch currentFrame {
        case .first:
            isHiddenValue = [false, true, false, false]
        case .second:
            isHiddenValue = [false, false, false, true]
        case .third:
            isHiddenValue = [false, false, false, false]
        }
        guard buttons.count == isHiddenValue.count else {
            fatalError("Guard check failed")
        }
        for index in 0...buttons.count - 1 {
            buttons[index]?.isHidden = isHiddenValue[index]
        }
    }
    
    // MARK: Sub functions
    
    private func _resetSetting() {
        let pics: [UIImageView?] = [firstPic, secondPic, thirdPic]
        for pic in pics {
            pic?.isHidden = true
        }
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
    
}

