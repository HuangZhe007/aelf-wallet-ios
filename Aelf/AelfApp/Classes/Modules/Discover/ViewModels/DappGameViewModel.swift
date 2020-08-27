//
//  DappGameViewModel.swift
//  AelfApp
//
//  Created by 晋先森 on 2019/6/16.
//  Copyright © 2019 AELF. All rights reserved.
//

import Foundation

class DappGameViewModel: ViewModel {
    
}

extension DappGameViewModel: ViewModelType {
    
    struct Input {
        let type: DappGameType
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
    }
    
    struct Output {
        let items = BehaviorRelay<[DiscoverDapp]>(value: [])
    }
    
    func transform(input: DappGameViewModel.Input) -> DappGameViewModel.Output {
        
        let output = Output()
        
        // 头部刷新
        input.headerRefresh.flatMapLatest { [weak self] _ -> Observable<DappList> in
            guard let self = self else { return Observable.just(DappList.init(JSON: [:])!)}
            self.page = 1
            return self.request(type: input.type).trackActivity(self.headerLoading)
        }.subscribe(onNext: { dapp in
            let value = dapp.dapps
            output.items.accept(value)
        }).disposed(by: rx.disposeBag)
        
        input.footerRefresh.flatMapLatest { [weak self] _ -> Observable<DappList> in
            guard let self = self else { return Observable.just(DappList.init(JSON: [:])!)}
            self.page += 1
            return self.request(type: input.type).trackActivity(self.footerLoading)
        }.subscribe(onNext: { dapp in
            let value = dapp.dapps
            output.items.accept(output.items.value + value)
        }).disposed(by: rx.disposeBag)
        
        return output
    }
}

extension DappGameViewModel {
    // req
    func request(type: DappGameType) -> Observable<DappList> {
        return discoverProvider
            .requestData(.gamelist(page: page,
                                   type: type,
                                   coin: nil,
                                   name: nil,
                                   isPopular: false,
                                   isRecommand: nil))
            .trackError(self.error)
            .trackActivity(self.loading)
            .mapObject(DappList.self)
    }
}
