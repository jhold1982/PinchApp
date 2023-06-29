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
	@State private var imageOffset: CGSize = .zero
	
	// MARK: - BODY
    var body: some View {
		NavigationStack {
			ZStack {
				Color(.clear)
					.ignoresSafeArea()
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
					.offset(x: imageOffset.width, y: imageOffset.height)
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
							resetImageState()
						}
					}) //: END OF TAP GESTURE
				// MARK: - 2. DRAG GESTURE
					.gesture(
						DragGesture()
							.onChanged { value in
								withAnimation(.linear(duration: 1)) {
									imageOffset = value.translation
								}
							}
							.onEnded { _ in
								if imageScale <= 1 {
									resetImageState()
								}
							}
					) //: END OF DRAG GESTURE
				// MARK: - 3. MAGNIFICATION GESTURE
					.gesture(
						MagnificationGesture()
							.onChanged { value in
								withAnimation(.linear(duration: 1)) {
									if imageScale >= 1 && imageScale <= 5 {
										imageScale = value
									} else if imageScale > 5 {
										imageScale = 5
									}
								}
							}
							.onEnded { _ in
								if imageScale > 5 {
									imageScale = 5
								} else if imageScale <= 1 {
									resetImageState()
								}
							}
					) //: END OF MAGNIFICATION GESTURE
			} //: END OF ZSTACK
			.navigationTitle("Pinch & Zoom")
			.navigationBarTitleDisplayMode(.inline)
			.onAppear(perform: {
				isAnimating = true
			})
			.animation(.linear(duration: 1), value: isAnimating)
			// MARK: - INFO PANEL
			.overlay(
				InfoPanelView(scale: imageScale, offset: imageOffset)
					.padding(.horizontal)
					.padding(.top, 30)
				, alignment: .top
			)
			// MARK: - CONTROLS
			.overlay(
				Group {
					HStack {
						
						Button {
							withAnimation(.spring()) {
								if imageScale > 1 {
									imageScale -= 1
									if imageScale <= 1 {
										resetImageState()
									}
								}
							}
						} label: {
							ControlImageView(icon: "minus.magnifyingglass")
						}
						
						// RESET
						Button {
							resetImageState()
						} label: {
							ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
						}
						
						// SCALE UP
						Button {
							withAnimation(.spring()) {
								if imageScale < 5 {
									imageScale += 1
									if imageScale > 5 {
										imageScale = 5
									}
								}
							}
						} label: {
							ControlImageView(icon: "plus.magnifyingglass")
						}
					} //: END OF CONTROLS
					.padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
					.background(.ultraThinMaterial)
					.cornerRadius(12)
					.opacity(isAnimating ? 1 : 0)
				}
					.padding(.bottom, 30)
				, alignment: .bottom
			)
		} //: END OF NAVIGATION STACK
    }
	
	func resetImageState() {
		return withAnimation(.spring()) {
			imageScale = 1
			imageOffset = .zero
		}
	}
}

// MARK: - PREVIEWS
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
