//
//  Logger.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 04/12/24.
//

import Foundation

/// Enum for Logger type
enum LogType: Int {
    case kNormal = 1
    case kImportant = 2
}

/// class for Logger
final class Logger {
    /// logger is enabled or not
    var isLogEnabled: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    /// shared logger
    class var sharedLogger: Logger {
        struct DefaultSingleton {
            static let loggerInstance = Logger()
        }
        return DefaultSingleton.loggerInstance
    }
    
    /// Print Object
    /// - Parameters:
    ///   - logString: Any kind of object
    ///   - logType: Log Type
    class func log(_ logString: Any, logType: LogType? = .kNormal) {
        if Logger.sharedLogger.isLogEnabled == false && logType != .kImportant {
            return
        } else {
            print(Logger.sharedLogger.isLogEnabled ? "\nNewsApp Log\n\(logString)\n" : "")
        }
    }
    
    /// Use for printing API response
    /// - Parameters:
    ///   - logData: Data
    ///   - url: Url string
    ///   - code: Http Status code
    ///   - logType: Log Type
    class func logResponse(_ logData: Data,
                           url: Any,
                           code: Any,
                           logType: LogType? = .kNormal) {
        if Logger.sharedLogger.isLogEnabled == false && logType != .kImportant {
            return
        } else {
            do {
                let response = try JSONSerialization.jsonObject(with: logData, options: .mutableContainers)
                print(Logger.sharedLogger.isLogEnabled ? "\nNewsApp Log\nUrl:\(url)\nResponse:\n\(response)\nStatusCode:\(code)\n" : "")
            } catch let error {
                print(Logger.sharedLogger.isLogEnabled ? "\nNewsApp Log\nUrl:\(url)\nError:\(error.localizedDescription)\nStatusCode:\(code)\n" : "")
            }
        }
    }
    
    /// curl log
    /// - Parameters:
    ///   - request: URL Request
    ///   - logType: Log Type
    static func log(curl request: URLRequest,
                    logType: LogType? = .kNormal) {
        if Logger.sharedLogger.isLogEnabled == false && logType != .kImportant {
            return
        } else {
            print("\n - - - - - - - - - - OUTGOING CURL - - - - - - - - - - \n")
            defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
            
            guard let url = request.url else { return }
            var baseCommand = #"curl "\#(url.absoluteString)""#

            if request.httpMethod == "HEAD" {
                baseCommand += " --head"
            }

            var command = [baseCommand]

            if let method = request.httpMethod, method != "GET" && method != "HEAD" {
                command.append("-X \(method)")
            }

            if let headers = request.allHTTPHeaderFields {
                for (key, value) in headers where key != "Cookie" {
                    command.append("-H '\(key): \(value)'")
                }
            }

            if let data = request.httpBody, let body = String(data: data, encoding: .utf8) {
                command.append("-d '\(body)'")
            }

            print(command.joined(separator: " \\\n\t"))
        }
    }
}
