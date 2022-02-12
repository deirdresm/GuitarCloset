//
//  GuitarsView.swift
//  GuitarCloset (iOS)
//
//  Created by Deirdre Saoirse Moen on 2/11/22.
//

import SwiftUI

struct GuitarsView: View {

	@StateObject var viewModel: ViewModel
	@State private var showingSortOrder = false

	static let guitarTag: String? = "Guitar"

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }

	var guitarsList: some View {
		List {
			ForEach(viewModel.guitars) { guitar in
				Section(header: GuitarHeaderView(guitar: guitar)) {

//					if viewModel.showClosedGuitars == false {
						Button {
							withAnimation {
								viewModel.addGuitar()
							}
						} label: {
							Label("Add New Guitar", systemImage: "plus")
						}
//					}
				}
			}
		} // List
#if os(macOS)
		.listStyle(.inset)
#else
		.listStyle(.insetGrouped)
#endif
	}

	init(persistence: Persistence) {
		let viewModel = ViewModel(persistence: persistence)
		_viewModel = StateObject(wrappedValue: viewModel)
	}
}

struct GuitarsView_Previews: PreviewProvider {
	static var persistence = Persistence.preview

    static var previews: some View {
        GuitarsView(persistence: Persistence.preview)
    }
}
