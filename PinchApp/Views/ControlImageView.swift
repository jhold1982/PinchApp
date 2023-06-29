//
//  ControlImageView.swift
//  PinchApp
//
//  Created by Justin Hold on 6/28/23.
//

import SwiftUI

struct ControlImageView: View {
	
	// MARK: - PROPERTIES
	let icon: String
	
	
	// MARK: - BODY
    var body: some View {
		Image(systemName: icon)
			.font(.system(size: 36))
    }
}

// MARK: - PREVIEWS
struct ControlImageView_Previews: PreviewProvider {
    static var previews: some View {
		ControlImageView(icon: "minus.magnifyingglass")
			.preferredColorScheme(.dark)
			.previewLayout(.sizeThatFits)
			.padding()
    }
}
