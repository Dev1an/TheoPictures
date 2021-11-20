//
//  WebImageView.swift
//  TheoPics
//
//  Created by Damiaan on 19/11/2021.
//

import UIKit
import WebKit

public class RandomImageWebView: WKWebView {
	public enum Error: Swift.Error {
		case illegalCssColor(String)
	}

	public static func imageUrl(width: Int, height: Int) -> URL {
		URL(string: "https://picsum.photos/\(width)/\(height)")!
	}

	public func loadImage(width: Int, height: Int) {
		load(
			URLRequest(url: Self.imageUrl(width: width, height: height))
		)
	}
}

extension RandomImageWebView: ImageViewBackedByWebview {
	public static func generate(width: Int, height: Int) -> ImageViewBackedByWebview {
		let size = CGSize(width: width, height: height)
		let frame = CGRect(origin: .zero, size: size)
		let view = RandomImageWebView(frame: frame)

		view.loadImage(width: width, height: height)

		return view
	}

	public func changeBackground(color: String, completionHandler: ((Bool, Swift.Error?) -> Void)?) {
		evaluateJavaScript("document.body.style.backgroundColor = '\(color)'") { result, error in
			completionHandler?(color == result as? String, error)
		}
	}
}
