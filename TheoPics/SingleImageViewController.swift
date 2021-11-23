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
	@IBOutlet weak var fixedWidthConstraint: NSLayoutConstraint!

	override func viewDidLoad() {
		super.viewDidLoad()

		imageView.loadImage(
			width: Int(imageView.frame.width * 3),
			height: Int(imageView.frame.height * 3)
		)
		imageView.backgroundColor = .clear
	}

	@IBAction func changeColor(_ sender: Any) {
		imageView.changeBackground(color: colors.randomElement()!, completionHandler: nil)
	}

	@IBAction func changeWidth(_ sender: Any) {
		let original = imageView.frame
		imageView.layer.opacity = 0.2
		fixedWidthConstraint.isActive.toggle()
		view.layoutIfNeeded()
		let zoomFactor = imageView.frame.width / original.width

		if zoomFactor < 1 {
			// when zooming out, revert to the bigger frame to start a shrink animation
			fixedWidthConstraint.isActive.toggle()
			view.layoutSubviews()
		}

		UIView.animate(withDuration: 0.15) {
			self.imageView.scrollView.zoomScale = 1.01
		} completion: { _ in
			self.imageView.layer.opacity = 1
			self.doZoomTransition(to: zoomFactor) {
				if zoomFactor < 1 {
					self.fixedWidthConstraint.isActive.toggle()
					self.view.layoutSubviews()
				}
				self.setZoom(to: 1)
			}
		}
	}

	func doZoomTransition(to zoomFactor: CGFloat, completion: @escaping ()->Void) {
		let sourceZoomFactor: CGFloat
		let targetZoomFactor: CGFloat
		if zoomFactor < 1 {
			sourceZoomFactor = 1
			targetZoomFactor = zoomFactor
		} else {
			sourceZoomFactor = 1/zoomFactor
			targetZoomFactor = 1
			setZoom(to: sourceZoomFactor)
		}

		UIView.animate(withDuration: 0.5) {
			self.setZoom(to: targetZoomFactor)
		} completion: { completed in
			completion()
		}
	}

	func setZoom(to zoomFactor: CGFloat) {
		let horizontalInset = imageView.frame.width * (1 - zoomFactor) / 2
		let verticalInset  = imageView.frame.height * (1 - zoomFactor) / 2

		if zoomFactor < 1 {
			imageView.scrollView.contentInset = .init(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
		} else {
			imageView.scrollView.contentInset = .zero
		}
		imageView.scrollView.minimumZoomScale = 0.1
		imageView.scrollView.zoomScale = zoomFactor
		imageView.scrollView.contentOffset = .init(x: -horizontalInset, y: -verticalInset)
	}

	@IBAction func resetColor(_ sender: Any) {
		imageView.changeBackground(color: "rgba(0,0,0,0)")
	}
}
