// swift-tools-version: 6.0
import PackageDescription
let package = Package(
    name: "daily_check-Builder",
    platforms: [
        .iOS("17.0"),
    ],
    dependencies: [
        .package(name: "RootPackage", path: "../.."),
    ],
    targets: [
        .executableTarget(
    name: "daily_check-App",
    dependencies: [
        .product(name: "daily_check", package: "RootPackage"),
    ],
    linkerSettings: [
    .unsafeFlags([
        "-Xlinker", "-rpath", "-Xlinker", "@executable_path/Frameworks",
    ]),
]
)
    ]
)
