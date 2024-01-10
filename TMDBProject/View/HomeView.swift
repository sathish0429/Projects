//
//  HomeView.swift
//  TMDBProject
//
//  Created by SATHISH KUMAR on 08/01/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var movieHomeState = MovieHomeState()

    var body: some View {
      
        List {
                ForEach(movieHomeState.sections) {
                    MovieThumbnailCarouselView(
                        title: $0.title,
                        movies: $0.movies,
                        thumbnailType: $0.thumbnailType)
                }
                .listRowInsets(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                .listRowSeparator(.hidden)
            }
            .task { loadMovies(invalidateCache: false) }
            .refreshable { loadMovies(invalidateCache: true) }
            .overlay(DataFetchPhaseOverlayView(
                phase: movieHomeState.phase,
                retryAction: { loadMovies(invalidateCache: true) })
            )
            .listStyle(.plain)
            .navigationTitle(" Movie Streaming ")
        }
        
        private func loadMovies(invalidateCache: Bool) {
            Task { await movieHomeState.loadMoviesFromAllEndpoints(invalidateCache: invalidateCache) }
        }
        
    }


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
    }
}
