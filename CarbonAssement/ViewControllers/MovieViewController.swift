//
//  ViewController.swift
//  CarbonAssement
//
//  Created by Anthony Odu on 10/07/2021.
//

import UIKit
import SDWebImage

class MovieViewController: UIViewController{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    lazy var searchBar:UISearchBar = UISearchBar()
    
   
    let cellIdentifier = "MovieCells"
    var result:[AllResult] = []
    var id = 0
    var selectedIndex:[Int] = []
    let viewModel = MovieViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favourite", style: .plain, target: self, action: #selector(addTapped))
        setupCollectionView()
        setupCollectionViewItemSize()
        indicator.color = .white
        search()
        loadMovies()
    }

    //Set up Search Bar
    private func search(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.titleView = searchBar
    }
    
    
 
    // Favourite Button Click
    @objc func addTapped(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Favourite") as? FavouriteMovieViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    
    //Collection View Set up
    private func setupCollectionView() {
      collectionView.delegate = self
      collectionView.dataSource = self
      let nib = UINib(nibName: "MovieCells", bundle: nil)
      collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
      
    //Collection View Item Setup
    private func setupCollectionViewItemSize() {
      let customLayout = CustomLayout()
        customLayout.delegate = self
      collectionView.collectionViewLayout = customLayout
    }
    
    
    
    //Load Movies
    private func loadMovies(){
        viewModel.getAllMovies{[weak self] list in
            if list.isEmpty{
                self?.showEmpty(tableView: self!.collectionView, firstText: "No Movies")
            }else{
                self?.result = list
            }
           
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        } onFail: {[weak self] error in
            DispatchQueue.main.async {
                switch error {
                case .internetError(let message):
                    self?.showAlert(message: message)
                case .serverMessage(let message):
                    self?.showAlert(message: message)
                }
            }
            // create the alert
        } onLoading: {[weak self] loading in
            DispatchQueue.main.async {
                if loading{
                    self?.indicator.startAnimating()
                }else{
                    self?.indicator.stopAnimating()
                }
            }
            
        }
    }
    
   
    
    
    //Prepare Segue Movement
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieselected"{
            let item = sender as! AllResult
             let vc = segue.destination as! SingleMovieViewController
            vc.value = item
        }
    }
}



//MARK: - CollectionView
extension MovieViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let a = result[indexPath.row].posterPath
       let IMAGE_BASE_URL =  "https://image.tmdb.org/t/p/original" + a
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCells", for: indexPath) as! MovieCells
        
        cell.textLabel.text = result[indexPath.row].title
        id = result[indexPath.row].id
        cell.moveImage.sd_setImage(with: URL(string: IMAGE_BASE_URL), placeholderImage: UIImage(named: ""))
        cell.releaseDate.text = result[indexPath.row].releaseDate
       // cell.ratings.text = "\(String(describing: result[indexPath.row].voteAverage))"
        cell.ratings.text = "Rating:\(String(result[indexPath.row].voteAverage))"
        let rate = result[indexPath.row].voteAverage / 2
        cell.ratingStar.rating = rate.rounded(toPlaces: 1)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex.append(indexPath.row)
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = result[indexPath.item]
        performSegue(withIdentifier: "movieselected", sender: item)
    }
    
    @objc func pressed(sender: UIButton) {
        let buttonTag = sender.tag
        let item = result[buttonTag]
        performSegue(withIdentifier: "movieselected", sender: item)
    }
    
    
 
}


////MARK: - Custom Image
extension MovieViewController: CustomLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
    return  CGSize(width: 160, height: 280) //UIImage(named: "tee")!.size
  }
}



////MARK: - Search Bar Delegate
extension MovieViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        
        if textSearched.isEmpty{
            loadMovies()
        }else{
            viewModel.searchMovie(search: textSearched) {[weak self] list in
                if list.isEmpty{
                    self?.result = []
                    self?.collectionView.reloadData()
                    self?.showEmpty(tableView: self!.collectionView, firstText: "No Movie Found")
                }else{
                    self?.result = list
                }
               
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } onFail: {[weak self] error in
                DispatchQueue.main.async {
                    switch error {
                    case .internetError(let message):
                        self?.showAlert(message: message)
                    case .serverMessage(let message):
                        self?.showAlert(message: message)
                    }
                }
                // create the alert
            } onLoading: {[weak self] loading in
                DispatchQueue.main.async {
                    if loading{
                        self?.indicator.startAnimating()
                    }else{
                        self?.indicator.stopAnimating()
                    }
                }
            }
        }
        
       

    }
}
