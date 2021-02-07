//
//  File.swift
//  
//
//  Created by Kirill on 24.09.2020.
//

public enum NetworkError : String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}
