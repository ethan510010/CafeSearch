//
//  APIManager.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/3.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import Foundation

class APIManager{
    
    static let shared = APIManager()

    func fetchCafe(url:String, completion: @escaping ([Cafe]?)->Void){
        guard let url = URL(string: url) else {return}
        let urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            if let data = data{
                if let response = response as? HTTPURLResponse{
//                    print(response.statusCode)
                    do{
                       let jsonDecoder = JSONDecoder()
                        let downloadedCafeLists = try jsonDecoder.decode([Cafe].self, from: data)
                        completion(downloadedCafeLists)
                    }catch{
                        dump(error.localizedDescription)
                        
                        completion(nil)
                    }
                }
            }
        }
        task.resume()
    }
}
