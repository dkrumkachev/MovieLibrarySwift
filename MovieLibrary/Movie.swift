import Foundation

class Movie {
    var id: String
    var title: String
    var year: Int
    var director: String
    var description: String
    var images: [String]
    
    init(id: String, title: String, year: Int,
         director: String, description: String, images: [String]) {
        self.id = id
        self.title = title
        self.year = year
        self.director = director
        self.description = description
        self.images = images
    }
}
