// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "DifferenceKit",
  platforms: [
    .iOS(.v14), .macOS(.v11), .tvOS(.v12), .watchOS(.v8)
  ],
  products: [
    .library(name: "DifferenceKitDynamic", type: .dynamic, targets: ["DifferenceKit"])
  ],
  targets: [
    .target(
      name: "DifferenceKit",
      path: "Sources"
    ),
    .testTarget(
      name: "DifferenceKitTests",
      dependencies: ["DifferenceKit"],
      path: "Tests"
    )
  ],
  swiftLanguageVersions: [.v4_2, .v5]
)
