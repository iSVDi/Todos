import Foundation
import Moya

enum TodoDataFetcher {
    case getAllTodos
}

extension TodoDataFetcher: TargetType {
    var baseURL: URL {
        return URL(string: "https://dummyjson.com/todos")!
    }
    
    var path: String {
        ""
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        .requestPlain
    }
    
    var headers: [String : String]? {
        [:]
    }
        
}
