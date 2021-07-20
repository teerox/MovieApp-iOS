//
//  MovieListItem+CoreDataProperties.swift
//  
//
//  Created by Anthony Odu on 19/07/2021.
//
//

import Foundation
import CoreData


extension MovieListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieListItem> {
        return NSFetchRequest<MovieListItem>(entityName: "MovieListItem")
    }

    @NSManaged public var backdropPath: String?
    @NSManaged public var director: String?
    @NSManaged public var id: Int64
    @NSManaged public var overView: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int64
    @NSManaged public var favourite: Bool

}
