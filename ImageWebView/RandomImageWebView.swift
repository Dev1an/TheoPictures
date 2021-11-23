//
//  WebImageView.swift
//  TheoPics
//
//  Created by Damiaan on 19/11/2021.
//

import UIKit
import WebKit

public class RandomImageWebView: WKWebView {
	var imageSize = CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)

	public override init(frame: CGRect, configuration: WKWebViewConfiguration = WKWebViewConfiguration()) {
		super.init(frame: frame, configuration: configuration)
		imageSize = frame.size
	}

	required init?(coder: NSCoder) { super.init(coder: coder) }

	public enum Error: Swift.Error {
		case illegalCssColor(String)
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

	public func loadImage(width: Int, height: Int) {
		loadHTMLString(Self.imageDomString(width: width, height: height), baseURL: nil)
	}
}

extension RandomImageWebView: ImageViewBackedByWebview {
	public override var intrinsicContentSize: CGSize { imageSize }

	public static func generate(width: Int, height: Int) -> ImageViewBackedByWebview {
		let size = CGSize(width: width, height: height)
		let frame = CGRect(origin: .zero, size: size)
		let view = RandomImageWebView(frame: frame)

		view.loadImage(width: width, height: height)

		return view
	}

	public func changeBackground(color: String, completionHandler: ((Bool, Swift.Error?) -> Void)? = nil) {
		evaluateJavaScript("document.body.style.backgroundColor = '\(color)'") { result, error in
			completionHandler?(color == result as? String, error)
		}
	}
}
