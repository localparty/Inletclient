//
//  DiscoveryConsent.swift
//  Inletclient
//
//  Created by Gee C on 1/9/19.
//

import UIKit

public struct DiscoveryConsents: Codable {
    struct Consents: Codable {
        var consentId: String?
    }
    var consents: [Consents]?
}
