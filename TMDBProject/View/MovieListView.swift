//
//  MovieListView.swift
//  TMDBProject
//
//  Created by SATHISH KUMAR on 09/01/24.
//

import SwiftUI

struct MovieListView: View {
    let movieId: Int
       let movieTitle: String
       @StateObject private var movieDetailState = MovieDetailState()
       @State private var selectedTrailerURL: URL?
    
    var body: some View {
        List {
                   if let movie = movieDetailState.movie {
                       MovieDetailImage(imageURL: movie.backdropURL)
                           .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                           .listRowSeparator(.hidden)
                       
                       MovieDetailListView(movie: movie, selectedTrailerURL: $selectedTrailerURL)
                   }
               }
               .listStyle(.plain)
               .task(loadMovie)
               .overlay(DataFetchPhaseOverlayView(
                   phase: movieDetailState.phase,
                   retryAction: loadMovie)
               )
               .navigationTitle(movieTitle)
           }
    
           private func loadMovie() {
               Task { await self.movieDetailState.loadMovie(id: self.movieId) }
           }
       }

       struct MovieDetailListView: View {
           
           let movie: Movie
           @Binding var selectedTrailerURL: URL?
           
           var body: some View {
               movieDescriptionSection.listRowSeparator(.visible)
           }
           
           private var movieDescriptionSection: some View {
               VStack(alignment: .leading, spacing: 16) {
                   Text(movie.overview)
                   HStack {
                       if !movie.ratingText.isEmpty {
                           Text(movie.ratingText).foregroundColor(.yellow)
                       }
                       Text(movie.scoreText)
                   }
               }
               .padding(.vertical)
           }
           
       }

       struct MovieDetailImage: View {
           
           @StateObject private var imageLoader = ImageLoader()
           let imageURL: URL
           
           var body: some View {
               ZStack {
                   Color.gray.opacity(0.3)
                   if let image = imageLoader.image {
                       Image(uiImage: image)
                           .resizable()
                   }
               }
               .aspectRatio(16/9, contentMode: .fit)
               .onAppear { imageLoader.loadImage(with: imageURL) }
           }
       }

       extension URL: Identifiable {
           
           public var id: Self { self }
    }
