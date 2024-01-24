//
//  DataPersisstanceMannager.swift
//  NetflixClone
//
//  Created by Ravindar Nayak on 14/09/23.
//

import Foundation
import UIKit
import CoreData
class DataPersisstanceMannager{
    
    enum DatabaseError: Error {
        case  FailedToSaveData
        case FailedToFetchdata
        case FailedToDetectData
    }
    
    static let shared = DataPersisstanceMannager()
    
    func downloadTitleWith(Model: Movie, compleasion: @escaping(Result<Void, Error>) -> Void){
        guard let appDelegete = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegete.persistentContainer.viewContext
        let item = TitlesItem(context: context)
        item.id = Int64(Model.id)
        item.original_title = Model.original_title
        item.overview = Model.overview
        item.media_name = Model.media_name
        item.poster_path = Model.poster_path
        item.vote_count = Int64(Model.vote_count ?? 0)
        
        do{
            try context.save()
            compleasion(.success(()))
        } catch{
            compleasion(.failure(DatabaseError.FailedToSaveData as! Error))
        }
    }
    
    
    
    func fetchingDataFromDtataBase(completiton: @escaping(Result<[TitlesItem], Error>) ->Void){
        
        guard let appDelegete = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context = appDelegete.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitlesItem>
        
        request  = TitlesItem.fetchRequest()
        
        
        do {
            let titles = try context.fetch(request)
            completiton(.success(titles))
        }
        catch {
            completiton(.failure(DatabaseError.FailedToFetchdata))
            print(error.localizedDescription)
        }
    }
    
    func deleteTitleWith(model: TitlesItem, compleasion: @escaping(Result<Void, Error>) -> Void){
        guard let appDelegete = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegete.persistentContainer.viewContext
        context.delete( model)
        
        do{
            try context.save()
            compleasion(.success(()))
        } catch{
            compleasion(.failure(DatabaseError.FailedToDetectData))
        }
    }
}
