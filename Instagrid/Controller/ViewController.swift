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
    
    // MARK: Properties
    
    let borderWidth: CGFloat = 5.0
    
    let imagePicker = UIImagePickerController()
    var imageDesigner: UIImageView?
    
    var activityViewController: UIActivityViewController?
    
    enum Orientation { case isUndefined, isPortrait, isLandscape }
    enum Setting { case first, second, third }
    enum Frame { case first, second, third }
    enum Tag: Int { case upMain, upSecond, downMain, downSecond }

    var currentOrientation: Orientation = .isUndefined
    var currentSetting: Setting = .first {
        didSet { didSetCurrentSetting() }
    }
    var currentFrame: Frame = .first {
        didSet { didSetCurrentFrame() }
    }
    
    // MARK: Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collection: [Any?] =
            [upRowMainButton, upRowSecondButton,
             downRowMainButton, downRowSecondButton,
             displayView]
        for any in collection {
            guard let view = any as? UIView else { fatalError() }
            view.layer.borderWidth = borderWidth
            view.layer.borderColor = #colorLiteral(red: 0, green: 0.4076067805, blue: 0.6132292151, alpha: 1)
        }
        
        displayView.layer.borderWidth = 10
        displayView.layer.borderColor = #colorLiteral(red: 0, green: 0.4076067805, blue: 0.6132292151, alpha: 1)
        
        imagePicker.delegate = self
        
        addSwipeGesture()
        registerPicButtons()
        _firstSetting()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setSwipeOrientation()
        
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
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
        guard views.count == isHiddenValue.count else { fatalError() }
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
        let pics: [UIImageView?] =
            [firstPic, secondPic, thirdPic,
             upRowMainPic, upRowSecondPic,
             downRowMainPic, downRowSecondPic]
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
    
    // MARK: - Orientation functions
    
    func setSwipeOrientation() {
    if UIDevice.current.orientation.isLandscape {
            _setLandscape()
        } else {
            _setPortrait()
        }
    }
    private func _setPortrait() {
        currentOrientation = .isPortrait
        (swipeArrow.text, swipeLabel.text) = ("<", "Swipe up to share")
        swipeArrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    }
    private func _setLandscape() {
        currentOrientation = .isLandscape
        (swipeArrow.text, swipeLabel.text) = ("<", "Swipe left to share")
        swipeArrow.transform = CGAffineTransform(rotationAngle: 0)
    }
    
    // MARK: - Pic functions
    
    func registerPicButtons() {
        for (button, tag) in [
            (upRowMainButton!, Tag.upMain ),
            (upRowSecondButton!, Tag.upSecond),
            (downRowMainButton!, Tag.downMain),
            (downRowSecondButton!, Tag.downSecond) ] {
            button.tag = tag.rawValue
            button.addTarget(
                self,
                action: #selector(runPicButtons(_:)),
                for: .touchUpInside)
        }
    }
    
    @objc private func runPicButtons(_ sender: UIButton) {
        let tagToPic: [Int: UIImageView] =
            [Tag.upMain.rawValue: upRowMainPic!,
             Tag.upSecond.rawValue: upRowSecondPic!,
             Tag.downMain.rawValue: downRowMainPic!,
             Tag.downSecond.rawValue: downRowSecondPic!]
        self.imageDesigner = tagToPic[sender.tag]!
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Gesture functions
    
    func addSwipeGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(performSwipe))
        swipeUp.direction = .up ; view.addGestureRecognizer(swipeUp)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(performSwipe))
        swipeLeft.direction = .left ; view.addGestureRecognizer(swipeLeft)
    }
     
    func doSwipeAnimationInPortrait(translation: CGFloat) {
        UIView.animate(withDuration: 1) {
            self.displayViewPortraitConstraint.constant = translation
            self.view.layoutIfNeeded()
        }
    }
    
    func doSwipeAnimationInLandscape(translation: CGFloat) {
        UIView.animate(withDuration: 1) {
            self.displayViewLandscapeConstraint.constant = translation
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func performSwipe(_ sender: UISwipeGestureRecognizer) {
        
        guard let displayView = self.displayView else { return }
        switch (currentOrientation, sender.state, sender.direction) {
        case (.isPortrait, .ended, .up):
            let translation = 0 - UIScreen.main.bounds.height
            doSwipeAnimationInPortrait(translation: translation)
        case (.isLandscape, .ended, .left):
            let translation = 0 + UIScreen.main.bounds.width
            doSwipeAnimationInLandscape(translation: translation)
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

