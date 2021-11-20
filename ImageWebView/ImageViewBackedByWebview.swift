//
//  ImageViewBackedByWebview.swift
//  TheoPics
//
//  Created by Damiaan on 19/11/2021.
//

public protocol ImageViewBackedByWebview {
	/** Generates an ImageViewBackedByWebview. (A view, that's backed by a webview which loads an image from https://picsum.photos/200/300 immediately) */
	static func generate(width: Int, height: Int) -> ImageViewBackedByWebview

	/**
	Changes the background color of the ImageViewBackedByWebview. Parameters:
	- color: any color that's accepted in CSS
	- completionHandler: called when the color change was executed with a successful result or in case of
	an error
	*/
	func changeBackground(color: String, completionHandler: ((Bool, Error?) -> Void)?) -> Void
}
