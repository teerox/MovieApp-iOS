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
        if UIDevice().userInterfaceIdiom == .phone
        {
            customLayout.numberOfColumns = 2
        }else if UIDevice().userInterfaceIdiom == .pad{
            customLayout.numberOfColumns = 3
        }
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


////MARK: - Custom Image
extension FavouriteMovieViewController: CustomLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        
        if UIDevice().userInterfaceIdiom == .phone
        {
            switch UIScreen.main.nativeBounds.height
            {
            case 480:
                let cellSize = CGSize(width: (collectionView.bounds.width - (3 * 10))/2, height: 350)
                return cellSize
            case 960:
                let cellSize = CGSize(width: (collectionView.bounds.width - (3 * 10))/2, height: 350)
                return cellSize
            case 1136:
                let cellSize = CGSize(width: (collectionView.bounds.width - (3 * 10))/2, height: 350)
                return cellSize
            case 1334:
                let cellSize = CGSize(width: (collectionView.bounds.width - (3 * 10))/2, height: 350)
                return cellSize
            case 2208:
                let cellSize = CGSize(width: (collectionView.bounds.width - (3 * 10))/2, height: 350)
                return cellSize
            default:
                let cellSize = CGSize(width: (collectionView.bounds.width - (3 * 10))/2, height: 350)
                return cellSize
            }
        }
        
        else if UIDevice().userInterfaceIdiom == .pad
        {
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad &&
                    (UIScreen.main.bounds.size.height == 1366 || UIScreen.main.bounds.size.width == 1366))
            {
                
                
                let cellSize = CGSize(width: (((collectionView.bounds.width - 30)/2)/2) - 50, height: 200)
                return cellSize
            }
            else if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad &&
                        (UIScreen.main.bounds.size.height == 1024 || UIScreen.main.bounds.size.width == 1024))
            {
                
                
                let cellSize = CGSize(width: (((collectionView.bounds.width - 30)/2)/2) - 50, height: 200)
                return cellSize
            }
            else
            {
                
                let cellSize = CGSize(width: (((collectionView.bounds.width - 30)/2)/2) - 50, height: 200)
                return cellSize
            }
        }
        
        else{
            
            let cellSize = CGSize(width: (((collectionView.bounds.width - 30)/2)/2) - 50, height: 200)
            return cellSize
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return sectionInset
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
            let cellSize = CGSize(width: 160, height: 350)
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical //.horizontal
            layout.itemSize = cellSize
            layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
            layout.minimumLineSpacing = 1.0
            layout.minimumInteritemSpacing = 1.0
            collectionView.setCollectionViewLayout(layout, animated: true)
            collectionView.reloadData()
        }
        
        else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            
            let cellSize = CGSize(width: 160, height: 350)
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical //.horizontal
            layout.itemSize = cellSize
            layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
            layout.minimumLineSpacing = 1.0
            layout.minimumInteritemSpacing = 1.0
            collectionView.setCollectionViewLayout(layout, animated: true)
            collectionView.reloadData()
        }
        else {
            
            if UIDevice().userInterfaceIdiom == .phone
            {
                switch UIScreen.main.nativeBounds.height
                {
                case 480:
                    print("iPhone Classic")
                    let layout = UICollectionViewFlowLayout()
                    layout.scrollDirection = .vertical //.horizontal
                    
                    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    print("second::",(collectionView.bounds.width - (3 * 10))/2)
                    print("third::",((collectionView.bounds.width - (3 * 10))/2)/2)
                    layout.itemSize = CGSize(width: ((collectionView.bounds.width - (3 * 10))/2)/2, height: 350)
                    layout.minimumInteritemSpacing = 1.0
                    layout.minimumLineSpacing = 10.0
                    collectionView.setCollectionViewLayout(layout, animated: true)
                    collectionView.reloadData()
                case 960:
                    print("iPhone 4 or 4S")
                    let layout = UICollectionViewFlowLayout()
                    layout.scrollDirection = .vertical //.horizontal
                    
                    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    print("second::",(collectionView.bounds.width - (3 * 10))/2)
                    print("third::",((collectionView.bounds.width - (3 * 10))/2)/2)
                    layout.itemSize = CGSize(width: ((collectionView.bounds.width - (3 * 10))/2)/2, height: 350)
                    layout.minimumInteritemSpacing = 1.0
                    layout.minimumLineSpacing = 10.0
                    collectionView.setCollectionViewLayout(layout, animated: true)
                    collectionView.reloadData()
                case 1136:
                    print("iPhone 5 or 5S or 5C")
                    let layout = UICollectionViewFlowLayout()
                    layout.scrollDirection = .vertical //.horizontal
                    
                    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    print("second::",(collectionView.bounds.width - (3 * 10))/2)
                    print("third::",((collectionView.bounds.width - (3 * 10))/2)/2)
                    layout.itemSize = CGSize(width: ((collectionView.bounds.width - (3 * 10))/2)/2, height: 350)
                    layout.minimumInteritemSpacing = 1.0
                    layout.minimumLineSpacing = 10.0
                    collectionView.setCollectionViewLayout(layout, animated: true)
                    collectionView.reloadData()
                case 1334:
                    print("iPhone 6 or 6S")
                    let layout = UICollectionViewFlowLayout()
                    layout.scrollDirection = .vertical //.horizontal
                    
                    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    print("second::",(collectionView.bounds.width - (3 * 10))/2)
                    print("third::",((collectionView.bounds.width - (3 * 10))/2)/2)
                    layout.itemSize = CGSize(width: ((collectionView.bounds.width - (3 * 10))/2)/2, height: 350)
                    layout.minimumInteritemSpacing = 1.0
                    layout.minimumLineSpacing = 10.0
                    collectionView.setCollectionViewLayout(layout, animated: true)
                    collectionView.reloadData()
                case 2208:
                    print("iPhone 6+ or 6S+")
                    let layout = UICollectionViewFlowLayout()
                    layout.scrollDirection = .vertical //.horizontal
                    
                    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    print("second::",(collectionView.bounds.width - (3 * 10))/2)
                    print("third::",((collectionView.bounds.width - (3 * 10))/2)/2)
                    layout.itemSize = CGSize(width: ((collectionView.bounds.width - (3 * 10))/2)/2, height: 350)
                    layout.minimumInteritemSpacing = 1.0
                    layout.minimumLineSpacing = 10.0
                    collectionView.setCollectionViewLayout(layout, animated: true)
                    collectionView.reloadData()
                default:
                    print("unknown")
                    let layout = UICollectionViewFlowLayout()
                    layout.scrollDirection = .vertical //.horizontal
                    
                    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    print("second::",(collectionView.bounds.width - (3 * 10))/2)
                    print("third::",((collectionView.bounds.width - (3 * 10))/2)/2)
                    layout.itemSize = CGSize(width: ((collectionView.bounds.width - (3 * 10))/2)/2, height: 350)
                    layout.minimumInteritemSpacing = 1.0
                    layout.minimumLineSpacing = 10.0
                    collectionView.setCollectionViewLayout(layout, animated: true)
                    collectionView.reloadData()
                }
            }
            
            if UIDevice().userInterfaceIdiom == .pad
            {
                if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad &&
                        (UIScreen.main.bounds.size.height == 1366 || UIScreen.main.bounds.size.width == 1366))
                {
                    let layout = UICollectionViewFlowLayout()
                    layout.scrollDirection = .vertical //.horizontal
                    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    layout.itemSize = CGSize(width: (((collectionView.bounds.width - (3 * 10))/2)/2)-50, height: 350)
                    layout.minimumInteritemSpacing = 1.0
                    layout.minimumLineSpacing = 10.0
                    collectionView.setCollectionViewLayout(layout, animated: true)
                    collectionView.reloadData()
                }
                else if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad &&
                            (UIScreen.main.bounds.size.height == 1024 || UIScreen.main.bounds.size.width == 1024))
                {
                    let layout = UICollectionViewFlowLayout()
                    layout.scrollDirection = .vertical //.horizontal
                    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    layout.itemSize = CGSize(width: (((collectionView.bounds.width - (3 * 10))/2)/2)-50, height: 350)
                    layout.minimumInteritemSpacing = 1.0
                    layout.minimumLineSpacing = 10.0
                    collectionView.setCollectionViewLayout(layout, animated: true)
                    collectionView.reloadData()
                }
                else
                {
                    let vad = (((collectionView.bounds.width - 30)/2)/2) - 50
                    print(vad)
                    let layout = UICollectionViewFlowLayout()
                    layout.scrollDirection = .vertical //.horizontal
                    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    layout.itemSize = CGSize(width: vad, height: 350)
                    layout.minimumInteritemSpacing = 1.0
                    layout.minimumLineSpacing = 10.0
                    collectionView.setCollectionViewLayout(layout, animated: true)
                    collectionView.reloadData()
                }
            }
            
            
            
        }
    }
}
