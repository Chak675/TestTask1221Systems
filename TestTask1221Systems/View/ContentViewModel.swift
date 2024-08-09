//
//  ContentViewModel.swift
//  TestTask1221Systems
//
//  Created by Zorin Dmitrii on 07.08.2024.
//

import SwiftUI

@MainActor
class ContentViewModel: ObservableObject {
    
    enum PresentationState {
        case list, grid
        
        mutating func toggle() {
            switch self {
                case .list: self = .grid
                case .grid: self = .list
            }
        }
    }
    
    @Published var state: PresentationState = .grid
    
    @Published var products = [ProductModel]()
    @Published var isLoading = false
    
    private let service = FetchService()
    
    init() {
        service.$isLoading
            .assign(to: &$isLoading)
    }
    
    func fetch() async {
        switch await service.fetchGoods() {
            case .success(let products): self.products = products
            case .failure(let error): print(error.localizedDescription)
        }
    }
    
    func shoppingListPress() {
        print(#function)
    }
    
    func favoritePress() {
        print(#function)
    }
}
