import UIKit

class ViewController: UIViewController {
    
    //MARK: Oulets
    
    @IBOutlet weak var instagridLabel: UILabel!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var displayViewMainStack: UIStackView!
    
    @IBOutlet weak var swipeArrow: UILabel!
    @IBOutlet weak var swipeLabel: UILabel!
    
    @IBOutlet weak var upRowMainView: UIView!
    @IBOutlet weak var upRowSecondView: UIView!
    @IBOutlet weak var downRowMainView: UIView!
    @IBOutlet weak var downRowSecondView: UIView!
    
    @IBOutlet weak var upRowMainPic: UIImageView!
    @IBOutlet weak var upRowMainPlus: UIImageView!
    @IBOutlet weak var upRowMainButton: UIButton!
    
    @IBOutlet weak var upRowSecondPic: UIImageView!
    @IBOutlet weak var upRowSecondPlus: UIImageView!
    @IBOutlet weak var upRowSecondButton: UIButton!
    
    @IBOutlet weak var downRowMainPic: UIImageView!
    @IBOutlet weak var downRowMainPlus: UIImageView!
    @IBOutlet weak var downRowMainButton: UIButton!
    
    @IBOutlet weak var downRowSecondPic: UIImageView!
    @IBOutlet weak var downRowSecondPlus: UIImageView!
    @IBOutlet weak var downRowSecondButton: UIButton!
    
    @IBOutlet weak var firstPic: UIImageView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondPic: UIImageView!
    @IBOutlet weak var secondbutton: UIButton!
    @IBOutlet weak var thirdPic: UIImageView!
    @IBOutlet weak var thirdButton: UIButton!
    
    @IBOutlet weak var displayViewPortraitConstraint: NSLayoutConstraint!
    @IBOutlet weak var displayViewLandscapeConstraint: NSLayoutConstraint!
    
    // MARK: - Enum
    
    enum EnumOrientation { case isUndefined, isPortrait, isLandscape }
    enum EnumSetting { case isFirst, isSecond, isThird }
    enum EnumFrame { case isFirst, isSecond, isThird }
    enum EnumTag: Int { case upMain, upSecond, downMain, downSecond }
    
    // MARK: - Properties
    
    let borderWidth: CGFloat = 5.0
    
    let imagePicker = UIImagePickerController()
    var imageDesigner: UIImageView?
    
    var activityViewController: UIActivityViewController?

    var currentOrientation: EnumOrientation = .isUndefined
    var currentSetting: EnumSetting = .isFirst {
        didSet { settingDidChange() }
    }
    var currentFrame: EnumFrame = .isFirst {
        didSet { frameDidChange() }
    }
    
    // MARK: - Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collection: [Any?] =
            [upRowMainButton, upRowSecondButton,
             downRowMainButton, downRowSecondButton,
             displayView]
        for any in collection {
            guard let view = any as? UIView else { continue }
            view.layer.borderWidth = borderWidth
            view.layer.borderColor = #colorLiteral(red: 0, green: 0.4076067805, blue: 0.6132292151, alpha: 1)
        }

        displayView.layer.borderWidth = 10
        displayView.layer.borderColor = #colorLiteral(red: 0, green: 0.4076067805, blue: 0.6132292151, alpha: 1)
        
        imagePicker.delegate = self
        
        buttonsRegister()
        gestureRegisterSwipe()
        settingToFirstFrame()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        orientationSetSwipe()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        orientationSetSwipe()
    }
    
    // MARK: - Actions
    
    @IBAction func actionRequestedFirstSetting(_ sender: Any) {
        currentSetting = .isFirst
    }
    @IBAction func actionRequestedSecondSetting(_ sender: Any) {
        currentSetting = .isSecond
    }
    @IBAction func actionRequestedThirdSetting(_ sender: Any) {
        currentSetting = .isThird
    }
    
    // MARK: - Setting

    func settingDidChange() {
        settingResetAll()
        switch currentSetting {
        case .isFirst: settingToFirstFrame()
        case .isSecond: settingToSecondFrame()
        case .isThird: settingToThirdFrame()
        }
    }
    func settingResetAll() {
        let pics: [UIImageView?] =
            [firstPic, secondPic, thirdPic,
             upRowMainPic, upRowSecondPic,
             downRowMainPic, downRowSecondPic]
        for pic in pics { pic?.isHidden = true }
    }
    func settingToFirstFrame () {
        firstPic.isHidden = false
        firstPic.image = #imageLiteral(resourceName: "Selected")
        currentFrame = .isFirst
    }
    func settingToSecondFrame () {
        secondPic.isHidden = false
        secondPic.image = #imageLiteral(resourceName: "Selected")
        currentFrame = .isSecond
    }
    func settingToThirdFrame () {
        thirdPic.isHidden = false
        thirdPic.image = #imageLiteral(resourceName: "Selected")
        currentFrame = .isThird
    }
    
    // MARK: - Frame
    
    private func frameDidChange() {
        let views: [UIView?] =
            [upRowMainView, upRowSecondView,
             downRowMainView, downRowSecondView]
        var isHiddenValue = [Bool]()
        switch currentFrame {
        case .isFirst: isHiddenValue = [false, true, false, false]
        case .isSecond: isHiddenValue = [false, false, false, true]
        case .isThird: isHiddenValue = [false, false, false, false]
        }
        for index in 0...views.count - 1 {
            views[index]?.isHidden = isHiddenValue[index]
        }
    }
    
    // MARK: - Orientation
    
    func orientationSetSwipe() {
    if UIDevice.current.orientation.isLandscape {
            orientationToLandscape()
        } else {
            orientationToPortrait()
        }
    }
    func orientationToPortrait() {
        currentOrientation = .isPortrait
        (swipeArrow.text, swipeLabel.text) = ("<", "Swipe up to share")
        swipeArrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    }
    func orientationToLandscape() {
        currentOrientation = .isLandscape
        (swipeArrow.text, swipeLabel.text) = ("<", "Swipe left to share")
        swipeArrow.transform = CGAffineTransform(rotationAngle: 0)
    }
    
    // MARK: - Buttons
    
    func buttonsRegister() {
        for (button, tag) in [
            (upRowMainButton!, EnumTag.upMain ),
            (upRowSecondButton!, EnumTag.upSecond),
            (downRowMainButton!, EnumTag.downMain),
            (downRowSecondButton!, EnumTag.downSecond) ] {
            button.tag = tag.rawValue
            button.addTarget(
                self,
                action: #selector(buttonsRun(_:)),
                for: .touchUpInside)
        }
    }
    
    @objc private func buttonsRun(_ sender: UIButton) {
        let tagToPic: [Int: UIImageView] =
            [EnumTag.upMain.rawValue: upRowMainPic!,
             EnumTag.upSecond.rawValue: upRowSecondPic!,
             EnumTag.downMain.rawValue: downRowMainPic!,
             EnumTag.downSecond.rawValue: downRowSecondPic!]
        self.imageDesigner = tagToPic[sender.tag]!
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Gesture
    
    func gestureRegisterSwipe() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(gesturePerformSwipe))
        swipeUp.direction = .up ; view.addGestureRecognizer(swipeUp)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(gesturePerformSwipe))
        swipeLeft.direction = .left ; view.addGestureRecognizer(swipeLeft)
    }
    
    @objc private func gesturePerformSwipe(_ sender: UISwipeGestureRecognizer) {
        
        guard let displayView = self.displayView else { return }
        switch (currentOrientation, sender.state, sender.direction) {
        case (.isPortrait, .ended, .up):
            let translation = 0 - UIScreen.main.bounds.height
            gestureInPortraitWithAnimation(translation: translation)
        case (.isLandscape, .ended, .left):
            let translation = 0 + UIScreen.main.bounds.width
            gestureInLandscapeWithAnimation(translation: translation)
        default: return
        }
        
        let renderer = UIGraphicsImageRenderer(size: displayView.bounds.size)
        let renderedImage = renderer.image { _ in
            displayView.drawHierarchy(in: displayView.bounds, afterScreenUpdates: true)
        }
        
        self.activityViewController = UIActivityViewController(
            activityItems: [renderedImage],
            applicationActivities: nil)
    
        guard let avc = activityViewController else { return }
        avc.completionWithItemsHandler = { (
            activity: UIActivity.ActivityType?,
            completed: Bool,
            result: [Any]?,
            error: Error?) in
            
            UIView.animate(withDuration: 1) {
                if sender.direction == .up {
                    self.displayViewPortraitConstraint.constant = 0
                } else if sender.direction == .left {
                    self.displayViewLandscapeConstraint.constant = 0
                }
                self.activityViewController = nil
                self.view.layoutIfNeeded()
            }
        }
        present(avc, animated: true, completion: nil)
    }

    func gestureInPortraitWithAnimation(translation: CGFloat) {
        UIView.animate(withDuration: 1) {
            self.displayViewPortraitConstraint.constant = translation
            self.view.layoutIfNeeded()
        }
    }
    
    func gestureInLandscapeWithAnimation(translation: CGFloat) {
        UIView.animate(withDuration: 1) {
            self.displayViewLandscapeConstraint.constant = translation
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var imagePicked: UIImage?
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePicked = originalImage
            self.imageDesigner?.contentMode = .scaleAspectFill
            self.imageDesigner?.image = imagePicked
            self.imageDesigner?.isHidden = false
            dismiss(animated: true, completion: nil)
        }
    }
}

