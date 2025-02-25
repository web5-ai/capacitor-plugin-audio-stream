// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorPluginAudioStream",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "CapacitorPluginAudioStream",
            targets: ["AudioStreamPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "AudioStreamPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/AudioStreamPlugin"),
        .testTarget(
            name: "AudioStreamPluginTests",
            dependencies: ["AudioStreamPlugin"],
            path: "ios/Tests/AudioStreamPluginTests")
    ]
)