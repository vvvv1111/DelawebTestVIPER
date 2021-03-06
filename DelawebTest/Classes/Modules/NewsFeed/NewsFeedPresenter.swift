//
//  NewsFeedPresenter.swift
//  DelawebTest
//
//  Created by Vladimir on 02.12.2020.
//  Copyright © 2020 Vladimir. All rights reserved.
//

import Foundation
import UIKit

class NewsFeedPresenter: ViewToPresenterNewsFeedProtocol {
    
    // MARK: Properties
    var view: PresenterToViewNewsFeedProtocol?
    var interactor: PresenterToInteractorNewsFeedProtocol?
    var router: PresenterToRouterNewsFeedProtocol?
    var alreadyRunning = false
    var articles: [Article] = []
    var images: [UIImage] = []
    
    
    // MARK: Inputs from view
    func viewDidLoad() {
//        print("Presenter is being notified that the View was loaded.")
//        interactor?.loadArticles()
    }
    
    
    //     func refresh() {
    //         print("Presenter is being notified that the View was refreshed.")
    //         interactor?.loadArticles()
    //     }
    
    func scrollViewDidScroll() {
        if self.alreadyRunning == false {
            self.alreadyRunning = true
            self.interactor?.loadArticles()
            self.view?.activityIndicator.start(closure: {})
        }
    }
    
    func numberOfRowsInSection() -> Int {
        if articles.count == 0{
            return 0
        }
        return articles.count + 1
    }
    
    func textLabelText(indexPath: IndexPath) -> String? {
        if articles.count == 0{
            return nil
        }
        return articles[indexPath.row - 1].title
    }
    
    func textDescriptionText(indexPath: IndexPath) -> String? {
        if articles.count == 0{
            return nil
        }
        return articles[indexPath.row - 1].articleDescription
    }
    
    func imageArticles(indexPath: IndexPath) -> UIImage? {
        if images.count == 0{
            return nil
        }
        return images[indexPath.row - 1]
    }
    
    
    func didSelectRowAt(index: Int) {
        interactor?.retrieveArticle(at: index)
    }
    //
    //     func deselectRowAt(index: Int) {
    //         view?.deselectRowAt(row: index)
    //     }
}

extension NewsFeedPresenter: InteractorToPresenterNewsFeedProtocol {
    func getArticleAndImageSuccess(article: Article, data: Data) {
        var image = UIImage()
        if let imagee = UIImage(data: data) {
            image = imagee
        }else{
            image = UIImage(named: "imageNotFound.png")!
        }
        router?.pushToArticleDetail(on: view!, with: article, with: image)
    }
    
    func fetchArticlesSuccess(articles: [Article]) {
        print("Presenter receives the result from Interactor after it's done its job.")
        self.articles = articles
        view?.onFetchArticlesSuccess()
        interactor?.loadImages()
    }
    
    func fetchImagesSuccess(images: [Data]) {
        self.images = []
        print("Presenter receives the result from Interactor after it's done its job.")
        for index in 0..<images.count{
            if let image = UIImage(data: images[index]) {
                self.images.append(image)
            }else{
                let image = UIImage(named: "imageNotFound.png")!
                self.images.append(image)
            }
        }
        alreadyRunning = false
        view?.activityIndicator.stop()
        view?.onFetchImagesSuccess()
    }
    
    //    func fetchArticlesFailure(errorCode: Int) {
    //        print("Presenter receives the result from Interactor after it's done its job.")
    //        view?.onFetchArticlesFailure(error: "Couldn't fetch articles: \(errorCode)")
    //    }
    
    //    func getArticleSuccess(_ article: Article) {
    //        router?.pushToArticleDetail(on: view!, with: article)
    //    }
    
    //    func getArticleFailure() {
    //        print("Couldn't retrieve article by index")
    //    }
}
