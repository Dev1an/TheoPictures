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

		imageViews.forEach { image in
			image.translatesAutoresizingMaskIntoConstraints = false
			image.constrainSizeToFrameSize()
		}
		imageViews[0..<3].forEach(stack1.addArrangedSubview)
		imageViews[3..<6].forEach(stack2.addArrangedSubview)
	}
}

extension UIView {
	fileprivate func constrainSizeToFrameSize() {
		addConstraints([
			widthAnchor.constraint( equalToConstant: frame.width ),
			heightAnchor.constraint(equalToConstant: frame.height)
		])
	}
}
