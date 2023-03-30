//
//  EditProjectView+iOS.swift
//  Portfolioish (iOS)
//
//  Created by Deirdre Saoirse Moen on 3/3/22.
//

import UIKit

extension EditProjectView {

	/// Give link to application settings if notifications fail
	func showAppSettings() {
		guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
			return
		}

		if UIApplication.shared.canOpenURL(settingsUrl) {
			UIApplication.shared.open(settingsUrl)
		}
	}

}
