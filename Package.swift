// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "DifferenceKit",
  platforms: [
    .iOS(.v13), .macOS(.v10_15), .tvOS(.v9), .watchOS(.v2)
  ],
  products: [
    .library(name: "DifferenceKitDynamic", type: .dynamic, targets: ["DifferenceKit"]),
    .library(name: "DifferenceKit", targets: ["DifferenceKit"])
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
