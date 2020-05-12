//
//  ViewController.swift
//  LineTextFieldExample
//
//  Created by Anton Novichenko on 3/30/20.
//  Copyright © 2020 Anton Novichenko. All rights reserved.
//

import UIKit
import LineTextField

final class ViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet var textField: LineTextField!
	@IBOutlet var textFieldHeight: NSLayoutConstraint!

	private var lineTextField: LineTextField!

	override func viewDidLoad() {
		super.viewDidLoad()

//		lineTextField = LineTextField(frame: CGRect(x: 20, y: 400, width: view.frame.width - 40, height: 35))
//		lineTextField.placeholder = "Manual placeholder"
//		lineTextField.floatingPlaceholder = true
//		lineTextField.floatingPlaceholderColor = .blue
//		lineTextField.floatingPlaceholderActiveColor = .black
//		view.addSubview(lineTextField)
	}

	// MARK: - Events

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}

	@IBAction func showTextField(_ sender: UISwitch) {
		updateVisibility(show: sender.isOn)
	}
}

private extension ViewController {
	func updateVisibility(show: Bool) {
		let alpha: CGFloat = show ? 1.0 : 0.0
		textFieldHeight.constant = show ? 35 : 0

		let animationBlock = { () -> Void in
			self.textField.alpha = alpha

			self.view.layoutIfNeeded()
		}

		UIView.animate(withDuration: 0.25, animations: animationBlock)
	}
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		print("begin editing")
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		print("end editing")
	}
}

// MARK: - LineTextFieldDelegate
extension ViewController: LineTextFieldDelegate {
	func didTapTrailing(_ sender: UIButton, textField: LineTextField) {
		print("tap")
	}
}

