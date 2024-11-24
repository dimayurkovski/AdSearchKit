// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AdSearchKit",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "AdSearchKit", targets: ["AdSearchKit"]),
    ],
    targets: [
        .target(name: "AdSearchKit",
                resources: [.process("PrivacyInfo.xcprivacy")]),
    ],
    swiftLanguageModes: [.v5]
)
