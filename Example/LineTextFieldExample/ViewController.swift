//
//  ViewController.swift
//  LineTextFieldExample
//
//  Created by Anton Novichenko on 3/30/20.
//  Copyright © 2020 Anton Novichenko. All rights reserved.
//

import UIKit
import LineTextField

class ViewController: UIViewController {

	private var lineTextField: LineTextField!

	override func viewDidLoad() {
		super.viewDidLoad()

		lineTextField = LineTextField(frame: CGRect(x: 20, y: 400, width: view.frame.width - 40, height: 35))
		lineTextField.placeholder = "Manual placeholder"
		lineTextField.floatingPlaceholder = true
		lineTextField.floatingLabelColor = .blue
		lineTextField.floatingLabelActiveColor = .black
		view.addSubview(lineTextField)
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
}

extension ViewController: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		print("begin editing")
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		print("end editing")
	}
}

