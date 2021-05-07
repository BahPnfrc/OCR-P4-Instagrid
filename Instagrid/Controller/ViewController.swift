//
//  ViewController.swift
//  Instagrid
//
//  Created by Pierre-Alexandre on 30/04/2021.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: IBOulets
    
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
    
    //MARK: IBActions
    
    @IBAction func didTypeFirstButton(_ sender: Any) {
        currentSetting = .first
    }
    @IBAction func didTypeSecondButton(_ sender: Any) {
        currentSetting = .second
    }
    @IBAction func didTypeThirdButton(_ sender: Any) {
        currentSetting = .third
    }
    
    //MARK: Properties

    enum Setting {case first, second, third}
    enum FrameType { case first, second, third }
    
    var currentSetting: Setting = .first {
        didSet {
            resetSetting()
            switch currentSetting {
            case .first: firstSetting()
            case .second: secondSetting()
            case .third: thirdSetting()
            }
        }
    }
    
    var currentFrameType: FrameType = .first {
        didSet {
            let buttons =
                [upRowMainButton, upRowSecondButton,
                downRowMainButton, downRowSecondButton]
            var isHidden = [Bool]()
            switch currentFrameType {
            case .first:
                isHidden = [false, true, false, false]
            case .second:
                isHidden = [false, false, false, true]
            case .third:
                isHidden = [false, false, false, false]
            }
            for index in 0...3 {
                buttons[index]!.isHidden = isHidden[index]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultButtons()
        firstSetting()
    }
    
    private func setDefaultButtons() {
        let buttons: [UIButton] = [upRowMainButton, upRowSecondButton, downRowMainButton, downRowSecondButton]
        for button in buttons {
            button.layer.borderWidth = 10
            button.layer.borderColor = #colorLiteral(red: 0, green: 0.4076067805, blue: 0.6132292151, alpha: 1)
        }
    }
    
    private func resetSetting() {
        let pics: [UIImageView] = [firstPic, secondPic, thirdPic]
        for pic in pics {
            pic.isHidden = true
        }
    }
    private func firstSetting () {
        firstPic.isHidden = false
        firstPic.image = #imageLiteral(resourceName: "Selected")
        currentFrameType = .first
    }
    private func secondSetting () {
        secondPic.isHidden = false
        secondPic.image = #imageLiteral(resourceName: "Selected")
        currentFrameType = .second
    }
    private func thirdSetting () {
        thirdPic.isHidden = false
        thirdPic.image = #imageLiteral(resourceName: "Selected")
        currentFrameType = .third
    }
    
}

