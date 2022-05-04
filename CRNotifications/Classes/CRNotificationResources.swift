//
//  File.swift
//  
//
//  Created by Glenn Posadas on 5/4/22.
//

import Foundation

public final class CRNotificationResources {
    public static let resourceBundle: Bundle = {
        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: CRNotifications.self).resourceURL,
        ]

        let bundleName = "CRNotifications_CRNotifications"

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }

        // Return whatever bundle this code is in as a last resort.
        return Bundle(for: CRNotificationResources.self)
    }()
}
