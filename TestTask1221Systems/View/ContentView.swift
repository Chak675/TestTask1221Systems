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
                .padding(.horizontal, 16)
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
                                .padding(.all, 8)
                                .foregroundStyle(Color(.green).opacity(0.7))
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color(.gray).opacity(0.1))
                                )
                        }
                        .padding(.bottom, 16)
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
                VStack(spacing: 8) {
                    Image(item.image)
                        .resizable()
                        .frame(width: 168, height: 168)
                    
                    HStack {
                        Image("star")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color(red: 250, green: 214, blue: 86))
                    
                        Text(item.rate)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 20, alignment: .leading)
                    
                    Text(item.name)
                        .padding(.all, 8)
                    
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
                        
                        Spacer()
                        
                        // разместить по дизайну
                        Text(item.oldPrice)
                            .font(.system(size: 12))
                            .foregroundStyle(Color(.systemGray))
                            .strikethrough(true)
                        
                        
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
                        .padding(.bottom, 10)
                    }
                    .padding(.all, 4)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(maxWidth: 168, maxHeight: 278, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.white)))
            }
            .padding(8)
        }
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
                                .foregroundStyle(Color(
                                    red: 250,
                                    green: 214,
                                    blue: 86)
                                )
                            
                            Text(item.rate)
                            
                            Text("| 19 отзывов")
                                .foregroundStyle(.gray)
                        }
                        .frame(width: 107, height: 20)
                        .font(.system(size: 10))
                        
                        Text("\(item.name)")
                            .font(.system(size: 16))
                        
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
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                    .frame(maxWidth: 199, maxHeight: 144)
                }
                .frame(maxWidth: 375, maxHeight: 176, alignment: .leading)
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
