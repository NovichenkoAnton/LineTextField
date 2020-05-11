//
//  LineTextField.swift
//  LineTextField
//
//  Created by Anton Novichenko on 3/30/20.
//  Copyright © 2020 Anton Novichenko. All rights reserved.
//

import UIKit

public class LineTextField: UITextField {

	private lazy var floatedLabel: UILabel = UILabel(frame: .zero)

	private var underlineLayer = CALayer()

	private var colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
	private var frameAnimation = CABasicAnimation(keyPath: "frame.size.height")
	private var groupAnimation = CAAnimationGroup()

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

	/// Image on the right side of `LineTextField`.
	@IBInspectable public var trailingImage: UIImage? {
		didSet {
			configureTrailingImage()
		}
	}

	/// Right padding for trailing image.
	/// Default value is 0.
	@IBInspectable public var trailingPadding: CGFloat = 0

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

		let trailingButton = UIButton(type: .custom)
		trailingButton.frame = CGRect(x: 0, y: 0, width: bounds.height * 0.8, height: bounds.height * 0.8)

		let originalImage = image.withRenderingMode(.alwaysOriginal)
		trailingButton.setImage(originalImage, for: .normal)

		rightViewMode = .always
		rightView = trailingButton
	}

	// MARK: - Overriden functions
	public override func layoutSubviews() {
		super.layoutSubviews()

		underlineLayer.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: underlineLayer.frame.height)

		if floatingPlaceholder {
			floatedLabel.frame = floatedLabelRect()

			updateFloatedLabelColor(editing: (hasText && isFirstResponder))
			updateFloatedLabel(animated: hasText)
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
			return CGRect(x: 0, y: -9, width: bounds.size.width, height: labelHeight)
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
	func updateFloatedLabelColor(editing: Bool, animated: Bool = true) {
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

		frameAnimation.fromValue = underlineLayer.frame.size.height
		frameAnimation.toValue = underlineLayer.frame.size.height + 1
		frameAnimation.duration = 0.1

		groupAnimation.animations = [colorAnimation, frameAnimation]
		groupAnimation.duration = 0.2
		groupAnimation.isRemovedOnCompletion = true

		underlineLayer.add(groupAnimation, forKey: "groupAnimation")

		underlineLayer.backgroundColor = lineColorActive.cgColor
		underlineLayer.frame.size.height += 1
	}

	func diactivateBottomLine() {
		colorAnimation.fromValue = underlineLayer.backgroundColor
		colorAnimation.toValue = lineColorDefault.cgColor
		colorAnimation.duration = 0.1

		frameAnimation.fromValue = underlineLayer.frame.size.height
		frameAnimation.toValue = underlineLayer.frame.size.height - 1
		frameAnimation.duration = 0.1

		groupAnimation.animations = [colorAnimation, frameAnimation]
		groupAnimation.duration = 0.2
		groupAnimation.isRemovedOnCompletion = true

		underlineLayer.add(groupAnimation, forKey: "groupAnimation")

		underlineLayer.backgroundColor = lineColorDefault.cgColor
		underlineLayer.frame.size.height -= 1
	}
}
