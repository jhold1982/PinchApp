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
	@State private var isDrawerOpen = false
	@State private var pageIndex = 1
	
	let pages: [Page] = pagesData
	
	// MARK: - BODY
    var body: some View {
		NavigationStack {
			ZStack {
				Color(.clear)
					.ignoresSafeArea()
				// MARK: - PAGE IMAGE
				Image(currentPage())
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
							} //: END OF ON CHANGED
							.onEnded { _ in
								if imageScale > 5 {
									imageScale = 5
								} else if imageScale <= 1 {
									resetImageState()
								}
							} //: END OF ON ENDED
					) //: END OF MAGNIFICATION GESTURE
			} //: END OF ZSTACK
			.navigationTitle("Pinch & Zoom")
			.navigationBarTitleDisplayMode(.inline)
			.onAppear(perform: {
				isAnimating = true
			}) //: END OF ON APPEAR
			.animation(.linear(duration: 1), value: isAnimating)
			// MARK: - INFO PANEL
			.overlay(
				InfoPanelView(scale: imageScale, offset: imageOffset)
					.padding(.horizontal)
					.padding(.top, 30)
				, alignment: .top
			) //: END OF INFO PANEL OVERLAY
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
					} //: END OF CONTROLS HSTACK
					.padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
					.background(.ultraThinMaterial)
					.cornerRadius(12)
					.opacity(isAnimating ? 1 : 0)
				}
					.padding(.bottom, 30)
				, alignment: .bottom
			) //: END OF CONTROLS OVERLAY
			// MARK: - DRAWER
			.overlay(
				HStack(spacing: 12) {
					// MARK: - DRAWER HANDLE
					Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
						.resizable()
						.scaledToFit()
						.frame(height: 40)
						.padding(8)
						.foregroundStyle(.secondary)
						.onTapGesture(perform: {
							withAnimation(.easeOut) {
								isDrawerOpen.toggle()
							}
						})
					// MARK: - THUMBNAILS
					ForEach(pages) { item in
						Image(item.thumbnailName)
							.resizable()
							.scaledToFit()
							.frame(width: 80)
							.cornerRadius(8)
							.shadow(radius: 4)
							.opacity(isDrawerOpen ? 1 : 0)
							.animation(.easeOut(duration: 0.5), value: isDrawerOpen)
							.onTapGesture(perform: {
								isAnimating = true
								pageIndex = item.id
							})
					} //: END OF THUMBNAIL FOR EACH
					Spacer()
				} //: END OF DRAWER HSTACK
					.padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
					.background(.ultraThinMaterial)
					.cornerRadius(12)
					.opacity(isAnimating ? 1 : 0)
					.frame(width: 260)
					.padding(.top, UIScreen.main.bounds.height / 12)
					.offset(x: isDrawerOpen ? 20 : 215)
				, alignment: .topTrailing
			) //: END OF DRAWER OVERLAY
		} //: END OF NAVIGATION STACK
    } //: END OF BODY
	// MARK: - FUNCTIONS
	func resetImageState() {
		return withAnimation(.spring()) {
			imageScale = 1
			imageOffset = .zero
		}
	}
	func currentPage() -> String {
		pages[pageIndex - 1].imageName
	}
}

// MARK: - PREVIEWS
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
