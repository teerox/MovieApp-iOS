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
    
    var screenSize: CGRect!
     var screenWidth: CGFloat!
     var screenHeight: CGFloat!
    
    
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
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
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
        // setting number of column based on the device
        if UIDevice().userInterfaceIdiom == .phone
                   {
        customLayout.numberOfColumns = 2
        }else if UIDevice().userInterfaceIdiom == .pad{
            customLayout.numberOfColumns = 3
        }
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
    
        if UIDevice().userInterfaceIdiom == .phone
                   {
                       switch UIScreen.main.nativeBounds.height
                       {
                       case 480:
                           print("iPhone Classic")
                        let cellSize = CGSize(width: (collectionView.bounds.width - (3 * 10))/2, height: 350)
                        return cellSize
                       case 960:
                           print("iPhone 4 or 4S")
                        let cellSize = CGSize(width: (collectionView.bounds.width - (3 * 10))/2, height: 350)
                        return cellSize

                       case 1136:
                           print("iPhone 5 or 5S or 5C")
                        let cellSize = CGSize(width: (collectionView.bounds.width - (3 * 10))/2, height: 350)
                        return cellSize
                       case 1334:
                           print("iPhone 6 or 6S")
                        let cellSize = CGSize(width: (collectionView.bounds.width - (3 * 10))/2, height: 350)
                        return cellSize
                       case 2208:
                           print("iPhone 6+ or 6S+")
                        let cellSize = CGSize(width: (collectionView.bounds.width - (3 * 10))/2, height: 350)
                        return cellSize
                       default:
                           print("unknown")
                        let cellSize = CGSize(width: (collectionView.bounds.width - (3 * 10))/2, height: 350)
                        return cellSize
                      }
                  }

        else if UIDevice().userInterfaceIdiom == .pad
        {
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad &&
                    (UIScreen.main.bounds.size.height == 1366 || UIScreen.main.bounds.size.width == 1366))
            {

                //let vad = (((collectionView.bounds.width - 30)/2)/2) - 50
                let cellSize = CGSize(width: (((collectionView.bounds.width - 30)/2)/2) - 50, height: 200)
                return cellSize
            }
            else if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad &&
                        (UIScreen.main.bounds.size.height == 1024 || UIScreen.main.bounds.size.width == 1024))
            {

               // let vad = (((collectionView.bounds.width - 30)/2)/2) - 50
                let cellSize = CGSize(width: (((collectionView.bounds.width - 30)/2)/2) - 50, height: 200)
                return cellSize
            }
            else
            {
                //let vad = (((collectionView.bounds.width - 30)/2)/2) - 50
                let cellSize = CGSize(width: (((collectionView.bounds.width - 30)/2)/2) - 50, height: 200)
                return cellSize
            }
        }

        else{
            //let vad = (((collectionView.bounds.width - 30)/2)/2) - 50
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
