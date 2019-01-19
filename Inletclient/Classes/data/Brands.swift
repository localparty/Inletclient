extension InletCustomer {
   
    public enum InletBrand: String, CaseIterable  {
        // the inlet brand cases are based on their 'brand names'
        case
        WFTB1EMPHZIP, WFTB2SNEMPH, WFTB3SNEMZIP, WFTB4ANPHZIP
        
        public typealias AttributesTuple = (
            id: String,
            name: String,
            connectionParametersDescription: String,
            sourceSystemId: String,
            sourceSystemBrandId: String
        )
        
        public var attributes: AttributesTuple {
            switch self {
            case .WFTB1EMPHZIP: return (
                /* brand id */
                "BB:10000001203",
                /* brand name */
                "Xcel_POC, WFTB1EMPHZIP",
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
                "ConEd, WFTB2SNEMPH",
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
                "Spring_POC, WFTB3SNEMZIP",
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
                "AT&T_POC, WFTB4ANPHZIP",
                /* connection parameters description */
                "Brand ID, Phone, Zip",
                /* source system id */
                "INLETDIRECT",
                /*source system brand id */
                "WFTB4ANPHZIP"
                )
            }
        }
    }
    
    public var brand: InletBrand {
        switch self {
        // WFTB4ANPHZIP
        case .WFTEST111518A: return .WFTB1EMPHZIP
        case .WFTEST111518B: return .WFTB1EMPHZIP
        case .WFTEST111518C: return .WFTB1EMPHZIP
        case .WFTEST111518D: return .WFTB1EMPHZIP
        case .WFTEST111518E: return .WFTB1EMPHZIP
        case .WFTEST011019A: return .WFTB1EMPHZIP
            
        // WFTB2SNEMPH
        case .WFTEST111518F: return .WFTB2SNEMPH
        case .WFTEST111518G: return .WFTB2SNEMPH
        case .WFTEST111518H: return .WFTB2SNEMPH
        case .WFTEST111518I: return .WFTB2SNEMPH
        case .WFTEST111518J: return .WFTB2SNEMPH
        case .WFTEST011019B: return .WFTB2SNEMPH
            
        // WFTB3SNEMZIP
        case .WFTEST111518K: return .WFTB3SNEMZIP
        case .WFTEST111518L: return .WFTB3SNEMZIP
        case .WFTEST111518M: return .WFTB3SNEMZIP
        case .WFTEST111518N: return .WFTB3SNEMZIP
        case .WFTEST111518P: return .WFTB3SNEMZIP
        case .WFTEST011019C: return .WFTB3SNEMZIP
            
        // WFTB4ANPHZIP
        case .WFTEST111518Q: return .WFTB4ANPHZIP
        case .WFTEST111518R: return .WFTB4ANPHZIP
        case .WFTEST111518S: return .WFTB4ANPHZIP
        case .WFTEST111518T: return .WFTB4ANPHZIP
        case .WFTEST111518U: return .WFTB4ANPHZIP
        case .WFTEST011019D: return .WFTB4ANPHZIP
        }
    }
    
}
