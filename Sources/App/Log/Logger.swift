//
//  File.swift
//  
//
//  Created by Kirill on 24.09.2020.
//

import Foundation
import Logging

//TODO: Split loggers by modules
/*
 Source vs Label
 A Logger carries an (immutable) label and each log message carries a source parameter (since SwiftLog 1.3.0).
 The Logger's label identifies the creator of the Logger. If you are using structured logging by preserving
 metadata across multiple modules, the Logger's label is not a good way to identify where a log message
 originated from as it identifies the creator of a Logger which is often passed around between libraries
 to preserve metadata and the like.

 If you want to filter all log messages originating from a certain subsystem, filter by source which
 defaults to the module that is emitting the log message.
 */

public final class PackageLogger {
    
    private static let logger = Logger(label: "APDServer.default")
    
//    LoggingSystem.bootstrap { label in
//        let webhookURL = URL(string:
//            ProcessInfo.processInfo.environment["SLACK_LOGGING_WEBHOOK_URL"]!
//        )!
//        var slackHandler = SlackLogHandler(label: label, webhookURL: webhookURL)
//        slackHandler.logLevel = .critical
//
//        let syslogHandler = SyslogLogHandler(label: label)
//
//        return MultiplexLogHandler([
//            syslogHandler,
//            slackHandler
//        ])
//    }
    
    @inlinable
    static func trace(_ message: String) {
        logger.trace(message)
    }
    
    @inlinable
    static func debug(_ message: String) {
        logger.debug(message)
    }
    
    @inlinable
    static func info(_ message: String) {
        logger.info(message)
    }
    
    @inlinable
    static func notice(_ message: String) {
        logger.notice(message)
    }
    
    @inlinable
    static func warning(_ message: String) {
        logger.warning(message)
    }
    
    @inlinable
    static func error(_ message: String) {
        logger.error(message)
    }
    
    @inlinable
    static func critical(_ message: String) {
        logger.critical(message)
    }
}
