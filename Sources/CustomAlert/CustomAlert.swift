//
//  CustomAlert.swift
//  PointsDaily
//
//  Created by Moses Harding on 1/13/21.
//  Copyright © 2021 com.moses.harding. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) {
        self.init(red: red / 256, green: green / 256, blue: blue / 256, alpha: alpha)
    }
}

extension UIView {
    func addTopBorder(color: UIColor = UIColor.white, borderWidth: CGFloat = 1.0) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }
    
    func addBottomBorder(color: UIColor = UIColor.white, borderWidth: CGFloat = 1.0) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }
    
    func addLeftBorder(color: UIColor = UIColor.white, borderWidth: CGFloat = 1.0) {
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        addSubview(border)
    }
    
    func addRightBorder(color: UIColor = UIColor.white, borderWidth: CGFloat = 1.0) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        addSubview(border)
    }
}


public class CustomAlert: UIView {
    
    //Parent
    weak var parentView: UIView!
    weak var parentViewController: UIViewController!
    
    //Colors
    public var obscuredBackgroundColor = UIColor(0, 0, 0, 0.5)
    public var borderColor = UIColor.white
    public var textColor = UIColor.white
    public var alertBodyBackgroundColor = UIColor(0, 0, 0, 0.95)
    public var okayButtonColor = UIColor.white
    public var cancelButtonColor = UIColor.white
    
    //Borderwidth
    public var borderWidth: CGFloat = 0.25
    
    //Alert View
    var alertBody: UIStackView!
    
    //Title Label
    var hasTitle = false
    var titleLabelView = UIView()
    public var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Title Label"

        label.font = UIFont.systemFont(ofSize: 50)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    var titleHeightMultiplier: CGFloat = 0.075
    
    //Message Label
    var textBodyView = UIView()
    var textBodyStack = UIStackView()
    
    var messageFontSize: CGFloat!
    public var messageLabel: UILabel = {
        let label = UILabel()

        label.text = "Message Label"
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return label
    }()
    
    //Button Stack
    var buttonStack = UIStackView()
    var buttonHeightMultiplier: CGFloat = 0.075
    
    //Okay
    public var okayButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("OK", for: .normal)
        
        return button
    }()
    var customOkayTest = "OK"
    
    //Cancel
    public var cancelButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Cancel", for: .normal)
        
        return button
    }()
    var customCancelText = "Cancel"
    var cancelAction: (() -> ())?
    
    //Constraints
    var centerYConstraint: NSLayoutConstraint?
    var centerXConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    public init(parentViewController: UIViewController, title: String? = nil, message: String, messageFontSize: CGFloat = 16) {
        
        super.init(frame: CGRect.zero)
        
        //Set Properties
        self.parentViewController = parentViewController
        self.parentView = parentViewController.view
        self.messageLabel.text = message
        self.messageFontSize = messageFontSize
        
        if let titleText = title {
            hasTitle = true
            titleLabel.text = titleText
        } else {
            titleHeightMultiplier = 0
        }
        
        setFont(for: messageLabel, fontSize: messageFontSize)

        //Constrain
        parentView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        let viewConstraints = ([
            self.widthAnchor.constraint(equalTo: parentView.widthAnchor),
            self.heightAnchor.constraint(equalTo: parentView.heightAnchor),
            self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: parentView.centerYAnchor)
        ])
        NSLayoutConstraint.activate(viewConstraints)
        
        //Background color
        self.backgroundColor = obscuredBackgroundColor
        
        addBackground()
    }
    
    func addBackground() {

        var colorList = [UIColor.blue.cgColor, UIColor.cyan.cgColor]
        
        let gradient = CAGradientLayer()
        
        gradient.frame = alertBody.bounds
        gradient.colors = colorList

        
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        
        gradient.zPosition = -1
        
        self.alertBody.layer.addSublayer(gradient)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: Layout views
    
    func layoutViews() {
        //To be overridden
    }
    
    func setUpAlertBody() {
        
        if alertBody != nil {
            alertBody.removeFromSuperview()
        }
        
        alertBody = UIStackView()

        //Make constraints
        self.addSubview(alertBody)
        alertBody.translatesAutoresizingMaskIntoConstraints = false
        widthConstraint = alertBody.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9)
        centerXConstraint = alertBody.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        centerYConstraint = alertBody.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        adjustFit()
        
        //Activate Constraints
        heightConstraint?.isActive = true
        widthConstraint?.isActive = true
        centerXConstraint?.isActive = true
        centerYConstraint?.isActive = true
        
        //View properties
        alertBody.axis = .vertical
        alertBody.backgroundColor = alertBodyBackgroundColor
        alertBody.layer.cornerRadius = 20
        
        //Blur
        let layer = alertBody.layer
        layer.shadowColor = alertBodyBackgroundColor.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 20
    }
    
    func setUpTitleLabelView() {
        
        if !hasTitle { return }
        
        alertBody.addArrangedSubview(titleLabelView)
        
        //Label Contraints
        titleLabelView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: titleLabelView.leadingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: titleLabelView.trailingAnchor, constant: -25).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: titleLabelView.heightAnchor).isActive = true
        
        //View properties
        titleLabelView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: titleHeightMultiplier).isActive = true
        titleLabelView.addBottomBorder(color: borderColor, borderWidth: borderWidth)
        
        //Label Properties
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.2
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        titleLabel.textColor = textColor
    }
    
    func setUpButtonStack() {
        
        alertBody.addArrangedSubview(buttonStack)
        buttonStack.addTopBorder(color: borderColor, borderWidth: borderWidth)
        
        buttonStack.addArrangedSubview(okayButton)
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.distribution = .fillEqually
        
        okayButton.addRightBorder(color: borderColor, borderWidth: borderWidth)
        okayButton.setTitleColor(okayButtonColor, for: .normal)
        cancelButton.setTitleColor(cancelButtonColor, for: .normal)
        
        buttonStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeightMultiplier).isActive = true
    }
    
    //MARK: Adjustment
    func adjustFit() {
        
        let scaledSize = CGFloat(messageLabel.text!.count)  * 0.0017
        var heightMultiplier: CGFloat = 0.25
        
        if scaledSize < 0.7 && scaledSize > 0.25 {
            heightMultiplier = scaledSize
        } else if scaledSize > 0.5 {
            heightMultiplier = 0.5
        }
        
        heightConstraint?.isActive = false
        heightConstraint = alertBody.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: heightMultiplier)
        heightConstraint?.isActive = true
    }
    
    public func setFont(for label: UILabel, fontSize: CGFloat, fontName: String = "EuphemiaUCAS") {
        
        guard let customFont = UIFont(name: fontName, size: fontSize) else { fatalError("Font not loaded")}
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
        label.adjustsFontForContentSizeCategory = true
        label.lineBreakStrategy = .standard
    }
    
    //MARK: Setters
    public func setTitle(to title: String?, font: UIFont? = nil) {
        
        if title != nil {
            titleLabel.text = title
            hasTitle = true
        } else {
            titleLabel.text = ""
            hasTitle = false
        }
        if font != nil { titleLabel.font = font }
        
        layoutViews()
    }
    
    public func setMessage(to message: String, font: UIFont? = nil) {
        
        messageLabel.text = message
        
        if font != nil {
            messageLabel.font = font
            messageFontSize = font?.pointSize
        }
        
        layoutViews()
    }
    
    public func setCustomOkayText(to text: String, fontColor: UIColor? = nil) {

        okayButton.setTitle(text, for: .normal)
        okayButtonColor = fontColor ?? okayButtonColor
        
        layoutViews()
    }
    
    public func setCustomCancelText(to text: String, fontColor: UIColor? = nil) {
        
        cancelButton.setTitle(text, for: .normal)
        cancelButtonColor = fontColor ?? cancelButtonColor
        
        layoutViews()
    }
}

//MARK: Simple Alert
public class SimpleAlert: CustomAlert {
    
    public var okayAction: (() -> ())?
    
    public init(parentViewController: UIViewController, title: String? = nil, message: String, messageFontSize: CGFloat = 16, okayAction: (() -> ())? = nil, cancelAction: (() -> ())? = nil) {
        
        //Map Properties
        super.init(parentViewController: parentViewController, title: title, message: message, messageFontSize: messageFontSize)
        self.okayAction = okayAction
        self.cancelAction = cancelAction
        
        okayButton.addTarget(self, action: #selector(okayPressed), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        
        layoutViews()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutViews() {

        setUpAlertBody()
        setUpTitleLabelView()
        setUpTextBodyView()
        setUpButtonStack()
    }
    
    func setUpTextBodyView() {

        alertBody.addArrangedSubview(textBodyView)
        
        //Label Constraints
        textBodyView.addSubview(textBodyStack)
        textBodyStack.translatesAutoresizingMaskIntoConstraints = false
        textBodyStack.leadingAnchor.constraint(equalTo: textBodyView.leadingAnchor, constant: 15).isActive = true
        textBodyStack.trailingAnchor.constraint(equalTo: textBodyView.trailingAnchor, constant: -15).isActive = true
        textBodyStack.topAnchor.constraint(equalTo: textBodyView.topAnchor, constant: 10).isActive = true
        textBodyStack.bottomAnchor.constraint(equalTo: textBodyView.bottomAnchor, constant: -10).isActive = true

        textBodyStack.addArrangedSubview(messageLabel)
        
        textBodyStack.axis = .vertical
        textBodyStack.spacing = 5
        
        //Label properties
        messageLabel.minimumScaleFactor = 0.1
        messageLabel.numberOfLines = 0
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.textColor = textColor
    }
    
    @objc func okayPressed(_ sender: Any) {

        if let okayAction = okayAction {
            okayAction()
        }
        
        UIView.animate(withDuration: 0.5, animations: { [self] in
            self.layoutIfNeeded()
            self.alpha = 0
        }) { (true) in
            self.removeFromSuperview()
        }
    }
    
    @objc func cancelPressed(_ sender: Any) {

        centerYConstraint?.isActive = false
        alertBody.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        if let cancel = cancelAction { cancel() }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
            self.alpha = 0
        }) { (true) in
            self.removeFromSuperview()
        }
    }
}

public class TextInputAlert: CustomAlert {
    
    //Color
    public var textInputFieldColor = UIColor.white
    public var textInputFieldTextColor = UIColor.black
    public var validationColor = UIColor.red
    
    //Keyboard Height
    var keyboardHeight: CGFloat?
    var observer: NSObjectProtocol!
    
    //Bools
    var wasValidatedOnce = false

    //Validation
    public var validationLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    var validationFontSize: CGFloat!
    
    public var validationAction: ((String) -> (Bool))?
    public var validationMessage: ((String) -> (String?))?
    
    //Spacer
    var spacer = UIView()
    var spacerHeightMultiplier: CGFloat = 0.05
    
    //Text Input
    var textInputFieldView = UIView()
    public var textInputField = UITextField()
    var textInputHeightMultiplier: CGFloat = 0.05
    
    //Okay action
    public var okayAction: ((String) -> ())?
    
    //Constraints
    var messageHeightConstraint: NSLayoutConstraint?
    var validationHeightConstraint: NSLayoutConstraint?
    
    //MARK: Initialization
    
    public init(parentViewController: UIViewController, title: String? = nil, message: String, messageFontSize: CGFloat = 16, validationFontSize: CGFloat = 14, okayAction: ((String) -> ())? = nil, cancelAction: (() -> ())? = nil, validationAction: ((String) -> (Bool))? = nil, validationMessage: ((String) -> (String?))? = nil) {
        
        super.init(parentViewController: parentViewController, title: title, message: message, messageFontSize: messageFontSize)

        //Set Optionals
        self.validationFontSize = validationFontSize
        self.validationAction = validationAction
        self.validationMessage = validationMessage
        self.okayAction = okayAction
        self.cancelAction = cancelAction
        
        //Add actions to buttons
        okayButton.addTarget(self, action: #selector(okayPressed), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        
        //Set default font for validation label
        setFont(for: validationLabel, fontSize: validationFontSize)

        //Register for notifications to get keyboard size
        self.observer = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil, using: { self.keyboardWillShow($0) })
        
        //Lay out body
        layoutViews()
        layoutIfNeeded()

        //Trigger keyboard to appear
        textInputField.becomeFirstResponder()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: Layout
    override func layoutViews() {
        
        setUpAlertBody()
        setUpTitleLabelView()
        setUpTextBodyView()
        setUpTextInputFieldView()
        setUpSpacer()
        setUpButtonStack()
    }
    
    func setUpTextBodyView() {
        
        alertBody.addArrangedSubview(textBodyView)
        
        //Constrain stack to the view (included for spacing)
        textBodyView.addSubview(textBodyStack)
        textBodyStack.translatesAutoresizingMaskIntoConstraints = false
        textBodyStack.leadingAnchor.constraint(equalTo: textBodyView.leadingAnchor, constant: 15).isActive = true
        textBodyStack.trailingAnchor.constraint(equalTo: textBodyView.trailingAnchor, constant: -15).isActive = true
        textBodyStack.topAnchor.constraint(equalTo: textBodyView.topAnchor, constant: 10).isActive = true
        textBodyStack.bottomAnchor.constraint(equalTo: textBodyView.bottomAnchor, constant: -10).isActive = true

        //Add labels to bodystack
        textBodyStack.addArrangedSubview(messageLabel)
        textBodyStack.addArrangedSubview(validationLabel)
        
        //Format bodystack
        textBodyStack.axis = .vertical
        textBodyStack.distribution = .fill
        
        //Format labels
        messageLabel.minimumScaleFactor = 0.2
        messageLabel.numberOfLines = 0
        messageLabel.textColor = textColor
        
        validationLabel.minimumScaleFactor = 0.2
        validationLabel.numberOfLines = 0
        validationLabel.textColor = validationColor
    }
    
    func setUpSpacer() {
        
        alertBody.addArrangedSubview(spacer)

        spacer.heightAnchor.constraint(equalTo: alertBody.heightAnchor, multiplier: spacerHeightMultiplier).isActive = true
    }
    
    func setUpTextInputFieldView() {
        
        alertBody.addArrangedSubview(textInputFieldView)

        //Field constraints
        textInputFieldView.addSubview(textInputField)
        textInputField.translatesAutoresizingMaskIntoConstraints = false
        textInputField.leadingAnchor.constraint(equalTo: textInputFieldView.leadingAnchor, constant: 15).isActive = true
        textInputField.trailingAnchor.constraint(equalTo: textInputFieldView.trailingAnchor, constant: -15).isActive = true
        textInputField.heightAnchor.constraint(equalTo: textInputFieldView.heightAnchor).isActive = true
        
        //View properties
        textInputFieldView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: textInputHeightMultiplier).isActive = true
        
        //Field properties
        textInputField.borderStyle = .line
        textInputField.layer.borderWidth = borderWidth
        textInputField.layer.borderColor = borderColor.cgColor
        textInputField.backgroundColor =  textInputFieldColor
        textInputField.textColor = textInputFieldTextColor
        textInputField.delegate = self
    }
    
    //MARK: Setter
    
    public func setValidation(action: @escaping ((String) -> (Bool)), message: @escaping ((String) -> (String?))) {
        
        validationAction = action
        validationMessage = message
        
        adjustFit()
    }
    
    
    //MARK: Adjustment
    
    override func adjustFit() {
        
        guard let height = keyboardHeight else { return }
        
        let guide = parentView.safeAreaLayoutGuide
        let guideHeightDifference = (parentView.frame.height - guide.layoutFrame.size.height) / 2
        let openSpace = parentView.frame.height - height - guideHeightDifference
        
        let baseHeightMultiplier = titleHeightMultiplier + textInputHeightMultiplier + spacerHeightMultiplier + buttonHeightMultiplier
        
        let scaledHeight: CGFloat = (parentView.frame.height * baseHeightMultiplier) + validationLabel.intrinsicContentSize.height.rounded() + messageLabel.intrinsicContentSize.height.rounded() + 20
        let heightConstant = scaledHeight > openSpace ? openSpace : scaledHeight
        
        heightConstraint?.isActive = false

        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        })
        
        heightConstraint = alertBody.heightAnchor.constraint(equalToConstant: heightConstant)
        heightConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        })
    }
    
    func adjustForValidation() {
        
        guard let height = keyboardHeight else { return }

        let guide = parentView.safeAreaLayoutGuide
        let guideHeightDifference = (parentView.frame.height - guide.layoutFrame.size.height) / 2
        let openSpace = parentView.frame.height - height - guideHeightDifference
        
        let baseHeightMultiplier = titleHeightMultiplier + textInputHeightMultiplier + spacerHeightMultiplier + buttonHeightMultiplier
        
        let scaledHeight: CGFloat = (parentView.frame.height * baseHeightMultiplier) + validationLabel.intrinsicContentSize.height.rounded() + messageLabel.intrinsicContentSize.height.rounded() + 20
        let heightConstant = scaledHeight > openSpace ? openSpace : scaledHeight
        
        heightConstraint?.isActive = false
        validationLabel.sizeToFit()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        })
        
        heightConstraint = alertBody.heightAnchor.constraint(equalToConstant: heightConstant)
        heightConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        })
    }
    
    func adjustLayoutAfterKeyboardIsShown() {
        
        let guide = parentView.safeAreaLayoutGuide
        let guideHeightDifference = (parentView.frame.height - guide.layoutFrame.size.height) / 4
        let openArea = parentView.frame.height - keyboardHeight! + guideHeightDifference
        let centerOfOpenArea = (openArea / 2)

        centerYConstraint?.isActive = false
        layoutIfNeeded()
        
        centerYConstraint = alertBody.centerYAnchor.constraint(equalTo: self.topAnchor, constant: centerOfOpenArea)
        centerYConstraint?.isActive = true
        
        adjustFit()
    }
    
    //MARK: OBJC Actions
    
    @objc func okayPressed(_ sender: Any) {

        let disappear = {
            UIView.animate(withDuration: 0.5, animations: { [self] in
                self.textInputField.resignFirstResponder()
                self.layoutIfNeeded()
                self.alpha = 0
            }) { (true) in
                NotificationCenter.default.removeObserver(self.observer!)
                self.removeFromSuperview()
            }
        }
        
        guard let text = textInputField.text else { return }

        if let action = validationAction {
            if action(text) {
                if let action = okayAction {
                    action(text)
                }
                disappear()
            } else {
                guard let message = validationMessage, let messageText = message(text) else { return }
                validationLabel.text = messageText
                wasValidatedOnce = true
                
                adjustForValidation()
            }
        } else {
            if let action = okayAction  {
                action(text)
            }
            disappear()
        }
    }
    
    @objc func cancelPressed(_ sender: Any) {
        
        self.textInputField.resignFirstResponder()

        centerYConstraint?.isActive = false
        alertBody.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        if let cancel = cancelAction { cancel() }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
            self.alpha = 0
        }) { (true) in
            NotificationCenter.default.removeObserver(self.observer!)
            self.removeFromSuperview()
        }
    }
    
    func keyboardWillShow(_ notification: Notification) {

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
        }
        
        adjustLayoutAfterKeyboardIsShown()
    }
}

extension TextInputAlert: UITextFieldDelegate {
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        
        guard let action = validationAction else { return }
        guard let message = validationMessage else { return }
        guard let text = textField.text else { return }
        
        if wasValidatedOnce {
            if !action(text) && message(text) != nil {
                validationLabel.text = message(text) ?? ""
            } else {
                validationLabel.text = nil
            }
            adjustForValidation()
        }
    }
}
