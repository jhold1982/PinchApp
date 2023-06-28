//
//  ContentView.swift
//  PinchApp
//
//  Created by Justin Hold on 6/22/23.
//

import SwiftUI

struct ContentView: View {
	
	// MARK: - PROPERTIES
	@State private var isAnimating = false
	@State private var imageScale: CGFloat = 1
	
	// MARK: - BODY
    var body: some View {
		NavigationStack {
			ZStack {
				// MARK: - PAGE IMAGE
				Image("magazine-front-cover")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.cornerRadius(10)
					.padding()
					.shadow(
						color: .black.opacity(0.2),
						radius: 12,
						x: 2,
						y: 2
					)
					.opacity(isAnimating ? 1 : 0)
					.scaleEffect(imageScale)
				// MARK: - 1. TAP GESTURE
					// Tap Count
					.onTapGesture(count: 2, perform: {
						if imageScale == 1 {
							withAnimation(.spring()) {
								// Scale Up
								imageScale = 5
							}
						} else {
							withAnimation(.spring()) {
								// Scale Down back to default
								imageScale = 1
							}
						}
					})
			} //: END OF ZSTACK
			.navigationTitle("Pinch & Zoom")
			.navigationBarTitleDisplayMode(.inline)
			.onAppear(perform: {
				isAnimating = true
			})
			.animation(.linear(duration: 1), value: isAnimating)
		} //: END OF NAVIGATION STACK
		
    }
}

// MARK: - PREVIEWS
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
