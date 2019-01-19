extension InletCustomer {
    
    public typealias PhoneNumber = (
        countryCode: Int,
        number: Int64
    )
    
    var phoneNumber: PhoneNumber? {
        switch self {
        // WFTB4ANPHZIP
        case .WFTEST111518A: return (1, 4515551111)
        case .WFTEST111518B: return (1, 4515552222)
        case .WFTEST111518C: return (1, 4515553333)
        case .WFTEST111518D: return (1, 4515554444)
        case .WFTEST111518E: return (1, 4515555555)
        case .WFTEST011019A: return (1, 5555555555)
            
        // WFTB2SNEMPH
        case .WFTEST111518F: return (1, 4512221111)
        case .WFTEST111518G: return (1, 4512222222)
        case .WFTEST111518H: return (1, 4512223333)
        case .WFTEST111518I: return (1, 4512224444)
        case .WFTEST111518J: return (1, 4512225555)
        case .WFTEST011019B: return (1, 5555555555)
            
        // WFTB3SNEMZIP
        case .WFTEST111518K: return nil /* no phone */
        case .WFTEST111518L: return nil /* no phone */
        case .WFTEST111518M: return nil /* no phone */
        case .WFTEST111518N: return nil /* no phone */
        case .WFTEST111518P: return nil /* no phone */
        case .WFTEST011019C: return nil /* no phone */
            
        // WFTB4ANPHZIP
        case .WFTEST111518Q: return (1, 4153331111)
        case .WFTEST111518R: return (1, 4153332222)
        case .WFTEST111518S: return (1, 4153333333)
        case .WFTEST111518T: return (1, 4153334444)
        case .WFTEST111518U: return (1, 4153335555)
        case .WFTEST011019D: return (1, 5555555555)
        }
    }
}
