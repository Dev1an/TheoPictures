//
//  ViewController.swift
//  TheoPics
//
//  Created by Damiaan on 19/11/2021.
//

import UIKit
import ImageWebView

fileprivate let colors = ["red", "orange", "yellow", "green", "blue"]

class SingleImageViewController: UIViewController {

	@IBOutlet weak var imageView: RandomImageWebView!

	override func viewDidLoad() {
		super.viewDidLoad()

		imageView.loadImage(
			width: Int(imageView.frame.width),
			height: Int(imageView.frame.height)
		)
	}

	@IBAction func changeColor(_ sender: Any) {
		imageView.changeBackground(color: colors.randomElement()!, completionHandler: nil)
	}
}
