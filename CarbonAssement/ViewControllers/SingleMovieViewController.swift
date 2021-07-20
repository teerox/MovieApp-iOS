//
//  SingleMovieViewController.swift
//  CarbonAssement
//
//  Created by Anthony Odu on 10/07/2021.
//

import UIKit
import SDWebImage
import SnackBar_swift

class SingleMovieViewController: UIViewController {
    
    @IBOutlet weak var overView: UILabel!
    @IBOutlet weak var images: UIImageView!
    @IBOutlet weak var favourite: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    let viewModel = MovieViewModel()
    var favBtn = false
    
    var value:AllResult? = nil
    var favValue:MovieListItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        viewSetUp()
    }
    
    
    @IBAction func favouriteBtn(_ sender: UIButton) {
        like_and_unlike()
    }
    
    
    
    
}



extension SingleMovieViewController{
    
    
    func viewSetUp(){
        if let value = value{
            let IMAGE_BASE_URL =  "https://image.tmdb.org/t/p/original" + value.backdropPath
            images.sd_setImage(with: URL(string: IMAGE_BASE_URL), placeholderImage: UIImage(named: ""))
            overView.text = value.overview
            name.text = value.title
            self.title = value.title
            rating.text = "Rating:\(String(value.voteAverage))"
            
            viewModel.allreadyFavourited(movieId: value.id, favourite: {[weak self] result in
                if result{
                    self?.favourite.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
                    self?.favBtn = true
                }else{
                    self?.favourite.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
                    self?.favBtn = value.favourite
                }
            })
            
        }else if let value = favValue{
            
            if let res = value.backdropPath{
                let IMAGE_BASE_URL =  "https://image.tmdb.org/t/p/original" + res
                images.sd_setImage(with: URL(string: IMAGE_BASE_URL), placeholderImage: UIImage(named: ""))
            }
            favourite.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            overView.text = value.overView
            name.text = value.title
            self.title = value.title
            rating.text = "Rating:\(String(value.voteAverage))"
            favBtn = value.favourite
        }
    }
    
    
    func like_and_unlike(){
        if favBtn{
            SnackBar.make(in: self.view, message: "Removed From Favourite", duration: .lengthShort).show()
            favourite.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            
            if let favValue = favValue{
                let result = Result(voteCount: Int(favValue.voteCount), posterPath: favValue.posterPath, id: Int(favValue.id), backdropPath: favValue.backdropPath, title: favValue.title ?? "", voteAverage: favValue.voteAverage, overview: favValue.overView, releaseDate: favValue.releaseDate)
                viewModel.delete(item: result)
                
                
            }else{
                if let value = value{
                    let result = Result(voteCount: value.voteCount, posterPath: value.posterPath, id: value.id, backdropPath: value.backdropPath, title: value.title, voteAverage: value.voteAverage, overview: value.overview, releaseDate: value.releaseDate)
                    viewModel.delete(item: result)
                    
                }
            }
        }else{
            favourite.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            SnackBar.make(in: self.view, message: "Added To Favourite", duration: .lengthLong).show()
            if let value = value{
                let result = Result(voteCount: value.voteCount, posterPath: value.posterPath, id: value.id, backdropPath: value.backdropPath, title: value.title, voteAverage: value.voteAverage, overview: value.overview, releaseDate: value.releaseDate)
                viewModel.save(item: result)
                
            }else{
                if let favValue = favValue{
                    let result = Result(voteCount: Int(favValue.voteCount), posterPath: favValue.posterPath, id: Int(favValue.id), backdropPath: favValue.backdropPath, title: favValue.title ?? "", voteAverage: favValue.voteAverage, overview: favValue.overView, releaseDate: favValue.releaseDate)
                    viewModel.save(item: result)
                    
                }
            }
        }
        favBtn = !favBtn
    }
}
