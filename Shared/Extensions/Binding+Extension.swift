//
//  Binding+Extension.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 12/29/21.
//

import Foundation
import SwiftUI

extension Binding {
	func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
		Binding(
			get: { self.wrappedValue },
			set: { newValue in
				self.wrappedValue = newValue
				handler()
			}
		)
	}
}
