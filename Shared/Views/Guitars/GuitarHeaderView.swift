//
//  GuitarHeaderView.swift
//  GuitarCloset
//
//  Created by Deirdre Saoirse Moen on 2/12/22.
//

import SwiftUI

struct GuitarHeaderView: View {
	@ObservedObject var guitar: Guitar

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct GuitarHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GuitarHeaderView(guitar: Guitar.example)
    }
}
