//
//  MultipleViewControllers.swift
//  TheoPics
//
//  Created by Damiaan on 20/11/2021.
//

import UIKit
import ImageWebView

class MultipleImagesViewController: UIViewController {
	@IBOutlet var stack1: UIStackView!
	@IBOutlet var stack2: UIStackView!

	let imageViews = (1...6).map { _ in
		RandomImageWebView.generate(width: 100, height: 100) as! RandomImageWebView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		imageViews.forEach(setup)
		imageViews[0..<3].forEach(stack1.addArrangedSubview)
		imageViews[3..<6].forEach(stack2.addArrangedSubview)
	}

	@objc func handleTap(_ sender: UITapGestureRecognizer) {
	}

	func setup(image: RandomImageWebView) {
		image.translatesAutoresizingMaskIntoConstraints = false
		image.addGestureRecognizer(createTapRecognizer())

		// allows the tap recognizer but ignores the rest (scrolling, selections, etc.)
		image.scrollView.isUserInteractionEnabled = false
	}
}

extension MultipleImagesViewController: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}

	func createTapRecognizer() -> UITapGestureRecognizer {
		let tapRecognizer = UITapGestureRecognizer(
			target: self,
			action: #selector(handleTap)
		)
		tapRecognizer.delegate = self
		return tapRecognizer
	}
}
