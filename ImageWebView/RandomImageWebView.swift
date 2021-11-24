//
//  WebImageView.swift
//  TheoPics
//
//  Created by Damiaan on 19/11/2021.
//

import UIKit
import WebKit

public class RandomImageWebView: WKWebView {
	/// Used to give the view an intrinsic content size
	var imageSize = CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
	public override var intrinsicContentSize: CGSize { imageSize }

	/// Generate a random image with an intrinsic content size
	public static func generateView(width: Int, height: Int) -> Self {
		let view = Self()
		view.imageSize = CGSize(width: width, height: height)
		view.loadImage(width: width, height: height)

		return view
	}

	public func loadImage(width: Int, height: Int) {
		loadHTMLString(Self.imageDomString(width: width, height: height), baseURL: nil)
	}

	public static func imageUrl(width: Int, height: Int) -> URL {
		URL(string: "https://picsum.photos/\(width)/\(height)")!
	}

	public static func imageDomString(width: Int, height: Int) -> String {
		"""
			<head>
				<meta name="viewport" content="width=device-width">
				<style>
					img {
						width:100vw;
						height:100vh;
						object-fit: contain
					}

					body, html {
						padding: 0;
						margin: 0
					}
				</style>
			</head>
			<body>
				<img src="\( imageUrl(width: width, height: height).absoluteString )">
			</body
		"""
	}
}

extension RandomImageWebView: ImageViewBackedByWebview {
	public static func generate(width: Int, height: Int) -> ImageViewBackedByWebview {
		generateView(width: width, height: height)
	}

	public enum Error: Swift.Error {
		case illegalCssColor(String)
	}

	public func changeBackground(color: String, completionHandler: ((Bool, Swift.Error?) -> Void)? = nil) {
		evaluateJavaScript("document.body.style.backgroundColor = '\(color)'") { result, error in
			completionHandler?(color == result as? String, error)
		}
	}
}
