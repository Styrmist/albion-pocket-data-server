//
//  File.swift
//  
//
//  Created by Kirill on 24.09.2020.
//

import Foundation

enum NetworkEnvironment {
    case production
    case staging
}

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "Could not decode the response."
    case noNetworkConnection = "Check network connection."
}

enum Result<String>{
    case success
    case failure(String)
}

struct NetworkManager {
    static let environment : NetworkEnvironment = .production
    let router = Router<GithubApi>()
    //case .lastCommit(let user, let repository, let filePath):
    func getLastCommit(user: String, repository: String, filePath: String, completion: @escaping (_ commit: Date?,_ error: String?)->()){
        router.request(.lastCommit(user: user, repository: repository, filePath: filePath)) { data, response, error in
            if error != nil {
                PackageLogger.warning(NetworkResponse.noNetworkConnection.rawValue)
                completion(nil, NetworkResponse.noNetworkConnection.rawValue)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        PackageLogger.warning(NetworkResponse.noData.rawValue)
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        PackageLogger.trace(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        PackageLogger.trace(jsonData)
                        let apiResponse = try JSONDecoder().decode(CommitElement.self, from: responseData)
                        completion(apiResponse.commit?.author?.date, nil)
                    }catch {
                        PackageLogger.warning(NetworkResponse.unableToDecode.rawValue)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    PackageLogger.warning(networkFailureError)
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
