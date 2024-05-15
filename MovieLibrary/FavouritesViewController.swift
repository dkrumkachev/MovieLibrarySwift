import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    var movies: [Movie] = []
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        let movie = movies[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(movie.title)\n\(movie.year)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: "showMovieInfoFromFavourites", sender: selectedMovie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieInfoFromFavourites",
           let destinationVC = segue.destination as? MovieInfoViewController,
           let movie = sender as? Movie {
            destinationVC.movie = movie
        }
    }

    func getUserFavourites() {
        let currentUserEmail = Auth.auth().currentUser?.email
        let ref = Database.database().reference().child("users")
        let query = ref.queryOrdered(byChild: "email").queryEqual(toValue: currentUserEmail)
        query.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    let key = childSnapshot.key
                    self.observeFavourites(with: key)
                }
            }
        })
    }	
    
    func observeFavourites(with key: String) {
        let favouritesRef = Database.database().reference().child("users/\(key)/favourites")
        favouritesRef.observe(.value, with: { snapshot in
            var favouriteIds: [String] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let favouriteId = childSnapshot.value as? String {
                    favouriteIds.append(favouriteId)
                }
            }
            self.loadMovies(with: favouriteIds)
        })
    }
    
    func loadMovies(with ids: [String]) {
        let moviesRef = Database.database().reference().child("movies")
        movies = []
        for id in ids {
            moviesRef.child(id).observeSingleEvent(of: .value, with: { snapshot in
                if let value = snapshot.value as? [String: Any] {
                   let id = value["id"] as? String
                    let title = value["title"] as? String
                    let director = value["director"] as? String
                    let description = value["description"] as? String
                    let year = value["year"] as? Int
                    let images = value["images"] as? [String] ?? []
                    let movie = Movie(id: id!, title: title!, year: year!,
                                      director: director!, description: description!, images: images);
                    self.movies.append(movie);
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
	    getUserFavourites()
    }
}
