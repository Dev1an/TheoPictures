//
//  WebImageView.swift
//  TheoPics
//
//  Created by Damiaan on 19/11/2021.
//

import UIKit
import WebKit

class RandomImageWebView: WKWebView {
	enum Error: Swift.Error {
		case illegalCssColor(String)
	}

	func imageUrl(width: Int, height: Int) -> URL {
		URL(string: "https://picsum.photos/\(width)/\(height)")!
	}

	func loadImage(width: Int, height: Int) {
		load(
			URLRequest(url: imageUrl(width: width, height: height))
		)
	}
}

extension RandomImageWebView: ImageViewBackedByWebview {
	static func generate(width: Int, height: Int) -> ImageViewBackedByWebview {
		let size = CGSize(width: width, height: height)
		let frame = CGRect(origin: .zero, size: size)
		let view = RandomImageWebView(frame: frame)

		view.loadImage(width: width, height: height)

		return view
	}

	func changeBackground(color: String, completionHandler: ((Bool, Swift.Error?) -> Void)?) {
		evaluateJavaScript("document.body.style.backgroundColor = '\(color)'") { result, error in
			completionHandler?(color == result as? String, error)
		}
	}
}
