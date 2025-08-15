// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "InAppSettingsKit",
    defaultLocalization: "en",
	platforms: [.iOS("10.0"), .macCatalyst("13.0")],
    products: [
        .library(
            name: "InAppSettingsKit",
            targets: ["InAppSettingsKit"]
        ),
        .library(
            name: "InAppSettingsKitSwiftUI",
            targets: ["InAppSettingsKitSwiftUI"]
        )
    ],
    targets: [
        .target(
            name: "InAppSettingsKit",
			exclude: [
				"README.md",
				"IASK.gif",
				"InAppSettingsKit.podspec",
				"RELEASE_NOTES.md",
			],
			resources: [.copy("PrivacyInfo.xcprivacy")]
        ),
        .target(
            name: "InAppSettingsKitSwiftUI",
            dependencies: [
                "InAppSettingsKit"
            ]
        ),
        .testTarget(
            name: "InAppSettingsKitTests",
            dependencies: [
                "InAppSettingsKit"
            ],
            resources: [
                .copy("Settings.bundle")
            ]
        ),
    ]
)
