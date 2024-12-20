//
//  ContentView.swift
//  AssignmentSwiftUI
//
//  Created by Satish Rajpurohit on 19/12/24.
//

import SwiftUI

// MARK: - ContentView
struct ContentView: View {
    @State private var searchText = ""
    @StateObject private var assignmentViewModel = AssignmentViewModel()
    @State private var visibleBreeds: [CatBreed] = []
    @State private var isPresented = false
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                    HorizontalCatPagerView(assignmentViewModel: assignmentViewModel)
                        .frame(width: UIScreen.main.bounds.width - 32 ,height: 200)
                    
                    Section {
                        ListOfCat(assignmentViewModel: assignmentViewModel, visibleBreeds: $visibleBreeds, searchQuery: searchText)
                    } header: {
                        StickySearchBar(searchText: $searchText)
                    }
                }
            }
            .font(.title2)
            .padding()
            .task {
                ReachabilityManager.shared.setReachabilityHandler { isConnected in
                    assignmentViewModel.fetchCatImages()
                    assignmentViewModel.fetchCatBreeds()
                }
            }
            
            FloatingButton {
                isPresented.toggle()
            }
            .sheet(isPresented: $isPresented) {
                StatisticView(visibleBreeds: $visibleBreeds)
            }
        }
    }
}

// MARK: - StickySearchBar
/// A search bar component that remains sticky at the top
struct StickySearchBar: View {
    
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            TextField("Search...", text: $searchText)
                .font(.title3)
                .padding(5)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                .background(Color.white)
        }
    }
}

// MARK: - HorizontalCatPagerView
/// A view that displays a horizontally scrollable pager of cat images
struct HorizontalCatPagerView: View {
    @ObservedObject var assignmentViewModel: AssignmentViewModel
    
    var body: some View {
        TabView {
            ForEach(assignmentViewModel.catImages) { catImage in
                VStack {
                    AsyncImage(url: URL(string: catImage.url)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 100, height: 100)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width - 34, height: 120)
                                .cornerRadius(10)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo.fill")
                                .frame(width: UIScreen.main.bounds.width - 32, height: 200)
                                .cornerRadius(10)
                                .padding()
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
        }
        .onAppear() {
            UIPageControl.appearance().currentPageIndicatorTintColor = .blue
            UIPageControl.appearance().pageIndicatorTintColor = .gray
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(maxHeight: .infinity)
        
    }
}

// MARK: - ListOfCat
/// A view displaying a list of cat breeds with optional filtering by search query
struct ListOfCat: View {
    @ObservedObject var assignmentViewModel: AssignmentViewModel
    @Binding var visibleBreeds: [CatBreed]
    var searchQuery: String
    var body: some View {
        var filteredBreeds: [CatBreed] {
            if searchQuery.isEmpty {
                return assignmentViewModel.catBreeds
            } else {
                return assignmentViewModel.catBreeds.filter { breed in
                    breed.name.lowercased().contains(searchQuery.lowercased())
                }
            }
        }
        
        LazyVStack {
            // List of Cat Breeds
            ForEach(assignmentViewModel.catBreeds) { breed in
                
                HStack {
                    // Display cat image if it exists
                    if let imageUrl = breed.image?.url, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 100, height: 100)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(4)
                            case .failure:
                                Image(systemName: "photo.fill")
                                    .frame(width: 100, height: 100)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "photo.fill")
                            .frame(width: 100, height: 100)
                    }
                    
                    // Display breed name and description
                    VStack(alignment: .leading) {
                        Text(breed.name)
                            .font(.headline)
                        Text(breed.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 10)
                }
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 4))
                .onAppear() {
                    if !visibleBreeds.contains(where: { $0.id == breed.id }) {
                        visibleBreeds.append(breed)
                    }
                }
                .onDisappear {
                    visibleBreeds.removeAll { $0.id == breed.id }
                }
            }
        }
        
    }
}
