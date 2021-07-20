//
//  MovieRepository.swift
//  CarbonAssement
//
//  Created by Anthony Odu on 10/07/2021.
//

import Foundation


class MovieViewModel{
    
    //Get all Movies from Remote Data Source
    func getAllMovies(onSuccess: @escaping (_ movies: [AllResult]) -> Void,
                      onFail: @escaping (_ : CustomError) -> Void,
                      onLoading: @escaping (_ loading: Bool) -> Void){
        var result:[AllResult] = []
        RemoteDataSource.shared.getAllMovies { movieResult in
            movieResult.forEach { value in
                let newValue = AllResult(voteCount: value.voteCount, posterPath: value.posterPath ?? "", id: value.id, backdropPath: value.backdropPath ?? "", title: value.title, voteAverage: value.voteAverage, overview: value.overview ?? "", releaseDate: value.releaseDate ?? "", favourite: false)
                result.append(newValue)
            }
            onSuccess(result)
        } onFail: { error in
            onFail(error)
        } onLoading: { loading in
            onLoading(loading)
        }
    }
    
    //Search for Movie from Remote Data Source
    func searchMovie(search:String,onSuccess: @escaping (_ movies: [AllResult]) -> Void,
                      onFail: @escaping (_ : CustomError) -> Void,
                      onLoading: @escaping (_ loading: Bool) -> Void){
        var result:[AllResult] = []
        RemoteDataSource.shared.searchMovie(search:search) { movieResult in
            movieResult.forEach { value in
                let newValue = AllResult(voteCount: value.voteCount, posterPath: value.posterPath ?? "", id: value.id, backdropPath: value.backdropPath ?? "", title: value.title, voteAverage: value.voteAverage, overview: value.overview ?? "", releaseDate: value.releaseDate ?? "", favourite: false)
                result.append(newValue)
            }
            onSuccess(result)
        } onFail: { error in
            onFail(error)
        } onLoading: { loading in
            onLoading(loading)
        }
    }
    
    
    // Save Movie
    func save(item: Result){
        LocalDataSource.shared.saveItem(item: item){result in
            if result{
                NotificationCenter.default.post(name: NSNotification.Name.reloadMovies, object: nil, userInfo: [:])
            }
        }
    }
    
    
    // Delete Movie
    func delete(item: Result){
        LocalDataSource.shared.deleteItem(item: item)
    }
    
    
    //Get all Movies from Local Data Source
    func getFavourite(onSuccess: @escaping (_ movies: [MovieListItem]) -> Void,
                onFail: @escaping (_ : CustomError) -> Void){
        LocalDataSource.shared.getAllitem { list in
            onSuccess(list)
        } onFail: { error in
            onFail(error)
        }
    }
    
    
    func allreadyFavourited(movieId:Int,favourite: @escaping (_ favourite:Bool)->Void){
        getFavourite { list in
            list.forEach { result in
                if result.id == movieId{
                    favourite(true)
                }else{
                    favourite(false)
                }
            }
        } onFail: { _ in }

    }

}
