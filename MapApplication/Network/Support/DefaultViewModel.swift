//
//  DefaultViewModel.swift
//  MapApplication
//
//  Created by Akbar on 27/09/21.
//

import Foundation
import RxSwift

open class DefaultViewModel: BagDisposable, ErrorContainable {
    public let error: PublishSubject<ErrorResponse> = PublishSubject<ErrorResponse>()
    public let isLoading: PublishSubject<Bool> = PublishSubject<Bool>()
    public let state: Variable<ViewModelState> = Variable(.initializing)
    public let disposeBag: DisposeBag = DisposeBag()
    public let taskCounter: PublishSubject<Int> = PublishSubject<Int>()
    public let taskStarted: PublishSubject<Void> = PublishSubject<Void>()
    public let taskEnded: PublishSubject<Void> = PublishSubject<Void>()
    private var _taskCounter: Int = 0
    
    public let tableReload: AnyObserver<Void>
    public let onTableReload: Observable<Void>
    
    public let forceReloadTable: AnyObserver<Void>
    public let onForceReloadTable: Observable<Void>
    
    public init() {
        
        let tableReloadSubject = PublishSubject<Void>()
        tableReload = tableReloadSubject.asObserver()
        onTableReload = tableReloadSubject.asObservable()
        
        let forceTableReloadSubject = PublishSubject<Void>()
        forceReloadTable = forceTableReloadSubject.asObserver()
        onForceReloadTable = forceTableReloadSubject.asObservable()
        
        taskCounter.startWith(_taskCounter).asObservable().subscribe(onNext: { (count) in
            self._taskCounter = count
            self.isLoading.onNext(count > 0)
        }).disposed(by: self.disposeBag)
        
        taskStarted.asObservable().subscribe(onNext: { _ in
            self._taskCounter += 1
            self.taskCounter.onNext(self._taskCounter)
        }).disposed(by: self.disposeBag)
        
        taskEnded.asObservable().subscribe(onNext: { _ in
            if self._taskCounter > 0 {
                self._taskCounter -= 1
                self.taskCounter.onNext(self._taskCounter)
            }
        }).disposed(by: self.disposeBag)
        
        error.subscribe(onNext: { (_) in
            self.taskEnded.onNext(())
        }).disposed(by: self.disposeBag)
        
        isLoading.asObservable().subscribe(onNext: { (isLoading) in
            self.state.value = isLoading == true ? .loading : .loadComplete
        }).disposed(by: self.disposeBag)
        
        state.value = .ready
        
    }
}
