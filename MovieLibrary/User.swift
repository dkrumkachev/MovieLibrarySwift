import Foundation

class User {
    var email: String?
    var firstName: String?
    var lastName: String?
    var gender: String?
    var birthday: String?
    var phoneNumber: String?
    var country: String?
    var favouriteGenre: String?
    var favouriteDirector: String?
    var bio: String?
    
    init(email: String? = nil, firstName: String? = nil, lastName: String? = nil, gender: String? = nil, 
         birthday: String? = nil, phoneNumber: String? = nil, country: String? = nil, 
         favouriteGenre: String? = nil, favouriteDirector: String? = nil, bio: String? = nil) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.birthday = birthday
        self.phoneNumber = phoneNumber
        self.country = country
        self.favouriteGenre = favouriteGenre
        self.favouriteDirector = favouriteDirector
        self.bio = bio
    }
}
