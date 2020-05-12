//
//  TableViewController.swift
//  LineTextFieldExample
//
//  Created by Anton Novichenko on 5/12/20.
//  Copyright © 2020 Anton Novichenko. All rights reserved.
//

import UIKit
import LineTextField

struct Model {
	let title: String;
	let value: String;

	static let defaultValues: [Model] = [
		Model(title: "Title1", value: ""),
		Model(title: "Title2", value: "1"),
		Model(title: "Title3", value: ""),
		Model(title: "Title4", value: "2"),
		Model(title: "Title5", value: "")
	]
}

final class TableCell: UITableViewCell {
	@IBOutlet var textField: LineTextField!

	var model: Model? {
		didSet {
			guard let model = model else { return }

			textField.placeholder = model.title
			textField.text = model.value
		}
	}
}

final class TableViewController: UIViewController {

	@IBOutlet var tableView: UITableView!

	override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TableViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		Model.defaultValues.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableCell

		let model = Model.defaultValues[indexPath.row]

		cell.model = model

		return cell
	}
}
