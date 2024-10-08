//
//  ContentView.swift
//  TestTask1221Systems
//
//  Created by Zorin Dmitrii on 07.08.2024.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .frame(width: 400,height: 700 ,alignment: .center)
                }
                
                VStack {
                    switch viewModel.state {
                        case .list: list()
                        case .grid: grid()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            withAnimation {
                                viewModel.state.toggle()
                            }
                        } label: {
                            Image(viewModel.state == .list ? "listBullet" : "squareGrid")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color(.green).opacity(0.7))
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color(.gray).opacity(0.1))
                                )
                        }
                    }
                }
            }
            .background(.gray.opacity(0.2))
        }
        .onAppear {
            Task {
                await viewModel.fetch()
            }
        }
    }
    
    @ViewBuilder
    func grid() -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
            ForEach(viewModel.products, id: \.self) { item in
                VStack(alignment: .leading) {
                    Image(item.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(alignment: .topLeading) {
                            VStack(alignment: .leading) {
                                //                                // tag and button
                                HStack(alignment: .top) {
                                    Text(item.tag?.name ?? "")
                                        .padding(.all, 6)
                                        .font(.system(size: 10))
                                        .background(
                                            UnevenRoundedRectangle(
                                                topLeadingRadius: .zero,
                                                bottomLeadingRadius: .zero,
                                                bottomTrailingRadius: 6,
                                                topTrailingRadius: 6
                                            )
                                            .fill(Color(hex: item.tag?.color ?? "#FFFFFF"))
                                        )
                                    
                                    Spacer()
                                    
                                    VStack {
                                        Button {
                                            viewModel.favoritePress()
                                        } label: {
                                            Image("favorite")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                                .foregroundStyle(.black)
                                                .padding(8)
                                        }
                                        
                                        Button {
                                            viewModel.shoppingListPress()
                                        } label: {
                                            Image("shoppingList")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                                .foregroundStyle(.black)
                                                .padding(8)
                                        }
                                    }
                                    .background(.white.opacity(0.8))
                                    .clipShape(
                                        UnevenRoundedRectangle(
                                            topLeadingRadius: .zero,
                                            bottomLeadingRadius: 9,
                                            bottomTrailingRadius: .zero,
                                            topTrailingRadius: .zero,
                                            style: .continuous
                                        )
                                    )
                                }
                                
                                Spacer()
                                
                                HStack {
                                    Image("star")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundStyle(Color(hex: "#FAD656"))
                                    
                                    Text(item.rate)
                                    
                                    item.sale.flatMap {
                                        Text($0)
                                            .font(.system(size: 20).bold())
                                            .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                                            .foregroundStyle(Color(hex: "#C32323"))
                                    }
                                }
                                .padding(4)
                            }
                        }
                    
                    VStack(spacing: 6) {
                        Text(item.name)
                        
                        item.country.flatMap {
                            Text($0)
                                .font(.system(size: 14))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(Color(.systemGray))
                        }
                    }
                    .padding(8)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            HStack(spacing: 2) {
                                Text(item.rub)
                                    .font(.system(size: 22).bold())
                                
                                item.cop.flatMap {
                                    Text($0)
                                        .font(.system(size: 16).bold())
                                        .frame(height: 22, alignment: .top)
                                }
                                
                                Image("perAmountIcon")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                            
                            Text(item.oldPrice)
                                .font(.system(size: 12))
                                .foregroundStyle(Color(.systemGray))
                                .strikethrough(true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button {
                            viewModel.cartPress()
                        } label: {
                            Image("cart")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .padding(.all, 10)
                                .frame(width: 36, height: 36)
                                .padding(.horizontal, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(Color(.systemGreen))
                                )
                        }
                    }
                    .padding(.all, 8)
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(8)
    }
    
    @ViewBuilder
    func list() -> some View {
        VStack(spacing: 8) {
            ForEach(viewModel.products, id: \.self) { item in
                HStack {
                    Image(item.image)
                        .resizable()
                        .frame(width: 144, height: 144)
                    VStack(alignment: .leading) {
                        HStack {
                            Image("star")
                                .resizable()
                                .frame(width: 16, height: 16, alignment: .leading)
                                .foregroundStyle(Color(hex: "#FAD656"))
                            
                            Text(item.rate)
                            
                            Text("| 19 отзывов")
                                .foregroundStyle(.gray)
                        }
                        .font(.system(size: 10))
                        
                        HStack {
                            Text("\(item.name)")
                                .font(.system(size: 16))
                            
                            Spacer()
                            
                            VStack {
                                Button {
                                    viewModel.favoritePress()
                                } label: {
                                    Image("favorite")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundStyle(.black)
                                        .padding(8)
                                }
                                
                                Button {
                                    viewModel.shoppingListPress()
                                } label: {
                                    Image("shoppingList")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundStyle(.black)
                                        .padding(8)
                                }
                            }
                        }
                        
                        item.country.flatMap {
                            Text($0)
                                .font(.system(size: 14))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(Color(.systemGray))
                                .padding(2)
                        }
                        
                        Spacer()
                        
                        HStack {
                            VStack(alignment: .leading) {
                                HStack(spacing: 2) {
                                    Text(item.rub)
                                        .font(.system(size: 22).bold())
                                    
                                    item.cop.flatMap {
                                        Text($0)
                                            .font(.system(size: 16).bold())
                                            .frame(height: 22, alignment: .top)
                                    }
                                    
                                    Image("perAmountIcon")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                
                                Text(item.oldPrice)
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color(.systemGray))
                                    .strikethrough(true)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                            
                            Button {
                                viewModel.shoppingListPress()
                            } label: {
                                Image("cart")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .padding(.all, 10)
                                    .frame(width: 36, height: 36)
                                    .padding(.horizontal, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill(Color(.systemGreen))
                                    )
                            }
                        }
                        .padding(.all, 4)
                    }
                }
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(item.tag?.name ?? "")
                                .frame(minWidth: 0, idealWidth: 100, alignment: .topLeading)
                                .font(.system(size: 10))
                                .padding(.all, 6)
                                .background(
                                    UnevenRoundedRectangle(
                                        topLeadingRadius: 6,
                                        bottomLeadingRadius: 0,
                                        bottomTrailingRadius: 6,
                                        topTrailingRadius: 6,
                                        style: .continuous
                                    )
                                    .fill(Color(hex: item.tag?.color ?? "#FFFFFF"))
                                )
                        }
                        
                        Spacer()
                        
                        item.sale.flatMap {
                            Text($0)
                                .font(.system(size: 20).bold())
                                .frame(maxWidth: 146, alignment: .bottomTrailing)
                                .foregroundStyle(Color(hex: "#C32323"))
                        }
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .background(RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.white))
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
