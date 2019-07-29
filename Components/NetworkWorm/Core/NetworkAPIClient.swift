//
//  NetworkAPIClient.swift
//  SwiftTrader
//
//  Created by Lobanov Dmitry on 23.02.17.
//  Copyright © 2017 OpenSourceIO. All rights reserved.
//

import Foundation

//public class SomeM {
//    func any() {
//        let command = Command()
//
//
//        let a = APIClient(configuration: nil)
//        
//        let c = EndPoints.Items.SignOut.Pair().findCommand(command: EndPoints.Items.SignOut.Command()) { (item) in
//            
//        }
//        
//        let d = EndPoints.Items.SignOut.Pair().command(onSetup: { () -> (EndPoints.Items.SignOut.Command) in
//            var item = EndPoints.Items.SignOut.Command()
//            return item
//        }) { (item) in
//            // result
//        }
//        
////        let b = EndPoints.SignIn().findCommand(command: CommandLogin()) { (response) in
////            switch response {
////            case .result(let r): return
////            case .error(let e): return
////            }
////        }
////        a.executePair(b.0, b.1)
////        a.executeCommand(command: b.0, onResponse: b.1)
////        a.executeCommand(command: CommandLogin()) { (t) in
////        }
//    }
//}

public class APIClient {
    public init(configuration: Configuration?) {
        self.configuration = configuration
        self.reachabilityManager = ReachabilityManager(host: configuration?.serverAddress ?? "")
    }
    
    public func update(configuration: Configuration?) {
        self.configuration = configuration
        self.reachabilityManager = ReachabilityManager(host: configuration?.serverAddress ?? "")
    }
    
    public private(set) var configuration: Configuration?
    public private(set) var reachabilityManager: ReachabilityManager?
    lazy var session = URLSessionWrapper()
}

public typealias CommandPair<C,R> = (C, (ResponseResult<R>) -> ()) where R: SuccessResponse

public class Router<C,R> where C: Command, R: SuccessResponse {
    public init() {}
    public func findCommand(command: C, onResponse: @escaping (ResponseResult<R>) -> ()) -> CommandPair<C, R> {
        return (command, onResponse)
    }
    public func command(onSetup:() -> (C), onResponse: @escaping (ResponseResult<R>) -> ()) -> CommandPair<C, R> {
        return (onSetup(), onResponse)
    }
}

// MARK: URL manipulation.
extension APIClient {
    func URLComponents(strings: String ...) -> String {
        return strings.joined(separator: "/")
    }
    
    func fullURL(scheme: String, path: String) -> String {
        let theScheme = scheme + ":/"
        return URLComponents(strings: theScheme, self.configuration?.serverAddress ?? "", path)
    }
}

// MARK: URLRequest manipulation.
extension APIClient {
    func createUrlRequest(method: HTTPMethod, url: URL, parameters: [String : AnyObject]?, serializer: RequestSerializerProtocol = RequestSerializer.URLEncodedRequest()) -> URLRequest? {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        guard let updatedRequest = try? serializer.serialize(parameters: parameters, urlRequest: urlRequest) else {
            return nil
        }
        
        return updatedRequest
    }
    
    func createRequest(command: Command) {
        
    }
}

// MARK: Execute command.
extension APIClient {
    // add pair later.
    // I need not a command but a command pair with appropriate response type.
    public func executePair<C, R>(pair: CommandPair<C, R>) where C: Command, R: SuccessResponse {
        DispatchQueue.global().async {
            self.executeCommand(command: pair.0, onResponse: pair.1)
        }
    }
    public func executeCommand<C, R>(command: C, onResponse: @escaping (ResponseResult<R>) -> ()) where C: Command, R: SuccessResponse {
//        command.configuration = self.configuration
        let method = command.method
        let path = command.path
        let parameters = command.queryParameters()
        let scheme = command.scheme
        let requestSerialization = command.requestSerialization
        if let error = command.shouldStopError {
            onResponse(.error(ErrorResponse(error: error)))
            return
        }
        
        guard let url = URL(string: fullURL(scheme: scheme, path: path)) else {
            // error? malformed url string.
            return
        }
        
        let urlRequest = self.createUrlRequest(method: method, url: url, parameters: parameters, serializer: requestSerialization.serializer)
        
        if let resultRequest = self.configuration?.headersProvider?.updatedByHeaders(request: urlRequest, by: command) {
            let responseSerializer = ResponseSerialization.JSON.serializer
            self.execute(command: command, urlRequest: resultRequest, responseSerializer: responseSerializer, onResponse: onResponse)
        }
    }
    
    public func execute<C, R>(command: C, urlRequest: URLRequest?, responseSerializer: ResponseSerializerProtocol, onResponse: @escaping (ResponseResult<R>) -> ()) where C: Command, R: SuccessResponse {
        guard let request = urlRequest else {
            // maybe tell about error.
            onResponse(.error(ErrorResponse(error: ErrorFactory.createError(errorType: .invalidRequest)!)))
            return
        }
        
        guard let task = self.session.createTask(type: .data, request: request, completion: { (triplet) in
            
            // add correct mapping later.
            switch triplet {
            case .success(_, let data):
                let result = ResponseAnalyzer<R>().analyze(response: data, context: nil, error: nil, responseSerializer: responseSerializer)
                onResponse(result)
            case .error(_, let error):
                let result = ResponseAnalyzer<R>().analyze(response: nil, context: nil, error: error, responseSerializer: responseSerializer)
                onResponse(result)
            }
        }) else {
            // maybe tell about error.
            onResponse(.error(ErrorResponse(error: ErrorFactory.createError(errorType: .invalidTask)!)))
            return
        }
        
        print("urlRequest: \(String(describing: urlRequest))")
        print("urlRequest: \(String(describing: command.queryParameters()))")
        print("urlRequest: \(String(describing: urlRequest.debugDescription))")
        self.session.addTask(task: task)
    }
}

// MARK: Download item at URL.
extension APIClient {
    public func downloadAtUrl(url: URL?, onResponse: @escaping URLSessionWrapper.TaskCompletion) -> CancellationToken? {
        if let theUrl = url {
            guard let request = self.createUrlRequest(method: .get, url: theUrl, parameters: nil) else {
                let error = ErrorFactory.createError(errorType: .invalidRequest)
                onResponse(.error(nil, error))
                return nil
            }
            
            guard let task = self.session.createTask(type: .download, request: request, completion: { (triplet) in
                onResponse(triplet)
            }) else {
                let error = ErrorFactory.createError(errorType: .invalidTask)
                onResponse(.error(nil, error))
                return nil
            }
            self.session.addTask(task: task)
            return task
        }
        return nil
    }
}

// MARK: Tasks Management
extension APIClient {
    public func cancelAllTasks() {
        self.session.cancelAllTasks()
    }
}

// MARK: Cleanup
extension APIClient {
    public func cleanup() {
        self.cancelAllTasks()
        self.session.urlSession.invalidateAndCancel()
    }
}
