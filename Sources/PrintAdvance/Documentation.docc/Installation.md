# Installation

How to add PrintAdvance to your project.

## Overview

PrintAdvance supports multiple installation methods to fit your project's needs.

## Swift Package Manager (Recommended)

### Xcode Integration

1. Open your project in Xcode
2. Go to **File** → **Add Package Dependencies...**
3. Enter the repository URL: `https://github.com/inekipelov/swift-print-advance.git`
4. Select the version range or specific version
5. Choose your target and click **Add Package**

### Package.swift

Add PrintAdvance to your `Package.swift` file:

```swift
// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "YourPackage",
    dependencies: [
        .package(
            url: "https://github.com/inekipelov/swift-print-advance.git",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "YourTarget",
            dependencies: ["PrintAdvance"]
        )
    ]
)
```

## Platform Requirements

PrintAdvance supports the following platforms:

- **iOS**: 9.0+
- **macOS**: 10.13+
- **tvOS**: 9.0+
- **watchOS**: 2.0+
- **Swift**: 5.0+

## Import

After installation, import PrintAdvance in your Swift files:

```swift
import PrintAdvance
```

## Verification

Verify the installation by running a simple print command:

```swift
import PrintAdvance

"PrintAdvance is working!".print()
```

You should see the message printed to your console.
