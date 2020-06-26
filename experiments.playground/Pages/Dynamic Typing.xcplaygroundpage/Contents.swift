import Foundation

enum HttpMethod {
    case post
    case put
    case get
    case delete
}

struct Request<T> {
    let method: HttpMethod
}
