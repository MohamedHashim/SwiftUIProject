//
//  ContentView.swift
//  ImagesProject
//
//  Created by Mohamed Ahmed on 08/09/2022.
//

import SwiftUI

struct ImagesListView: View {
    
    @StateObject var repository = ImagesRepository() // to instantiate an observed object
    
    @State var showProgressBar = true  // to preserve the state of progressbar
    
    @State private var searchText = ""
    
    @State var gridLayout: [GridItem] = [ GridItem() ]
    
    var body: some View {
                
        NavigationView {
                        
            ZStack {
                if (showProgressBar) {
                    ProgressView()
                        .scaleEffect(
                            2.0,
                            anchor: .center
                        )
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                }
                
                ScrollView {
                    LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                        ForEach(searchResults, id: \.id) { item in
                            NavigationLink(destination: ImageDetailsView(
                                repository: repository,
                                imageData: item
                            ).id(item.id)) {
                                Image(item.url)
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .frame(height: gridLayout.count == 1 ? 200 : 100)
                                    .cornerRadius(10)
                                    .shadow(color: Color.primary.opacity(0.3), radius: 1)
                            }
                        }
                    }.padding(.horizontal)
                        .navigationTitle("Images")
                        .navigationBarTitleDisplayMode(.inline)
                     .searchable(text: $searchText)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            if (gridLayout.count > 1) {
                                self.gridLayout = Array(repeating: .init(), count: 1)
                            } else {
                                self.gridLayout = Array(repeating: .init(.flexible()), count: 3)
                            }
                        }) {
                            Image(systemName: "square.grid.2x2") // SF sympols
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }.task {   // launch a background task
            await repository.getImages()
            showProgressBar = false
        }
    }
    
    var searchResults: [ImageData] {
            if searchText.isEmpty {
                return repository.images
            } else {
                return repository.images.filter { $0.tags.contains(searchText.lowercased()) }
            }
        }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ImagesListView()
    }
}
