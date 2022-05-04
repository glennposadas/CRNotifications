// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CRNotifications",
    platforms: [
      .iOS(.v9)
    ],
    products: [
        .library(
            name: "CRNotifications",
            targets: ["CRNotifications"]),
    ],
    targets: [
        .target(
            name: "CRNotifications",
            dependencies: [],
            path: "CRNotifications",
            resources: [
              .process("CRNotificationsMedia")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
