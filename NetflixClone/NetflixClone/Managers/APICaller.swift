//
//  APICaller.swift
//  NetflixClone
//
//  Created by Ravindar Nayak on 09/09/23.
//

import Foundation
struct Constants{
    static let baseURL = "https://api.themoviedb.org"
    static let API_KEY = "7f84257c298f5dc5370fe72f0ffaba4b"
    static let youtube_Api = "AIzaSyDxpA0HaTeZUNUP2cldEd2VoycPbv8WR0A"
    static let youtube_URL = "https://youtube.googleapis.com/youtube/v3/search?"
}
enum APIError: Error{
    case FailedTogetData
}


class APICaller {
    static let shared = APICaller()
    
    func getTrendingMovie(completion: @escaping (Result<[Movie], Error>) ->Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else { return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data , error == nil else { return}
            
            //converting data into json format
            do {
                // let result = try JSONSerialization.jsonObject(with: data,options: .fragmentsAllowed)
                let result = try JSONDecoder().decode(TrendingMovieResponce.self, from: data)
                //     print(result.results[0].original_title)
                completion(.success(result.results))
                
            }catch {
                completion(.failure(APIError.FailedTogetData))
                
            }
        }
        task.resume()
    }
    
    
    func getTrendingTv(completion: @escaping (Result<[Movie], Error>) ->Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {
            return
            
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data , error == nil else {
                return
                
            }
            
            do{
                let result = try JSONDecoder().decode(TrendingMovieResponce.self, from: data)
                completion(.success(result.results))
                
                
                
            } catch {
                completion(.failure(APIError.FailedTogetData))
                
            }
            
        }
        task.resume()
    }
    //    "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1"
    func getUpComingMovies(completion: @escaping(Result<[Movie], Error>) ->Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else{
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data , error == nil else {
                return
            }
            do{
                let result = try JSONDecoder().decode(TrendingMovieResponce.self, from: data)
                completion(.success(result.results))
                
            }catch{
                completion(.failure(APIError.FailedTogetData))
            }
            
        }
        task.resume()
    }
    
    
    //"\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1"
    func getTopratedMovie(completion: @escaping(Result<[Movie], Error>) ->Void) {
        guard let url = URL(string:"\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1" ) else{
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data , error == nil else {
                return
            }
            do{
                let result = try JSONDecoder().decode(TrendingMovieResponce.self, from: data)
                completion(.success(result.results))
                
            }catch{
                completion(.failure(APIError.FailedTogetData))
            }
            
        }
        task.resume()
        
        
        //"\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1"
    }
    func getPopularMovie(completion: @escaping(Result<[Movie], Error>) ->Void) {
        guard let url = URL(string:"\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1" ) else{
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data , error == nil else {
                return
            }
            do{
                let result = try JSONDecoder().decode(TrendingMovieResponce.self, from: data)
                completion(.success(result.results))
                
            }catch{
                completion(.failure(APIError.FailedTogetData))
            }
            
        }
        task.resume()
    }
    
    //.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate
    //&language=en-US&sort_by=popularity
    
    func getDiscoverMovies(completion: @escaping(Result<[Movie], Error>) ->Void){
        //        guard let url = URL(string:"\(Constants.baseURL)/3/discover /movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularityx") else{
        //            return
        //        }
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else { return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data , error == nil else {
                return
            }
            do{
                let result = try JSONDecoder().decode(TrendingMovieResponce.self, from: data)
                completion(.success(result.results))
                
            }catch{
                completion(.failure(APIError.FailedTogetData))
            }
            
        }
        task.resume()
        
        
    }
    
    func search(with query: String,completion: @escaping(Result<[Movie], Error>) ->Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
            return}
        //        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else { return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data , error == nil else {
                return
            }
            do{
                let result = try JSONDecoder().decode(TrendingMovieResponce.self, from: data)
                completion(.success(result.results))
                
            }catch{
                completion(.failure(APIError.FailedTogetData))
            }
            
        }
        task.resume()
        
        
    }
    
    func getMovie(with query: String,completion: @escaping(Result<VideoElement, Error>) ->Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.youtube_URL)q=\(query)&key=\(Constants.youtube_Api)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data , error == nil else {
                return
            }
            do{
                let result = try JSONDecoder().decode(YoutubeSearchResponce.self, from: data)
                completion(.success(result.items[0]))
                
            }catch{
                completion(.failure(error))
                print(error.localizedDescription)
            }
            
        }
        task.resume()
        
        
        
    }
}


