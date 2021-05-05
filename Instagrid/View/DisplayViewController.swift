//
//  DisplayViewController.swift
//  Instagrid
//
//  Created by Pierre-Alexandre on 30/04/2021.
//

import UIKit

class DisplayViewController: UIView {

    @IBOutlet weak var upRowMainButton: UIButton!
    @IBOutlet weak var upRowSecondButton: UIButton!
    @IBOutlet weak var downRowMainButton: UIButton!
    @IBOutlet weak var downRowSecondButton: UIButton!
    
    enum FrameType { case first, second, third }
    
    var currentFrameType: FrameType = .first {
        didSet {
            let buttons =
                [upRowMainButton, upRowSecondButton,
                downRowMainButton, downRowSecondButton]
            var isEnabled = [Bool]()
            switch currentFrameType {
            case .first:
                isEnabled = [true, false, true, true]
            case .second:
                isEnabled = [true, true, true, false]
            case .third:
                isEnabled = [true, true, true, true]
            }
            for index in 0...3 {
                buttons[index]!.isEnabled = isEnabled[index]
            }
        }
    }

}
