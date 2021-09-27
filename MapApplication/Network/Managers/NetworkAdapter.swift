//
//  NetworkAdapter.swift
//  MapApplication
//
//  Created by Akbar on 27/09/21.
//

import Foundation
import Moya
import RxSwift
import Alamofire
struct NetworkAdapter<T: TargetType,K: APIData> {
    
    
    init(disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
    }
    private let disposeBag: DisposeBag!
    
    private let provider: MoyaProvider<T> = MoyaProvider<T>( plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(), output: NetworkLoggerPlugin.Configuration.defaultOutput(target:items:), logOptions: .verbose))])
    
    func request(target: T, onComplete onCompleteCallback: @escaping (APIResponse<K>) -> Void){
        
        provider.rx.request(target)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { response in
              
                var result: K? = nil
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                do {
                    result = try decoder.decode(K?.self, from: response.data)
                } catch DecodingError.dataCorrupted(let context) {
                    onCompleteCallback(.failure(ErrorResponse(reason: context.debugDescription, statusCode: 600, code: result?.meta?.code)))
                    print(context.debugDescription)
                } catch DecodingError.keyNotFound(let key, let context) {
                    onCompleteCallback(.failure(ErrorResponse(reason: "\(key.stringValue) was not found, \(context.debugDescription)", statusCode: 600, code: result?.meta?.code)))
                    print("\(key.stringValue) was not found, \(context.debugDescription)")
                } catch DecodingError.typeMismatch(let type, let context) {
                    onCompleteCallback(.failure(ErrorResponse(reason: "\(type) was expected, \(context.debugDescription) \n In: \(target.path) \n Path: \(context.codingPath)", statusCode: 600,code: result?.meta?.code)))
                    print("\(type) was expected, \(context.debugDescription)")
                    
                } catch DecodingError.valueNotFound(let type, let context) {
                    onCompleteCallback(.failure(ErrorResponse(reason: "no value was found for \(type), \(context.debugDescription)", statusCode: 600, code: result?.meta?.code)))
                    print("no value was found for \(type), \(context.debugDescription)")
                } catch (let error) {
                    onCompleteCallback(.failure(ErrorResponse(reason: "I don't know this error: \(error.localizedDescription)", statusCode: 600,code: result?.meta?.code)))
                    print("I don't know this error: \(error.localizedDescription)")
                }
                
                guard let model = result else { return }
                
                if model.meta?.code == 200 {
                    onCompleteCallback(.success(model))
                } else {
                    onCompleteCallback(.failure(ErrorResponse(reason: model.meta?.requestId, statusCode: response.statusCode,code: model.meta?.code)))
                }
            }, onError: { (error) in
                
                print(error)
                
            })
    }
}
