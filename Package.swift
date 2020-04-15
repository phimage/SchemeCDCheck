// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SchemeCDCheck",
    products: [
        .executable(
            name: "schemeCDCheck", targets: ["SchemeCDCheck"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/phimage/MomXML" , .upToNextMajor(from: "1.1.0"))
    ],
    targets: [
        .target(
            name: "SchemeCDCheck",
            dependencies: ["MomXML"],
            path: "Sources"
        )
    ]
)
