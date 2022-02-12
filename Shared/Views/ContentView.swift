//
//  ContentView.swift
//  GuitarCloset
//
//  Created by Deirdre Saoirse Moen on 2/11/22.
//

import SwiftUI

struct ContentView: View {
	@SceneStorage("selectedView") var selectedView: String?
	@EnvironmentObject var persistence: Persistence

	var body: some View {
		TabView(selection: $selectedView) {
			HomeView(persistence: persistence)
				.tabItem {
					Image(systemName: "house")
					Text("Home")
				}
				.tag(HomeView.tag)

			GuitarsView(persistence: persistence)
				.tag(GuitarsView.guitarTag)
				.tabItem {
					Image(systemName: "guitars")
					Text("Open")
				}

			Text("Reset")
				.tag("Reset")
				.tabItem {
					Image(systemName: "trash.slash.fill")
					Text("Reset")
				}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
