//
//  File.swift
//  
//
//  Created by Kirill on 24.09.2020.
//

import Foundation

public enum GithubApi {
    case lastCommit(user: String, repository: String, filePath: String)
}

extension GithubApi: EndPointType {
    
    var environmentBaseURL : String {
        return "https://api.github.com/repos/"
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .lastCommit(let user, let repository, let filePath):
            return "\(user)/\(repository)/commits?path=\(filePath)&page=1&per_page=1"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
//        case .new(let page):
//            return .requestParameters(bodyParameters: nil,
//                                      bodyEncoding: .urlEncoding,
//                                      urlParameters: ["page":page,
//                                                      "api_key":NetworkManager.MovieAPIKey])
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
