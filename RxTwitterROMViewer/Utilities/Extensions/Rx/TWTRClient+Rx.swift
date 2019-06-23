//
//  TWTRClient+Rx.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/22.
//  Copyright © 2019 murawaki. All rights reserved.
//

import RxCocoa
import RxSwift

import TwitterKit

extension Reactive where Base: TWTRAPIClient {
    
    public enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    public func request(url: URL, method: Method = .get, params: [String: Any]? = [:]) -> Single<Data?> {
        var error: NSError? = nil
        
        let request = base.urlRequest(withMethod: method.rawValue,
                        urlString: url.absoluteString,
                        parameters: params,
                        error: &error)
        
        return Single<Data?>.create { observer in
            self.base.sendTwitterRequest(request) { (_, data, connectionError) in
                if let error = error {
                    observer(.error(error))
                }
                
                if let connectionError = connectionError {
                    observer(.error(connectionError))
                }
                
                observer(.success(data))
            }
            
            return Disposables.create()
        }
    }
}
