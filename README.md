# AdSearchKit

AdSearchKit is a Swift framework for interacting with Apple's AdServices API to retrieve Apple Search Ads attribution data. This framework allows developers to access valuable campaign information, such as campaign IDs and ad group IDs, helping them track app download sources and analyze campaign performance.

## Features

- **Fetch Attribution Data**: Retrieves attribution data from Apple's AdServices API using an attribution token.
- **Detailed Campaign Insights**: Access campaign, ad group, and keyword IDs for granular attribution analysis.
- **Error Handling**: Handles potential errors, such as invalid tokens or network issues.
- **Sandbox Mode**: Supports sandbox testing with a default `sandboxOrgId`.

## Requirements

- **iOS** 12.0+
- **iPadOS** 12.0+

## Usage

Import the framework:

```swift
import AdSearchKit
```

Use the attribution method to retrieve campaign attribution data:

```swift
AdSearchKit.attribution { attribution in
    switch attribution {
    case .success(let attribution):
        print("Attribution Data: \(attribution)")
    case .failure(let error):
        print("Error: \(error)")
    }
}

```

## Installation

### Swift Package Manager

To install AdSearchKit using Swift Package Manager, add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/dimayurkovski/AdSearchKit.git", from: "1.0.0")
]
```

### CocoaPods

To integrate AdSearchKit with CocoaPods, add the following line to your `Podfile`:

```ruby
pod 'AdSearchKit'
```

## Documentation

For more information, visit the [Apple AdServices Documentation](https://developer.apple.com/documentation/adservices).
