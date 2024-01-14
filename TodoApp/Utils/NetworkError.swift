import Foundation


enum NetworkError: Error {
    case emptyResponse
    case invalidResponse
    case unknown(String)
    case decodeError
    
}
