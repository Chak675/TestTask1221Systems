//
//  FetchService.swift
//  TestTask1221Systems
//
//  Created by Zorin Dmitrii on 08.08.2024.
//

import Foundation

@MainActor
class FetchService {
    
    @Published var isLoading = false
    
    func fetchGoods() async -> Result<[ProductModel], Error> {
        guard let url = Bundle.main.url(forResource: "Server", withExtension: "json") else {
            return .failure(FetchProductsError.wrongURL)
        }
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let data = try Data(contentsOf: url)
            let product = try JSONDecoder().decode([ProductModel].self, from: data)
            
            try await Task.sleep(nanoseconds: 3000000000)
            
            return .success(product)
        } catch {
            return .failure(error)
        }
    }
}
