//
//  DiscoveryConsent.swift
//  Inletclient
//
//  Created by Gee C on 1/9/19.
//

import UIKit

public struct DiscoveryConsents: Codable {
    public struct Consents: Codable {
        public var consentId: String?
    }
    public var consents: [Consents]?
}
