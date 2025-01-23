// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "DifferenceKit",
  platforms: [
    .iOS(.v13), .macOS(.v10_15), .tvOS(.v12), .watchOS(.v9)
  ],
  products: [
    .library(name: "DifferenceKitDynamic", type: .dynamic, targets: ["DifferenceKit"]),
    .library(name: "DifferenceKit", targets: ["DifferenceKit"])
  ],
  targets: [
    .target(
      name: "DifferenceKit",
      path: "Sources",
      linkerSettings: [
        .unsafeFlags(["-Wl,-make_mergeable"])
      ]
    ),
    .testTarget(
      name: "DifferenceKitTests",
      dependencies: ["DifferenceKit"],
      path: "Tests"
    )
  ],
  swiftLanguageVersions: [.v4_2, .v5]
)
