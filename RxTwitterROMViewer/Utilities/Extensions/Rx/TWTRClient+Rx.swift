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
    
    public func request(url: URL, method: String, params: [String: String]? = [:]) -> Single<Data?> {
        var error: NSError? = nil
        
        let request = base.urlRequest(withMethod: method,
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
