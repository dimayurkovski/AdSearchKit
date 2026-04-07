// swift-tools-version: 5.9

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
    ]
)
