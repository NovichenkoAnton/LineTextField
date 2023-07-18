//
//  LineTextField.swift
//  LineTextField
//
//  Created by Anton Novichenko on 3/30/20.
//  Copyright © 2020 Anton Novichenko. All rights reserved.
//

import UIKit

@objc public protocol LineTextFieldDelegate {
	/// Detect tap on trailing view
	/// - Parameter sender: `UIButton`
	func didTapTrailing(_ sender: UIButton, textField: LineTextField)
}

@IBDesignable public class LineTextField: UITextField {

	private lazy var floatedLabel: UILabel = UILabel(frame: .zero)

	private var underlineLayer = CALayer()

	private var colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
	private var frameAnimation = CABasicAnimation(keyPath: "frame.size.height")
    private var cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
	private var groupAnimation = CAAnimationGroup()

    /// Set animation when floating placeholder is redrawn.
    /// Default value is `true`.
    public var floatingPlaceholderShowWithAnimation: Bool = true
    
	// MARK: - IBInspectable

	/// Color for default state of the bottom line.
	/// Default value is `UIColor.white`.
	@IBInspectable public var lineColorDefault: UIColor = UIColor.white {
		didSet {
			underlineLayer.backgroundColor = lineColorDefault.cgColor
			setNeedsDisplay()
		}
	}

	/// Color for active state of the bottom line.
	/// Default value is `UIColor.black`.
	@IBInspectable public var lineColorActive: UIColor = UIColor.black
    
    /// Height for default state of the bottom line.
    /// Default value is `1`.
    @IBInspectable public var lineHeightDefault: CGFloat = 1 {
        didSet {
            underlineLayer.frame.size.height = lineHeightDefault
            underlineLayer.cornerRadius = max(lineHeightDefault / 2, 1)
            setNeedsDisplay()
        }
    }
    
    /// Height for active state of the bottom line.
    /// Default value is `2`.
    @IBInspectable public var lineHeightActive: CGFloat = 2

	/// Set up floated placeholder for `UITextField`
	/// Default value is `false`.
	@IBInspectable public var floatingPlaceholder: Bool = false {
		didSet {
			if floatingPlaceholder {
				configureFloatedPlaceholder()
			}
		}
	}

	/// Color for inactive state of floating placeholder.
	/// Default value is `UIColor.black`.
	@IBInspectable public var floatingPlaceholderColor: UIColor = UIColor.black {
		didSet {
			if floatingPlaceholder {
				floatedLabel.textColor = floatingPlaceholderColor
				setNeedsDisplay()
			}
		}
	}

	/// Color for active state of floating placeholder.
	/// Default value is `UIColor.black`.
	@IBInspectable public var floatingPlaceholderActiveColor: UIColor = UIColor.black
    
	/// Padding between text rect and floating label
	/// Default value is 0
	@IBInspectable public var floatingPadding: CGFloat = 0

	/// Image on the right side of `LineTextField`.
	@IBInspectable public var trailingImage: UIImage? {
		didSet {
			configureTrailingImage()
		}
	}

	@IBInspectable public var trailingTintColor: UIColor? {
		didSet {
			trailingButton.tintColor = trailingTintColor
			setNeedsDisplay()
		}
	}

	/// Right padding for trailing image.
	/// Default value is 0.
	@IBInspectable public var trailingPadding: CGFloat = 0

	@IBOutlet public weak var lineDelegate: LineTextFieldDelegate?

	// MARK: - Private properties

	private lazy var trailingButton: UIButton = {
		let trailingButton = UIButton(type: .system)
		trailingButton.tintColor = trailingTintColor
		trailingButton.addTarget(self, action: #selector(trailingButtonTap(_:)), for: .touchUpInside)
		return trailingButton
	}()

	// MARK: - Overridden properties

	public override var placeholder: String? {
		didSet {
			floatedLabel.text = placeholder
		}
	}

	// MARK: - Inits

	public override init(frame: CGRect) {
		super.init(frame: frame)

		initLineTextField()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)

		initLineTextField()
	}

	private func initLineTextField() {
		self.borderStyle = .none

		configureUnderline()

		if floatingPlaceholder {
			configureFloatedPlaceholder()
		}

		addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
		addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
	}

	private func configureUnderline() {
		underlineLayer.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: 1)
		underlineLayer.backgroundColor = lineColorDefault.cgColor
		underlineLayer.cornerRadius = 1

		layer.addSublayer(underlineLayer)
	}

	private func configureFloatedPlaceholder() {
		floatedLabel.alpha = 1
		floatedLabel.textColor = UIColor.black
		floatedLabel.font = labelFont()
		floatedLabel.text = self.placeholder
		floatedLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]

		addSubview(floatedLabel)
		bringSubviewToFront(floatedLabel)
	}

	private func configureTrailingImage() {
		rightView = nil
		rightViewMode = .never

		guard let image = trailingImage else { return }

		let originalImage = image.withRenderingMode(.alwaysTemplate)
		trailingButton.setImage(originalImage, for: .normal)
		trailingButton.tintColor = trailingTintColor

		rightViewMode = .always
		rightView = trailingButton
	}

	// MARK: - Overriden functions
	public override func layoutSubviews() {
		super.layoutSubviews()

		underlineLayer.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: underlineLayer.frame.height)

		if floatingPlaceholder {
			floatedLabel.frame = floatedLabelRect()

            updateFloatedLabelColor(editing: (hasText && isFirstResponder), animated: floatingPlaceholderShowWithAnimation)
			updateFloatedLabel(animated: hasText)
		}

		if trailingImage != nil {
			trailingButton.frame = CGRect(x: bounds.width - (bounds.height * 0.8 + trailingPadding), y: (bounds.height - bounds.height * 0.8)/2, width: bounds.height * 0.8, height: bounds.height * 0.8)
		}
	}

	public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
		var rect = super.rightViewRect(forBounds: bounds)
		rect.origin.x -= trailingPadding
		return rect
	}

	public override func editingRect(forBounds bounds: CGRect) -> CGRect {
		var rect = super.editingRect(forBounds: bounds)
		if trailingImage != nil {
			rect.size.width -= (bounds.height * 0.8 - trailingPadding)
		}

		return rect
	}

	public override func textRect(forBounds bounds: CGRect) -> CGRect {
		var rect = super.textRect(forBounds: bounds)
		if trailingImage != nil {
			rect.size.width -= (bounds.height * 0.8 - trailingPadding)
		}
		return rect
	}

	// MARK: - Events
	@objc func editingDidBegin() {
		activateBottomLine()
	}

	@objc func editingDidEnd() {
		diactivateBottomLine()
	}

	@objc func trailingButtonTap(_ sender: UIButton) {
		lineDelegate?.didTapTrailing(sender, textField: self)
	}
}

// MARK: - Helpers
private extension LineTextField {
	/// Get font `UIFont` font for floated label
	/// - Returns: Correct `UIFont`
	func labelFont() -> UIFont {
		var currentFont = UIFont.systemFont(ofSize: 17.0)

		if let attributedText = self.attributedText, attributedText.length > 0 {
			currentFont = attributedText.attribute(.font, at: 0, effectiveRange: nil) as! UIFont
		}

		if let font = self.font {
			currentFont = font
		}

		return currentFont.withSize((currentFont.pointSize * 0.7).rounded())
	}

	/// Floated label height adjustemnt
	/// - Returns: Adjustment height
	func floatedLabelHeight() -> CGFloat {
		labelFont().lineHeight + 4.0
	}

	func updateFloatedLabel(animated: Bool = false) {
		updateFloatedLabelVisibility(animated: animated)
	}

	/// Get correct frame of floated label
	/// - Returns: Frame of floated label
	func floatedLabelRect() -> CGRect {
		let labelHeight = floatedLabelHeight()

		if hasText {
			return CGRect(x: 0, y: -9 - floatingPadding, width: bounds.size.width, height: labelHeight)
		}

		return CGRect(x: 0, y: bounds.origin.y, width: bounds.size.width, height: labelHeight)
	}

	/// Update alpha and frame of floated label
	/// - Parameter animated: with animation or not
	func updateFloatedLabelVisibility(animated: Bool) {
		let alpha: CGFloat = hasText ? 1.0 : 0.0
		let frame = floatedLabelRect()
		let animationBlock = { () -> Void in
			self.floatedLabel.frame = frame
			self.floatedLabel.alpha = alpha
		}

		if animated {
			UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: animationBlock, completion: nil)
		} else {
			animationBlock()
		}
	}

	/// Update text color of floated label
	/// - Parameter editing: `true` if `UITextField` is editing now
	func updateFloatedLabelColor(editing: Bool, animated: Bool) {
		let animationBlock = { () -> Void in
			if editing && self.hasText {
				self.floatedLabel.textColor = self.floatingPlaceholderActiveColor
			} else {
				self.floatedLabel.textColor = self.floatingPlaceholderColor
			}
		}

		if animated {
			UIView.transition(with: floatedLabel, duration: 0.2, options: .transitionCrossDissolve, animations: animationBlock, completion: nil)
		} else {
			animationBlock()
		}
	}
}

// MARK: - Animation
private extension LineTextField {
	func activateBottomLine() {
		colorAnimation.fromValue = underlineLayer.backgroundColor
		colorAnimation.toValue = lineColorActive.cgColor
		colorAnimation.duration = 0.1

		frameAnimation.fromValue = lineHeightDefault
		frameAnimation.toValue = lineHeightActive
		frameAnimation.duration = 0.1
        
        cornerRadiusAnimation.fromValue = underlineLayer.cornerRadius
        cornerRadiusAnimation.toValue = lineHeightActive / 2
        cornerRadiusAnimation.duration = 0.1

		groupAnimation.animations = [colorAnimation, frameAnimation, cornerRadiusAnimation]
		groupAnimation.duration = 0.3
		groupAnimation.isRemovedOnCompletion = true

		underlineLayer.add(groupAnimation, forKey: "groupAnimation")

		underlineLayer.backgroundColor = lineColorActive.cgColor
		underlineLayer.frame.size.height = lineHeightActive
        underlineLayer.cornerRadius = lineHeightActive / 2
	}

	func diactivateBottomLine() {
		colorAnimation.fromValue = underlineLayer.backgroundColor
		colorAnimation.toValue = lineColorDefault.cgColor
		colorAnimation.duration = 0.1

		frameAnimation.fromValue = lineHeightActive
		frameAnimation.toValue = lineHeightDefault
		frameAnimation.duration = 0.1
        
        cornerRadiusAnimation.fromValue = underlineLayer.cornerRadius
        cornerRadiusAnimation.toValue = max(lineHeightDefault / 2, 1)
        cornerRadiusAnimation.duration = 0.1

		groupAnimation.animations = [colorAnimation, frameAnimation, cornerRadiusAnimation]
		groupAnimation.duration = 0.3
		groupAnimation.isRemovedOnCompletion = true

		underlineLayer.add(groupAnimation, forKey: "groupAnimation")

		underlineLayer.backgroundColor = lineColorDefault.cgColor
		underlineLayer.frame.size.height = lineHeightDefault
        underlineLayer.cornerRadius = max(lineHeightDefault / 2, 1)
	}
}
