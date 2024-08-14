//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Konstantin on 14.08.2024.
//

import Foundation

typealias Binding<T> = (T) -> Void

final class CategoryViewModel {
    
    private let dataHolder = DataHolder.shared
    private let trackerCategoryStore = TrackerCategoryStore()
    
    private(set) var categories: [String] = [] {
        didSet {
            categoriesBinding?(categories)
        }
    }
    
    var categoriesBinding: Binding<[String]>?
    
    init() {
        self.categories = getCategoriesFromStore()
    }
    
    func getCategoriesFromStore() -> [String] {
        return trackerCategoryStore.loadOnlyTitleCategories()
    }
    
    func deleteCategoryForIndexPath() {
        dataHolder.deleteCategoryForIndexPath()
    }
    
    func isCategoryForIndexPathNil() -> Bool {
        if dataHolder.categoryForIndexPath != nil {
            return false
        }
        return true
    }
    
    func addCategoryForIndexPath(categoryTitle: String) {
        dataHolder.categoryForIndexPath = categoryTitle
    }
    
    func updateCategories() {
        self.categories = getCategoriesFromStore()
    }
}
