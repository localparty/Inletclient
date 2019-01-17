//
//  InletDataset.swift
//  The swift representation of the data configuration
//  that inlet sponsored for us
//
//  Created by G Costilla on 1/2/19.
//  Copyright © 2019 Wells Fargo. All rights reserved.
//


public let partnerChannelId: String = "CP:0000000149"
public enum InletCustomer: String, CaseIterable {
    
    public enum InletBrand: String, CaseIterable  {
        // the inlet brand cases are based on their 'brand names'
        case
        WFTB1EMPHZIP, WFTB2SNEMPH, WFTB3SNEMZIP, WFTB4ANPHZIP,
        
        // IN-PROGRESS
        Xcel_POC
        
        public typealias InletBrandIds = (
            id: String,
            name: String,
            connectionParametersDescription: String,
            sourceSystemId: String,
            sourceSystemBrandId: String
        )
        
        public var ids: InletBrandIds {
            switch self {
            case .WFTB1EMPHZIP: return (
                /* brand id */
                "BB:10000001203",
                /* brand name */
                "WFTB1EMPHZIP",
                /* connection parameters description */
                "Email, Phone, Zip",
                /* source system id */
                "INLETDIRECT",
                /* source system brand id */
                "IDFSVDE_bidzip"
                )
            case .WFTB2SNEMPH:  return (
                /* brand id */
                "BB:10000002066",
                /* brand name */
                "WFTB2SNEMPH",
                /* connection parameters description */
                "Structured Name, Email, Phone",
                /* source system id */
                "INLETDIRECT",
                /* source system brand id */
                "WFTB2SNEMPH"
                )
            case .WFTB3SNEMZIP: return (
                /* brand id */
                "BB:10000002067",
                /* brand name */
                "WFTB3SNEMZIP",
                /* connection parameters description */
                "Email, Structured Name, Zip",
                /* source system id */
                "INLETDIRECT",
                /* source system brand id */
                "WFTB3SNEMZIP"
                )
            case .WFTB4ANPHZIP: return (
                /* brand id */
                "BB:10000002068",
                /* brand name */
                "WFTB4ANPHZIP",
                /* connection parameters description */
                "Brand ID, Phone, Zip",
                /* source system id */
                "INLETDIRECT",
                /*source system brand id */
                "WFTB4ANPHZIP"
                )
                
            case .Xcel_POC: return (
                /* brand id */
                "BB:10000001203",
                /* brand name */
                "Xcel_POC",
                /* connection parameters description */
                "?",
                /* source system id */
                "?",
                /*source system brand id */
                "?"
                )
            }
        }
    }
    
    case
    
    // WFTB4ANPHZIP
    WFTEST111518A,
    WFTEST111518B,
    WFTEST111518C,
    WFTEST111518D,
    WFTEST111518E,
    
    // WFTB2SNEMPH
    WFTEST111518F,
    WFTEST111518G,
    WFTEST111518H,
    WFTEST111518I,
    WFTEST111518J,
    
    // WFTB3SNEMZIP
    WFTEST111518K,
    WFTEST111518L,
    WFTEST111518M,
    WFTEST111518N,
    WFTEST111518P,
    
    // WFTB4ANPHZIP
    WFTEST111518Q,
    WFTEST111518R,
    WFTEST111518S,
    WFTEST111518T,
    WFTEST111518U,
    
    // this is the only one that works apparently
    WFTEST111918A
    
    
    public typealias StructuredName = (
        salutation: String,
        firstName: String,
        middleName: String,
        lastName: String,
        suffix: String
    )
    
    public typealias IDs = (
        sourceCID: String,
        cimdID: Int
    )
    
    public typealias PhoneNumber = (
        countryCode: Int,
        number: Int64
    )
    
    public typealias BrandConnectionParameters = (
        email: String?,
        phoneNumber: PhoneNumber?,
        zip: Int?,
        structuredName: StructuredName?,
        brandId: String?
    )
    
    public typealias UserData = (
        ids: IDs,
        brandConnectionParameters: BrandConnectionParameters
    )
    
    public var inletBrand: InletBrand {
        switch self {
        // WFTB4ANPHZIP
        case .WFTEST111518A: return .WFTB4ANPHZIP
        case .WFTEST111518B: return .WFTB4ANPHZIP
        case .WFTEST111518C: return .WFTB4ANPHZIP
        case .WFTEST111518D: return .WFTB4ANPHZIP
        case .WFTEST111518E: return .WFTB4ANPHZIP
        // WFTB2SNEMPH
        case .WFTEST111518F: return .WFTB2SNEMPH
        case .WFTEST111518G: return .WFTB2SNEMPH
        case .WFTEST111518H: return .WFTB2SNEMPH
        case .WFTEST111518I: return .WFTB2SNEMPH
        case .WFTEST111518J: return .WFTB2SNEMPH
        // WFTB3SNEMZIP
        case .WFTEST111518K: return .WFTB3SNEMZIP
        case .WFTEST111518L: return .WFTB3SNEMZIP
        case .WFTEST111518M: return .WFTB3SNEMZIP
        case .WFTEST111518N: return .WFTB3SNEMZIP
        case .WFTEST111518P: return .WFTB3SNEMZIP
        // WFTB4ANPHZIP
        case .WFTEST111518Q: return .WFTB4ANPHZIP
        case .WFTEST111518R: return .WFTB4ANPHZIP
        case .WFTEST111518S: return .WFTB4ANPHZIP
        case .WFTEST111518T: return .WFTB4ANPHZIP
        case .WFTEST111518U: return .WFTB4ANPHZIP
            
        // IN-PROGRESS
        case .WFTEST111918A: return .Xcel_POC
        }
    }
    
    public var ids: IDs {
        switch self {
        // WFTB4ANPHZIP
        case .WFTEST111518A: return (
            /* source CID */
            "WFTEST111518A",
            /* cimd id */
            62862692
            )
        case .WFTEST111518B: return (
            /* source CID */
            "WFTEST111518B",
            /* cimd id */
            62862693
            )
        case .WFTEST111518C: return (
            /* source CID */
            "WFTEST111518C",
            /* cimd id */
            62862694
            )
        case .WFTEST111518D: return (
            /* source CID */
            "WFTEST111518D",
            /* cimd id */
            62862695
            )
        case .WFTEST111518E: return (
            /* source CID */
            "WFTEST111518E",
            /* cimd id */
            62862696
            )
        // WFTB2SNEMPH
        case .WFTEST111518F: return (
            /* source CID */
            "WFTEST111518F",
            /* cimd id */
            62862697
            )
        case .WFTEST111518G: return (
            /* source CID */
            "WFTEST111518G",
            /* cimd id */
            62862698
            )
        case .WFTEST111518H: return (
            /* source CID */
            "WFTEST111518H",
            /* cimd id */
            62862699
            )
        case .WFTEST111518I: return (
            /* source CID */
            "WFTEST111518I",
            /* cimd id */
            62862700
            )
        case .WFTEST111518J: return (
            /* source CID */
            "WFTEST111518J",
            /* cimd id */
            62862701
            )
        // WFTB3SNEMZIP
        case .WFTEST111518K: return (
            /* source CID */
            "WFTEST111518K",
            /* cimd id */
            62862702
            )
        case .WFTEST111518L: return (
            /* source CID */
            "WFTEST111518L",
            /* cimd id */
            62862703
            )
        case .WFTEST111518M: return (
            /* source CID */
            "WFTEST111518M",
            /* cimd id */
            62862704
            )
        case .WFTEST111518N: return (
            /* source CID */
            "WFTEST111518N",
            /* cimd id */
            62862705
            )
        case .WFTEST111518P: return (
            /* source CID */
            "WFTEST111518P",
            /* cimd id */
            62862706
            )
        // WFTB4ANPHZIP
        case .WFTEST111518Q: return (
            /* source CID */
            "WFTEST111518Q",
            /* cimd id */
            2862707
            )
        case .WFTEST111518R: return (
            /* source CID */
            "WFTEST111518R",
            /* cim id */
            62862708
            )
        case .WFTEST111518S: return (
            /* source CID */
            "WFTEST111518S",
            /* cim id */
            62862709
            )
        case .WFTEST111518T: return (
            /* source CID */
            "WFTEST111518T",
            /* cim id */
            62862710
            )
        case .WFTEST111518U: return (
            /*. source CID */
            "WFTEST111518U",
            /* cim id */
            62862711
            )
        // IN-PROGRESS
        case .WFTEST111918A: return (
            /*. source CID */
            "WFTEST111918A",
            /* cim id */
            99999999
            )
        }
    }
    
    public var brandConnectionParameters: BrandConnectionParameters {
        // WFTB4ANPHZIP
        switch self {
        case .WFTEST111518A: return (
            /* email */
            "wfuser1@email.com",
            /* phone */
            (1, 4515551111),
            /* zip */
            94016,
            /* structured name */
            nil, /* no name */
            /* brand id */
            nil /* no brand id */
            )
        case .WFTEST111518B: return (
            /* email */
            "wfuser2@email.com",
            /* phone */
            (1, 4515552222),
            /* zip */
            94016,
            /* structured name */
            nil, /* no name */
            /* brand id */
            nil /* no brand id */
            )
        case .WFTEST111518C: return (
            /* email */
            "wfuser3@email.com",
            /* phone */
            (1, 4515553333),
            /* zip */
            94016,
            /* structured name */
            nil, /* no name */
            /* brand id */
            nil /* no brand id */
            )
        case .WFTEST111518D: return (
            /* email */
            "wfuser4@email.com",
            /* phone */
            (1, 4515554444),
            /* zip */
            94016,
            /* structured name */
            nil, /* no name */
            /* brand id */
            nil /* no brand id */
            )
        case .WFTEST111518E: return (
            /* email */
            "wfuser5@email.com",
            /* phone */
            (1, 4515555555),
            /* zip */
            94016,
            /* structured name */
            nil, /* no name */
            /* brand id */
            nil /* no brand id */
            )
        // WFTB2SNEMPH
        case .WFTEST111518F: return (
            /* email */
            "wfuser6@email.com",
            /* phone */
            (1, 4512221111),
            /* zip */
            nil, /* no zip */
            /* structured name */
            ("", "Wfone", "", "Lastone", ""),
            /* brand id */
            nil /* no brand id */ )
        case .WFTEST111518G: return (
            /* email */
            "wfuser7@email.com",
            /* phone */
            (1, 4512222222),
            /* zip */
            nil, /* no zip */
            /* structured name */
            ("", "Wftwo", "", "Lasttwo", ""),
            /* brand id */
            nil /* no brand id */
            )
        case .WFTEST111518H: return (
            /* email */
            "wfuser8@email.com",
            /* phone */
            (1, 4512223333),
            /* zip */
            nil, /* no zip */
            /* structured name */
            ("", "Wfthree", "", "Lastthree", ""),
            /* brand id */
            nil /* no brand id */
            )
        case .WFTEST111518I: return (
            /* email */
            "wfuser9@email.com",
            /* phone */
            (1, 4512224444),
            /* zip */
            nil, /* no zip */
            /* structured name */
            ("", "Wffour", "", "Lastfour", ""),
            /* brand id */
            nil /* no brand id */
            )
        case .WFTEST111518J: return (
            /* email */
            "wfuser10@email.com",
            /* phone */
            (1, 4512225555),
            /* zip */
            nil, /* no zip */
            /* structured name */
            ("", "Wffive", "", "Lastfive", ""),
            /* brand id */
            nil /* no brand id */
            )
        // WFTB3SNEMZIP
        case .WFTEST111518K: return (
            /* email */
            "wfuser11@email.com",
            /* phone */
            nil, /* no phone */
            /* zip */
            94105,
            /* structured name */
            ("", "Wfsix", "", "Lastsix", ""),
            /* brand id */
            nil /* no brand id */
            )
        case .WFTEST111518L: return (
            /* email */
            "wfuser12@email.com",
            /* phone */
            nil, /* no phone */
            /* zip */
            94105,
            /* structured name */
            ("", "Wfseven", "", "Lastseven", ""),
            /* brand id */
            nil /* no brand id */
            )
        case .WFTEST111518M: return (
            /* email */
            "wfuser13@email.com",
            /* phone */
            nil, /* no phone */
            /* zip */
            94105,
            /* structured name */
            ("", "Wfeight", "", "Lasteight", ""),
            /* brand id */
            nil /* no brand id */
            )
        case .WFTEST111518N: return (
            /* email */
            "wfuser14@email.com",
            /* phone */
            nil, /* no phone */
            /* zip */
            94105,
            /* structured name */
            ("", "Wfnine", "", "Lastnine", ""),
            /* brand id */
            nil /* no brand id */
            )
        case .WFTEST111518P: return (
            /* email */
            "wfuser15@email.com",
            /* phone */
            nil, /* no phone */
            /* zip */
            94105,
            /* structured name */
            ("", "Wften", "", "Lastten", ""),
            /* brand id */
            nil /* no brand id */
            )
        // WFTB4ANPHZIP
        case .WFTEST111518Q: return (
            /* email */
            nil, /* no email */
            /* phone */
            (1, 4153331111),
            /* zip */
            94110,
            /* structured name */
            nil, /* no s. name */
            /* brand id */
            "WFTEST111518Q"
            )
        case .WFTEST111518R: return (
            /* email */
            nil, /* no email */
            /* phone */
            (1, 4153332222),
            /* zip */
            94110,
            /* structured name */
            nil, /* no s. name */
            /* brand id */
            "WFTEST111518R"
            )
        case .WFTEST111518S: return (
            /* email */
            nil, /* no email */
            /* phone */
            (1, 4153333333),
            /* zip */
            94110,
            /* structured name */
            nil, /* no s. name */
            /* brand id */
            "WFTEST111518S"
            )
        case .WFTEST111518T: return (
            /* email */
            nil, /* no email */
            /* phone */
            (1, 4153334444),
            /* zip */
            94110,
            /* structured name */
            nil, /* no s. name */
            /* brand id */
            "WFTEST111518T"
            )
        case .WFTEST111518U: return (
            /* email */
            nil, /* no email */
            /* phone */
            (1, 4153335555),
            /* zip */
            94110,
            /* structured name */
            nil, /* no s. name */
            /* brand id */
            "WFTEST111518U"
            )
        case .WFTEST111918A: return (
            /* email */
            "wfuser1@email.com",
            /* phone */
            (1, 4515551111),
            /* zip */
            94016,
            /* structured name */
            nil, /* no s. name */
            /* brand id */
            nil /* no brand id */
            )
            
            
        }
    }
}
