// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SwiftChecker",
	products: [
		.library(name: "SwiftChecker", targets: ["SwiftChecker"]),
	],
	dependencies: [
		.package(url: "https://github.com/Pasanpr/SwiftAST", from: "0.1.0"),
	],
	targets: [
		.target(name: "SwiftChecker", dependencies: ["SwiftAST"]),
		.testTarget(
			name: "SwiftCheckerTests",
			dependencies: ["SwiftChecker"]
		)
	]
)