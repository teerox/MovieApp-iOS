//
//  FavouriteMovieViewController.swift
//  CarbonAssement
//
//  Created by Anthony Odu on 10/07/2021.
//

import UIKit
import SDWebImage
import os.log

class FavouriteMovieViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let cellIdentifier = "MovieCells"
    var result:[MovieListItem] = []
    
    var selectedIndex:[Int] = []
    var id = 0
    let viewModel = MovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupCollectionViewItemSize()
        indicator.color = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name.reloadMovies, object: nil)
    }
    
    
    @objc private func reload(_ sender: Notification){
        DispatchQueue.main.async { [weak self] in
            //self?.getMovies()
            self?.collectionView.reloadData()
            
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
       getMovies()
    }
    
    
    //Set up collection View
    private func setupCollectionView() {
      collectionView.delegate = self
      collectionView.dataSource = self
      let nib = UINib(nibName: "MovieCells", bundle: nil)
      collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favmovieselected"{
            let item = sender as! MovieListItem
             let vc = segue.destination as! SingleMovieViewController
            vc.favValue = item
        }
    }
      
    
    //Set up collection View Item Size
    private func setupCollectionViewItemSize() {
      let customLayout = CustomLayout()
        customLayout.delegate = self
      collectionView.collectionViewLayout = customLayout
    }
    
    //get movies
    func getMovies() {
        viewModel.getFavourite {[weak self] list in
            if list.isEmpty{
                self?.result = []
                self?.collectionView.reloadData()
                self?.showEmpty(tableView: self!.collectionView, firstText: "No Favourite Movies")
            }else{
                self?.result = list
                self?.collectionView.reloadData()
            }
            
        } onFail: { error in
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
    

}
//MARK: - CollectionView
extension FavouriteMovieViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let a = result[indexPath.row].posterPath
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCells", for: indexPath) as! MovieCells
        if let res = a{
            
           let IMAGE_BASE_URL =  "https://image.tmdb.org/t/p/original" + res
            cell.moveImage.sd_setImage(with: URL(string: IMAGE_BASE_URL), placeholderImage: UIImage(named: ""))
        }
        cell.textLabel.text = result[indexPath.row].title
        id = Int(result[indexPath.row].id)
        cell.releaseDate.text = result[indexPath.row].releaseDate
        cell.releaseDate.text = result[indexPath.row].releaseDate
        cell.ratingStar.rating = result[indexPath.row].voteAverage
        cell.ratings.text = "Rating:\(String(result[indexPath.row].voteAverage))"
        return cell
    }
    
  
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex.append(indexPath.row)
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = result[indexPath.item]
        performSegue(withIdentifier: "favmovieselected", sender: item)
    }
    
    
    
    
}


//MARK: - Custom Image
extension FavouriteMovieViewController: CustomLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
    return CGSize(width: 160, height: 280) 
  }
}
