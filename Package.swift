// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenAIPlayground",
    platforms: [.macOS(.v10_15)],
    dependencies: [
        .package(url: "https://github.com/MacPaw/OpenAI.git", exact: "0.2.6")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "OpenAIPlayground",
            dependencies: ["OpenAI"],
            resources: [
                .process("Resources/video_transcripts.txt")
            ]
        ),
    ]
)
