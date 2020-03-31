//
//  LineTextField.swift
//  LineTextField
//
//  Created by Anton Novichenko on 3/30/20.
//  Copyright © 2020 Anton Novichenko. All rights reserved.
//

import UIKit

public class LineTextField: UITextField {

	private var underlineView: UIView!

	// MARK: - IBInspectable
	@IBInspectable var lineColorDefault: UIColor = UIColor.white {
		didSet {
			underlineView.backgroundColor = lineColorDefault
		}
	}
	@IBInspectable var lineColorActive: UIColor = UIColor.black

	@IBInspectable var floatingPlaceholder: Bool = false

	public required init?(coder: NSCoder) {
		super.init(coder: coder)

		self.borderStyle = .none

		initializeUnderline()

		addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
		addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
	}

	private func initializeUnderline() {
		underlineView = UIView(frame: CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 1))
		underlineView.backgroundColor = lineColorDefault
		underlineView.translatesAutoresizingMaskIntoConstraints = false
		underlineView.layer.cornerRadius = 1

		addSubview(underlineView)
		bringSubviewToFront(subviews.last!)
	}

	// MARK: - Events
	@objc func editingDidBegin() {
		UIView.animate(withDuration: 0.25) {
			self.underlineView.backgroundColor = self.lineColorActive
			self.underlineView.frame.size.height += 1
		}
	}

	@objc func editingDidEnd() {
		UIView.animate(withDuration: 0.25) {
			self.underlineView.backgroundColor = self.lineColorDefault
			self.underlineView.frame.size.height -= 1
		}
	}
}
