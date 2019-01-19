extension InletCustomer {
    
    public typealias StructuredName = (
        salutation: String,
        firstName: String,
        middleName: String,
        lastName: String,
        suffix: String
    )
    
    var structuredName: StructuredName? {
        switch self {
        // WFTB4ANPHZIP
        case .WFTEST111518A: return nil /* no name */
        case .WFTEST111518B: return nil /* no name */
        case .WFTEST111518C: return nil /* no name */
        case .WFTEST111518D: return nil /* no name */
        case .WFTEST111518E: return nil /* no name */
        case .WFTEST011019A: return nil /* no name */
            
        // WFTB2SNEMPH
        case .WFTEST111518F: return ("", "Wfone", "", "Lastone", "")
        case .WFTEST111518G: return ("", "Wftwo", "", "Lasttwo", "")
        case .WFTEST111518H: return ("", "Wfthree", "", "Lastthree", "")
        case .WFTEST111518I: return ("", "Wffour", "", "Lastfour", "")
        case .WFTEST111518J: return ("", "Wffive", "", "Lastfive", "")
        case .WFTEST011019B: return ("", "Fmultiple", "", "Lmultiple", "")
            
        // WFTB3SNEMZIP
        case .WFTEST111518K: return ("", "Wfsix", "", "Lastsix", "")
        case .WFTEST111518L: return ("", "Wfseven", "", "Lastseven", "")
        case .WFTEST111518M: return ("", "Wfeight", "", "Lasteight", "")
        case .WFTEST111518N: return ("", "Wfnine", "", "Lastnine", "")
        case .WFTEST111518P: return ("", "Wften", "", "Lastten", "")
        case .WFTEST011019C: return ("", "Fmultiple", "", "Lmultiple", "")
            
        // WFTB4ANPHZIP
        case .WFTEST111518Q: return nil /* no s. name */
        case .WFTEST111518R: return nil /* no s. name */
        case .WFTEST111518S: return nil /* no s. name */
        case .WFTEST111518T: return nil /* no s. name */
        case .WFTEST111518U: return nil /* no s. name */
        case .WFTEST011019D: return nil /* no s. name */
        }
    }
}
