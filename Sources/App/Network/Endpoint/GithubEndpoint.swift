//
//  File.swift
//  
//
//  Created by Kirill on 24.09.2020.
//

import Foundation

public enum GithubApi {
    case lastCommit(gitPath: GithubPath)
    case getFileContent(gitPath: GithubPath)
}

extension GithubApi: EndPointType {
    
    var baseURLString : String {
        switch self {
            case .lastCommit:
                return "https://api.github.com/repos/"
            case .getFileContent:
                return "https://raw.githubusercontent.com/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: baseURLString) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .lastCommit(let gitPath):
            return "\(gitPath.user)/\(gitPath.repo)/commits?path=\(gitPath.path)&page=1&per_page=1"
        case .getFileContent(let gitPath):
            return "\(gitPath.user)/\(gitPath.repo)/\(gitPath.path)"
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
