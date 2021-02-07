//
//  File.swift
//  
//
//  Created by Kirill on 24.09.2020.
//

import Foundation

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

    let router = Router<GithubApi>()

    func getLastCommit(gitPath: GithubPath, completion: @escaping (_ commit: Date?,_ error: String?)->()){
        router.request(.lastCommit(gitPath: gitPath)) { data, response, error in
            if error != nil {
                completion(nil, NetworkResponse.noNetworkConnection.rawValue)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(CommitElement.self, from: responseData)
                        completion(apiResponse.commit?.author?.date, nil)
                    }catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }

    func getFileContent(gitPath: GithubPath, completion: @escaping (_ items: [GitItem]?,_ error: String?)->()){
        router.request(.getFileContent(gitPath: gitPath)) { data, response, error in
            if error != nil {
                completion(nil, NetworkResponse.noNetworkConnection.rawValue)
            }

            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(nil, NetworkResponse.noData.rawValue)
                            return
                        }
                        do {
                            let gitItems = try JSONDecoder().decode([GitItem].self, from: responseData)
                            completion(gitItems, nil)
                        }catch {
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                        }
                    case .failure(let networkFailureError):
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
