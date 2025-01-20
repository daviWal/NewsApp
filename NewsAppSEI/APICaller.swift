//
//  APICaller.swift
//  NewsAppSEI
//
//  Created by David Walitza on 26.06.2021.
//

import Foundation
final class APICaller {
    static let instance = APICaller()
    struct defaultVal{
        static let newsURL = URL(string:
            "https://newsapi.org/v2/top-headlines?country=US&apiKey=APIKEY")
    }
    private init(){}


public func getNews(completion: @escaping (Result<[Article], Error>) -> Void ){
    guard let url = defaultVal.newsURL else {
        return
    }
    let task = URLSession.shared.dataTask(with: url){
        data, _, error in
        if let error = error{
            completion(.failure(error))
        }
        else if let data = data {
            do{
                let result = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(.success(result.articles))
            } catch{
                completion(.failure(error))
            }
        }
    }
    task.resume()
    
    }
}
