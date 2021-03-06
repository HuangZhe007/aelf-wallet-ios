//
//  DiscoverApi.swift
//  AelfApp
//
//  Created by 晋先森 on 2019/6/10.
//  Copyright © 2019 AELF. All rights reserved.
//

import Foundation
import Moya

let discoverProvider = MoyaProvider<DiscoverAPI>(endpointClosure:MoyaProvider.JSONEndpointMapping,
                                                 manager: BaseConfig.manager,
                                                 plugins: [NetworkLoggerPlugin(verbose: true,
                                                                               responseDataFormatter: BaseConfig.jsonFormatter),
                                                           BaseConfig.networkActivityPlugin])

enum DiscoverAPI {
    case home
    case gamelist(page: Int,cat: String?,coin: String?,name: String?,isPopular: Bool?,isRecommand:Bool?)

}

extension DiscoverAPI: TargetType {

    var baseURL: URL {
        return BaseConfig.BaseURL
    }

    var path: String {

        var path = ""

        switch self {
        case .home:
            path = "app/dapp/index"
        case .gamelist:
            path = "app/dapp/games"
            
        }
        path += "?lang=\(App.languageID ?? "")"
        return path
    }

    var method: Moya.Method {
        switch self {

        default:
            return .post // 默认 post
        }
    }

    var sampleData: Data { // 单元测试用
        return Data()
    }

    var task: Task {
        var parameters = [String:String]()
        switch self {
        case .home:
            break
        case let .gamelist(page,cat,coin,name,isPopular,isRecommand):
//            parameters["popular"] = "1"
            parameters["p"] = "\(page)"

            if let name = name {
                parameters["name"] = name
            }
            if let coin = coin {
                parameters["coin"] = coin
            }
            if let isPopular = isPopular {
                parameters["popular"] = isPopular.int.string
            }
            
            if let recommand = isRecommand {
                if recommand == true {
                    parameters["isindex"] = recommand.int.string
                    parameters["cat"] = "0"
                } else {
                    parameters["cat"] = cat
                }
            }
        }

        logInfo("\n \(self.path)\n请求参数：\(parameters)\n")
        parameters.rsaEncode()

        parameters.addIfNotExist(dict: BaseConfig.baseParameters())

        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }

    var headers: [String : String]? {
        return BaseConfig.headers
    }

}
