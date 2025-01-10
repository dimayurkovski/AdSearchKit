//
//  AdSearchKit.swift
//
//
//  Created by Dmitry Yurkovski on 11/13/24.
//  Copyright © 2024 Dmitry Yurkovski. All rights reserved.
//

import AdServices

// MARK: - AdSearchKit

/**
 * A utility for interacting with the AdServices API to retrieve attribution information.
 *
 * AdSearchKit provides a streamlined interface to the Apple Ads Attribution API, enabling developers
 * to retrieve campaign attribution data related to app downloads or redownloads originating from Apple’s platforms.
 * This utility simplifies interaction with the AdServices API by managing network requests and handling responses
 * in a way that is compatible with iOS 14.3+, iPadOS 14.3+, macOS 11.1+, Mac Catalyst 14.3+, and visionOS 1.0+.
 *
 * Key Functionality:
 * - Sends a request to Apple's attribution server through the AdServices API using an attribution token.
 * - Processes the response and returns structured attribution data, including campaign and ad-related metadata.
 * - Handles possible errors, such as invalid tokens or unsuccessful requests, and returns them to the caller for
 *   handling.
 *
 * Attribution Use Cases:
 * - AdSearchKit can be used to measure the effectiveness of specific Apple Search Ads campaigns by
 *   retrieving data like campaign ID, ad group ID, and keyword ID.
 * - This data allows app marketers to assess their campaigns' performance and make informed marketing decisions.
 *
 * Server-Side Integration Option:
 * - This kit can be integrated into applications that utilize a Mobile Measurement Provider (MMP) for enhanced
 *   tracking and reporting capabilities. Developers may also choose to directly analyze attribution data for
 *   customized reporting.
 *
 * Documentation:
 * For more information, refer to the Apple documentation on AdServices:
 * [AdServices Documentation](https://developer.apple.com/documentation/adservices)
 *
 * Usage:
 * - Call the `attribution` method and pass a completion handler to receive attribution data or error details
 *   based on the API's response.
 * - Ensure the device is running iOS 14.3+ or the required minimum OS versions to support the AdServices API.
 */
public enum AdSearch {
    
    /**
     * The current version of the AdSearchKit framework.
     *
     * This static constant indicates the version of the framework, which helps in tracking updates
     * and ensuring compatibility across different implementations. This value can be used for
     * logging, debugging, or display purposes to indicate which version of AdSearchKit
     * is in use.
     *
     * - Example: To log the framework version, use `AdSearchKit.version`.
     */
    public static let version = "1.0.1"
}


// MARK: - Attribution

public extension AdSearch {
    
    /**
     * Fetches attribution data from the AdServices API.
     *
     * This method sends a POST request to the AdServices API using an attribution token and retrieves campaign
     * attribution data associated with Apple Search Ads. The attribution token is valid for 24 hours (TTL) from the
     * time it is generated. The token should be sent in the request body as plain text, and the request header should
     * specify a content type of `text/plain`. Only a single token should be included in the request body.
     *
     * The response includes an attribution record as a dictionary of key-value pairs. This dictionary contains detailed
     * information about the attribution data, such as campaign ID, ad group ID, and keyword ID. These details allow
     * app marketers to connect downloads and redownloads with specific Apple Search Ads campaigns.
     *
     * Example Request Format:
     * ```
     * POST https://api-adservices.apple.com/api/v1/
     * --header 'Content-Type: text/plain'
     * --data-raw 'YOUR_ATTRIBUTION_TOKEN'
     * ```
     *
     * Example Response Payload:
     * ```
     * {
     *   "attribution": true,
     *   "orgId": 40669820,
     *   "campaignId": 542370539,
     *   "conversionType": "Download",
     *   "clickDate": "2020-04-08T17:17Z",
     *   "claimType": "Click",
     *   "adGroupId": 542317095,
     *   "countryOrRegion": "US",
     *   "keywordId": 87675432,
     *   "adId": 542317136
     * }
     * ```
     *
     * - Parameter completion: A closure that returns a `Result` with either the `Attribution` data on success
     *                         or an error on failure.
     *
     * - Note: The request will fail if the attribution token is invalid, expired, or if the URL is incorrect. The
     *         response must match the expected format, and developers should ensure that tokens are used within
     *         their 24-hour TTL to maintain validity.
     *
     * For more information, refer to the Apple documentation on [AAAttribution.attributionToken()](https://developer.apple.com/documentation/adservices/aaattribution/attributiontoken#Attribution-payload-descriptions).
     */
    static func attribution(_ completion: @escaping AdSearchCompletion) {
        guard let token = attributionToken() else {
            completion(.failure(AdSearchError.invalidToken))
            return
        }
        
        guard  let url = URL(string: "https://api-adservices.apple.com/api/v1") else {
            completion(.failure(AdSearchError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 120)
        request.httpMethod = "POST"
        request.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = token.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
            } else {
                if let data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let value = try? JSONDecoder().decode(Attribution.self, from: data) {
                    
                    completion(.success(value))
                } else {
                    completion(.failure(AdSearchError.invalidResponse))
                }
            }
        }
        
        task.resume()
    }
}

// MARK: - Type Aliases

/**
 * A closure type that returns the result of the attribution fetch.
 *
 * This closure returns either:
 * - `.success` with `Attribution` data when the attribution fetch succeeds.
 * - `.failure` with an error when the attribution fetch fails.
 */
public typealias AdSearchCompletion = ((Result<AdSearch.Attribution, Error>) -> Void)

// MARK: - Errors

public extension AdSearch {
    
    /**
     * Enum to represent potential errors that can occur during the attribution process.
     *
     * This enum provides different error types:
     * - `invalidToken`: The attribution token is invalid or could not be retrieved.
     * - `invalidUrl`: The URL for the API is invalid.
     * - `invalidResponse`: The response from the API is invalid or could not be parsed.
     */
    enum AdSearchError: Error {
        case invalidToken
        case invalidUrl
        case invalidResponse
    }
}

// MARK: - Attribution Model

public extension AdSearch {
    
    /**
     * A struct representing the data returned from the AdServices attribution API.
     *
     * This struct contains information about the attribution result, including:
     * - `attribution`: A boolean indicating whether the attribution was successful.
     * - `orgId`: The organization ID associated with the attribution.
     * - `campaignId`: The campaign ID associated with the attribution.
     * - `conversionType`: The type of conversion for the attribution.
     * - `claimType`: The type of claim associated with the attribution.
     * - `clickDate`: The date when the ad was clicked.
     * - `adGroupId`: The ad group ID associated with the attribution.
     * - `countryOrRegion`: The country or region where the attribution occurred.
     * - `keywordId`: The keyword ID associated with the attribution.
     * - `adId`: The ad ID associated with the attribution.
     *
     * - Note: The default value for the `orgId` is `sandboxOrgId`, which is set to `1234567890` by default.
     *         This ID is typically used in sandbox or testing environments to allow developers to interact with the framework
     *         without needing a real organization identifier.
     */
    struct Attribution: Codable {
        public let attribution: Bool
        public let orgId: Int?
        public let campaignId: Int?
        public let conversionType: String?
        public let claimType: String?
        public let clickDate: String?
        public let adGroupId: Int?
        public let countryOrRegion: String?
        public let keywordId: Int?
        public let adId: Int?
    }
}

// MARK: - Sandbox Identifier


public extension AdSearch.Attribution {
    
    /**
     * Default sandbox organization ID for testing purposes.
     *
     * This identifier allows developers to test their attribution implementation without needing a live
     * organization ID. It simplifies testing by simulating attribution data in sandbox mode.
     */
    static let sandboxOrgId = 1234567890
    
    /**
     * A computed property indicating if the current `orgId` corresponds to the sandbox mode.
     *
     * Returns `true` if the `orgId` is equal to the `sandboxOrgId`, allowing the framework to identify
     * when it operates in a testing environment.
     */
    var isSandbox: Bool {
        orgId == Self.sandboxOrgId
    }
}

// MARK: - Helper Methods

public extension AdSearch {
    
    /**
     * Retrieves the attribution token for iOS 14.3 and later versions.
     *
     * This method fetches the attribution token using `AAAttribution` if the device is running iOS 14.3 or later.
     * If the device is running an earlier version of iOS, it returns `nil`.
     *
     * - Returns: The attribution token if available, otherwise `nil`.
     *
     * - Note: This method is only available on devices running iOS 14.3 or later.
     */
    static func attributionToken() -> String? {
        guard #available(iOS 14.3, macOS 11.1, *) else {
            return nil
        }
        return try? AAAttribution.attributionToken()
    }
}
