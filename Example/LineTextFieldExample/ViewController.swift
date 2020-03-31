//
//  ViewController.swift
//  LineTextFieldExample
//
//  Created by Anton Novichenko on 3/30/20.
//  Copyright © 2020 Anton Novichenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
}

