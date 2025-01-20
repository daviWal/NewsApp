//
//  ViewController.swift
//  NewsAppSEI
//
//  Created by David Walitza on 26.06.2021.
//

import UIKit
import SafariServices

//tableView
//customCell
//apicall
//opennewsstory
//searchfornewsstories

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var newsModel = [NewsTableViewCellModel]()
    private var newsArticles = [Article]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "News"
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        APICaller.instance.getNews { [weak self] result in
            switch result{
            case .success(let newsArticles):
                self?.newsArticles = newsArticles
                self?.newsModel = newsArticles.compactMap({NewsTableViewCellModel(
                                                        title: $0.title,
                                                        subtitle: $0.description ?? "no description",
                                                        imageURL: URL(string: $0.urlToImage ?? "")
                )
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return newsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else{
            fatalError()
        }
        cell.configure(with: newsModel[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        let article = newsArticles[indexPath.row]
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}


