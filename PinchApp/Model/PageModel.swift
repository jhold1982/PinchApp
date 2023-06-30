//
//  PageModel.swift
//  PinchApp
//
//  Created by Justin Hold on 6/30/23.
//

import Foundation

struct Page: Identifiable {
	let id: Int
	let imageName: String
}

extension Page {
	var thumbnailName: String {
		"thumb-" + imageName
	}
}
