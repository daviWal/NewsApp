//
//  newsModels.swift
//  NewsAppSEI
//
//  Created by David Walitza on 26.06.2021.
//


//API necessities
import Foundation

struct APIResponse: Codable{
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable{
    let name: String
}
