//
//  ContentView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 06..
//

import SwiftUI
import InjectPropertyWrapper

protocol ErrorViewModelProtocol{
    var alerModel : AlertModel { get }
}

protocol GenreSectionViewModelProtocol: ObservableObject {
    
}

class GenreSectionViewModel: GenreSectionViewModelProtocol {
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    @Inject
    private var movieService: MovieServiceProtocol
    
    func fetchGenres() async {
        do {
            let request = FetchGenreRequest()
            let genres = try await movieService.fetchGenres(req: request)
            DispatchQueue.main.async {
                self.genres = genres
            }
        } catch let error as MovieError{
            print(error.localizedDescription)
        } catch {
            print("Error fetching genres")
        }
        
//        self.genres = [
//            Genre(id: 1, name: "Adventure"),
//            Genre(id: 2, name: "Sci-fi"),
//            Genre(id: 3, name: "Fantasy"),
//            Genre(id: 4, name: "Comedy")
//        ]
    }
    func fetchTVGenres() async {
        do {
            let request = FetchGenreRequest()
            let genres = try await movieService.fetchTVGenres(req: request)
            DispatchQueue.main.async {
                self.genres = genres
            }
        } catch let error as MovieError {
            DispatchQueue.main.async {
                self.alertModel = self.toAlertModel(error)
            }
        }
        catch {
            print("Error fetching Tv genres")
        }
    }
    
    func load(type: GenreType) async {
//        return await Environment.name == .tv ? fetchTVGenres() : fetchGenres()
        switch type {
        case .movie:
            return await fetchGenres()
        case .tvShow:
            return await fetchTVGenres()
        }
    }
    
    private func toAlertModel(_ error: MovieError)->AlertModel{
        guard let error = error as? MovieError else {
            return AlertModel(title: "error.unexpected.title", message: "error.unexpected.desc", dismissButtonTitle: "error.close")
        }
        switch error{
        case .invalidApiKeyError(let message):
            return AlertModel(title: "error.api.title", message: message, dismissButtonTitle: "error.close")
        case .clientError:
            return AlertModel(title: "Client error", message: error.localizedDescription, dismissButtonTitle: "error.close")
        default:
            return AlertModel(title: "error.unexpected.title", message: "error.unexpected.desc", dismissButtonTitle: "error.close")
        }
    }
}

struct GenreSectionView: View {
    var type: GenreType
    @StateObject private var viewModel  = GenreSectionViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack{
                        Spacer()
                        Image(.redCirclePart)
                    }
                    Spacer()
                }.ignoresSafeArea()
                List(viewModel.genres) {genre in
                    ZStack {
                        NavigationLink(destination: MovieListView(genre: genre)) {
                            EmptyView()
                        }.opacity(0)

                        GenreSectionCell(genre: genre)
                                        
                    }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                .accessibilityLabel("testCollectionView")
                .listStyle(.plain)
                .navigationTitle(type == .movie ? "Movie" : "Tv Show")
            }
            .onAppear {
//                a task felel a háttérben futó hívásokért
                Task {
                    await viewModel.load(type: type)
                }
            }
            .alert(item: $viewModel.alertModel) { model in
                Alert(title: Text(LocalizedStringKey(model.title)), message: Text(LocalizedStringKey(model.message)), dismissButton: .default(Text(LocalizedStringKey(model.dismissButtonTitle))){
                    viewModel.alertModel = nil
                })}
        }
    }
}

#Preview {
    GenreSectionView(type: .movie)
}
