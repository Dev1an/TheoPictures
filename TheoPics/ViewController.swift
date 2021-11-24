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

	// Create image views
	let imageViews = (0 ..< totalImages).map { _ in
		RandomImageWebView.generateView(width: 150, height: 100)
	}
	let columnSeparator = totalImages/2

	// Outlets for the grid
	@IBOutlet weak var columns: UIStackView!
	@IBOutlet var column1: UIStackView!
	@IBOutlet var column2: UIStackView!

	var selectedIndex: Int?

	override func viewDidLoad() {
		super.viewDidLoad()

		imageViews.forEach(setup)

		// Add the images to the columns (divided by columnSeparator)
		imageViews[0..<columnSeparator].forEach(column1.addArrangedSubview)
		imageViews[columnSeparator... ].forEach(column2.addArrangedSubview)
	}

	/// Executes when a user taps on an image tile
	@objc func handleTap(_ sender: UITapGestureRecognizer) {
		let image = sender.view as! RandomImageWebView
		if let index = selectedIndex {
			putBackInGrid(index)
		} else {
			let index = imageViews.firstIndex(of: image)!
			makeFullScreen(index)
		}
	}


	/// Configures a random image for display
	/// - Parameter image: the image to configure
	func setup(image: RandomImageWebView) {
		image.translatesAutoresizingMaskIntoConstraints = false
		image.addGestureRecognizer(createTapRecognizer())

		// allows the tap recognizer but ignores the rest (scrolling, selections, etc.)
		image.scrollView.isUserInteractionEnabled = false
	}
}

// MARK: - Gesture recognizer
extension MultipleImagesViewController: UIGestureRecognizerDelegate {
	/// Allow gestures from the web view and from our tap recognizer simultanuously
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}

	/// Create and set up a tap recognizer that calls `handleTap` on this instance of MultipleImagesViewController
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
	/// Pop an image from the grid and make it full screen
	func makeFullScreen(_ imageIndex: Int) {
		defer { selectedIndex = imageIndex }
		let image = imageViews[imageIndex]
		// Tell the grid not to manage this tile anymore
		column(for: imageIndex).removeArrangedSubview(image)
		// Place the image in front of all other views
		makeFrontMost(imageIndex: imageIndex)
		// Add constraints to fill the screen
		view.addConstraints(fullScreenConstraints(for: image))
		view.layoutIfNeeded()
	}

	/// Put an image back into the grid
	func putBackInGrid(_ imageIndex: Int) {
		defer {selectedIndex = nil}
		let image = imageViews[imageIndex]
		image.removeFromSuperview()
		column(for: imageIndex).insertArrangedSubview(image, at: rowIndex(for: imageIndex))
	}

	/// Create the constraints to stretch an image to full screen
	func fullScreenConstraints(for image: UIView) -> [NSLayoutConstraint] {
		let guides = view.safeAreaLayoutGuide
		return [
			image.leadingAnchor.constraint(equalTo: guides.leadingAnchor),
			image.trailingAnchor.constraint(equalTo: guides.trailingAnchor),
			image.topAnchor.constraint(equalTo: guides.topAnchor),
			image.bottomAnchor.constraint(equalTo: guides.bottomAnchor)
		]
	}

	/// Place an image over all the other views
	func makeFrontMost(imageIndex index: Int) {
		let image = imageViews[index]
		image.removeFromSuperview()
		view.addSubview(image)
	}

	/// Convert an image index into its corresponing column index
	func column(for index: Int) -> UIStackView {
		index < columnSeparator ? column1 : column2
	}

	/// Convert an image index into its corresponding row index
	func rowIndex(for index: Int) -> Int {
		index < columnSeparator ? index : index - columnSeparator
	}
}
