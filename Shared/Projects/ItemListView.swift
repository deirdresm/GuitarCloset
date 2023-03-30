//
//  ItemListView.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 1/3/22.
//

import SwiftUI

struct ItemListView: View {
	let title: LocalizedStringKey
	@Binding var items: ArraySlice<Item>

	#if os(macOS)
	let circleSize = 16.0
	let circleStrokeWidth = 2.0
	let horizontalSpacing = 10.0
	#else
	let circleSize = 44.0
	let circleStrokeWidth = 3.0
	let horizontalSpacing = 20.0
	#endif

    var body: some View {
		if items.isEmpty {
			EmptyView()
		} else {
			Text(title)
				.font(.headline)
				.foregroundColor(.secondary)
				.padding(.top)

			ForEach(items) { item in
				NavigationLink(destination: EditItemView(item: item)) {
					HStack(spacing: horizontalSpacing) {
						Circle()
							.strokeBorder(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: circleStrokeWidth)
							.frame(width: circleSize, height: circleSize)
						VStack(alignment: .leading) {
							Text(item.itemTitle)
								.font(.title2)
								.foregroundColor(.primary)
								.frame(maxWidth: .infinity, alignment: .leading)

							if item.detail?.isEmpty == false {
								Text(item.detail.orEmpty)
									.foregroundColor(.secondary)
							}
						}
					}
					#if os(iOS)
					.padding()
					.background(Color.secondarySystemGroupedBackground)
					.cornerRadius(10)
					.shadow(color: Color.black.opacity(0.2), radius: 5)
					#endif
				}
			}
		}
    }
}

// struct ItemListView_Previews: PreviewProvider {
//	static var title: String = "Up next"
//	static var items: FetchedResults<Item>.SubSequence
//
//    static var previews: some View {
//		ItemListView(title: title, items: items.wrappedValue.prefix(3))
//    }
// }
