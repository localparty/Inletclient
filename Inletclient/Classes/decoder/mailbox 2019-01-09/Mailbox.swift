//
//  Mailbox.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on January 9, 2019

import Foundation

public struct Mailbox : Codable {
    
    public let envelopes : [MailboxEnvelope]?
    public let mailboxId : String?
    
    public enum CodingKeys: String, CodingKey {
        case envelopes = "envelopes"
        case mailboxId = "mailboxId"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        envelopes = try values.decodeIfPresent([MailboxEnvelope].self, forKey: .envelopes)
        mailboxId = try values.decodeIfPresent(String.self, forKey: .mailboxId)
    }
    
}

