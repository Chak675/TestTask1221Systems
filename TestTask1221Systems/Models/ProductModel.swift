//
//  ProductModel.swift
//  TestTask1221Systems
//
//  Created by Zorin Dmitrii on 07.08.2024.
//

import Foundation

struct ProductModel: Identifiable, Hashable, Codable {
    
    let id: Int
    let name : String
    let rate: String
    let image: String
    let rub: String
    let cop: String?
    let oldPrice: String 
}
