// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SwiftChecker",
	products: [
		.library(name: "SwiftAST", targets: ["SwiftAST", "SwiftChecker"]),
		.library(name: "SwiftChecker", targets: ["SwiftChecker"]),
	],
	targets: [
		.target(name: "SwiftAST", path: "SwiftAST"),
		.target(name: "SwiftChecker", dependencies: ["SwiftAST"]),
		.testTarget(
			name: "SwiftCheckerTests",
			dependencies: ["SwiftChecker"]
		)
	]
)