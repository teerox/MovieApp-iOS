//
//  RemoteDataSource.swift
//  CarbonAssement
//
//  Created by Anthony Odu on 10/07/2021.
//

import Foundation

class RemoteDataSource{
    
    static let shared = RemoteDataSource(apimanger: APIManager())
    let networkHelper: APIManager
    
    let url = "https://api.themoviedb.org/4/discover/movie?sort_by=popularity.desc&api_key=fb97e27952573c39dd8c56b40023750e"
    let searchUrl = "https://api.themoviedb.org/3/search/movie?api_key=fb97e27952573c39dd8c56b40023750e&language=en-US&query="
    
    init(apimanger:APIManager) {
        self.networkHelper = apimanger
    }
    
    
    // Fetch all movies
    func getAllMovies( onSuccess: @escaping (_ movies: [Result]) -> Void,
                       onFail: @escaping (_ : CustomError) -> Void,
                       onLoading: @escaping (_ loading: Bool) -> Void){
        onLoading(true)
        networkHelper.requestData(url: url, method: .get, parameters: nil) { result in
            onLoading(false)
            switch result{
            case .success(let jsonData):
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(MovieResult.self, from: jsonData)
                    onSuccess(result.results)
                } catch {
                    print(error)
                    onFail(.serverMessage("Error Fetching Movie"))
                }
            case .failure(let failure):
                switch failure {
                case .connectionError:
                    onFail(.internetError("Check your Internet connection."))
                case .authorizationError(let errorJson):
                    onFail(.serverMessage(errorJson["message"].stringValue))
                case .serverError(let error):
                    onFail(.serverMessage(error["message"].stringValue))
                default:
                    onFail(.serverMessage("Unknown Error"))
                }
            }
        }
    }
    
    
    
    //Search For Movies
    func searchMovie(search:String,
                     onSuccess: @escaping (_ movies: [Result]) -> Void,
                      onFail: @escaping (_ : CustomError) -> Void,
                      onLoading: @escaping (_ loading: Bool) -> Void){
       onLoading(true)
       networkHelper.requestData(url: searchUrl + search, method: .get, parameters: nil) { result in
       
           onLoading(false)
           switch result{
           case .success(let jsonData):
               let decoder = JSONDecoder()
               do {
                   let result = try decoder.decode(MovieResult.self, from: jsonData)
                   onSuccess(result.results)
               } catch {
                   print(error)
                   onFail(.serverMessage("Error Fetching Movie"))
               }
           case .failure(let failure):
               switch failure {
               case .connectionError:
                   onFail(.internetError("Check your Internet connection."))
               case .authorizationError(let errorJson):
                   onFail(.serverMessage(errorJson["message"].stringValue))
               case .serverError(let error):
                   onFail(.serverMessage(error["message"].stringValue))
               default:
                   onFail(.serverMessage("Unknown Error"))
               }
           }
       }
    }
}
