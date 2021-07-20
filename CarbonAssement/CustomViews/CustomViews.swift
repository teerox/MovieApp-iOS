//
//  CustomLayout.swift
//  CarbonAssement
//
//  Created by Anthony Odu on 10/07/2021.
//

import Foundation
import UIKit

protocol CustomLayoutDelegate: AnyObject {
  func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize
}



class CustomLayout: UICollectionViewLayout {
  
  weak var delegate: CustomLayoutDelegate!
  
  var numberOfColumns = 2
  var cellPadding: CGFloat = 8
  
  fileprivate var cache = [UICollectionViewLayoutAttributes]()
  
  fileprivate var contentHeight: CGFloat = 0
  
    
    
  fileprivate var contentWidth: CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    
    return collectionView.bounds.width
  }
  
    
    
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
    
    
    
  
  override func prepare() {
    guard cache.isEmpty, let collectionView = collectionView else {
      return
    }
    
    let columnWidth = contentWidth / CGFloat(numberOfColumns)
    var xOffest = [CGFloat]()
    
    for column in 0..<numberOfColumns {
      xOffest.append(CGFloat(column) * columnWidth)
    }
    
    var column = 0
    var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
    
    for item in 0..<collectionView.numberOfItems(inSection: 0) {
      
      let indexPath = IndexPath(item: item, section: 0)
      
      let photoSize = delegate.collectionView(collectionView, sizeOfPhotoAtIndexPath: indexPath)
      
      let cellWidth = columnWidth
      var cellHeight = photoSize.height * cellWidth / photoSize.width
      
      cellHeight = cellPadding * 2 + cellHeight
      
      let frame = CGRect(x: xOffest[column], y: yOffset[column], width: cellWidth, height: cellHeight)
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
      
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      cache.append(attributes)
      
      contentHeight = max(contentHeight, frame.maxY)
      yOffset[column] = yOffset[column] + cellHeight
      
      if numberOfColumns > 1 {
        var isColumnChanged = false
        for index in (1..<numberOfColumns).reversed() {
          if yOffset[index] >= yOffset[index - 1] {
            column = index - 1
            isColumnChanged = true
          }
          else {
            break
          }
        }
        
        if isColumnChanged {
          continue
        }
      }
      
      column = column < (numberOfColumns - 1) ? (column + 1) : 0
    }
    
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
    var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        visibleLayoutAttributes.append(attributes)
      }
    }
    
    return visibleLayoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension UIViewController{
    
    
    func showEmpty(tableView:UICollectionView,firstText:String){
   //Text Label
   let textLabel = UILabel()
   textLabel.textColor = .white
   textLabel.font = .boldSystemFont(ofSize: 16)
   textLabel.widthAnchor.constraint(equalToConstant: tableView.frame.width).isActive = true
   textLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
   textLabel.text  = firstText
   textLabel.textAlignment = .center
   

   //Stack View
   let stackView   = UIStackView()
   stackView.axis  = NSLayoutConstraint.Axis.vertical
   stackView.distribution  = UIStackView.Distribution.equalSpacing
   stackView.alignment = UIStackView.Alignment.center
   stackView.spacing   = 0
   
   

   stackView.addArrangedSubview(textLabel)
   stackView.translatesAutoresizingMaskIntoConstraints = false
   tableView.addSubview(stackView)

   
   //Constraints
   stackView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
   stackView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true

 
 }
    
    func showAlert(message:String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}


extension Notification.Name {

    static let reloadMovies = Notification.Name("reloadMoviesList")

}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
