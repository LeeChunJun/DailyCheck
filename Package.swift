// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DailyCheck",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        // An xtool project should contain exactly one library product,
        // representing the main app.
        .library(
            name: "daily_check",
            targets: ["daily_check"]
        ),
    ],
    targets: [
        .target(
            name: "daily_check",
            resources: [.process("Assets.xcassets")]
        ),
    ]
)
