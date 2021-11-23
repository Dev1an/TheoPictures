//
//  MultipleViewControllers.swift
//  TheoPics
//
//  Created by Damiaan on 20/11/2021.
//

import UIKit
import ImageWebView

fileprivate let totalImages = 6

class MultipleImagesViewController: UIViewController {
	let imageViews = (0 ..< totalImages).map { _ in
		RandomImageWebView.generate(width: 150, height: 100) as! RandomImageWebView
	}
	let columnSeparator = totalImages/2

	@IBOutlet weak var columnStack: UIStackView!
	@IBOutlet var column1: UIStackView!
	@IBOutlet var column2: UIStackView!

	var selectedIndex: Int?

	override func viewDidLoad() {
		super.viewDidLoad()

		imageViews.forEach(setup)
		imageViews[0..<columnSeparator].forEach(column1.addArrangedSubview)
		imageViews[columnSeparator... ].forEach(column2.addArrangedSubview)
	}

	@objc func handleTap(_ sender: UITapGestureRecognizer) {
		let image = sender.view as! RandomImageWebView
		if let index = selectedIndex {
			putBackInStack(index)
		} else {
			let index = imageViews.firstIndex(of: image)!
			makeFullScreen(index)
		}
	}

	func setup(image: RandomImageWebView) {
		image.translatesAutoresizingMaskIntoConstraints = false
		image.addGestureRecognizer(createTapRecognizer())

		// allows the tap recognizer but ignores the rest (scrolling, selections, etc.)
		image.scrollView.isUserInteractionEnabled = false
	}
}

// MARK: - Gesture recognizer
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

// MARK: - Resizing (Tile ↔︎ Fullscreen)
extension MultipleImagesViewController {
	func makeFullScreen(_ imageIndex: Int) {
		defer { selectedIndex = imageIndex }
		let image = imageViews[imageIndex]
		column(for: imageIndex).removeArrangedSubview(image)
		makeFrontMost(imageIndex: imageIndex)
		view.addConstraints(fullScreenConstraints(for: image))
		view.layoutIfNeeded()
	}

	func putBackInStack(_ imageIndex: Int) {
		defer {selectedIndex = nil}
		let image = imageViews[imageIndex]
		image.removeFromSuperview()
		column(for: imageIndex).insertArrangedSubview(image, at: rowIndex(for: imageIndex))
	}

	func fullScreenConstraints(for image: UIView) -> [NSLayoutConstraint] {
		let guides = view.safeAreaLayoutGuide
		return [
			image.leadingAnchor.constraint(equalTo: guides.leadingAnchor),
			image.trailingAnchor.constraint(equalTo: guides.trailingAnchor),
			image.topAnchor.constraint(equalTo: guides.topAnchor),
			image.bottomAnchor.constraint(equalTo: guides.bottomAnchor)
		]
	}

	func makeFrontMost(imageIndex index: Int) {
		let image = imageViews[index]
		image.removeFromSuperview()
		view.addSubview(image)
	}

	func column(for index: Int) -> UIStackView {
		index < columnSeparator ? column1 : column2
	}

	func rowIndex(for index: Int) -> Int {
		index < columnSeparator ? index : index - columnSeparator
	}
}
