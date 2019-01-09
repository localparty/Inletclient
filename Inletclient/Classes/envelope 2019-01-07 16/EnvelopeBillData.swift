//
//  EnvelopeBillData.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on January 8, 2019

import Foundation

public struct EnvelopeBillData : Codable {
    
    public let accountName : String?
    public let accountNumber : String?
    public let amountDue : String?
    public let currentBalance : String?
    public let date : String?
    public let dueDate : String?
    public let lastPaymentAmount : String?
    public let minimumAmountDue : String?
    public let totalAmountDue : String?
    
    enum CodingKeys: String, CodingKey {
        case accountName = "accountName"
        case accountNumber = "accountNumber"
        case amountDue = "amountDue"
        case currentBalance = "currentBalance"
        case date = "date"
        case dueDate = "dueDate"
        case lastPaymentAmount = "lastPaymentAmount"
        case minimumAmountDue = "minimumAmountDue"
        case totalAmountDue = "totalAmountDue"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accountName = try values.decodeIfPresent(String.self, forKey: .accountName)
        accountNumber = try values.decodeIfPresent(String.self, forKey: .accountNumber)
        amountDue = try values.decodeIfPresent(String.self, forKey: .amountDue)
        currentBalance = try values.decodeIfPresent(String.self, forKey: .currentBalance)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        dueDate = try values.decodeIfPresent(String.self, forKey: .dueDate)
        lastPaymentAmount = try values.decodeIfPresent(String.self, forKey: .lastPaymentAmount)
        minimumAmountDue = try values.decodeIfPresent(String.self, forKey: .minimumAmountDue)
        totalAmountDue = try values.decodeIfPresent(String.self, forKey: .totalAmountDue)
    }
    
}

