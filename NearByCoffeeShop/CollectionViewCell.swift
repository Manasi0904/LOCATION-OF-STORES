//
//  CollectionViewCell.swift
//  NearByCoffeeShop
//
//  Created by Kumari Mansi on 17/01/25.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
   
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.cornerRadius = 14
        imageView.layer.cornerRadius = 10
        
        nameLabel.font = UIFont(name: "Circe Regular", size: 14)
        openLabel.font = UIFont(name: "Circe Regular", size: 10)
        timeLabel.font = UIFont(name: "Circe Regular", size: 10)
        distanceLabel.font = UIFont(name: "Circe Regular", size: 10)
       
        directionButton.titleLabel?.font = UIFont(name: "Circe Regular", size: 10)
        menuButton.titleLabel?.font = UIFont(name: "Circe Regular", size: 10)
        
    }
    
//    func configure(with viewModel: StoreViewModel) {
//        nameLabel?.text = viewModel.storeName
//       // StoreAddress?.text = viewModel.storeAddress
//        timeLabel?.text = viewModel.businessHours
//
//        DispatchQueue.global().async {
//            if let url = viewModel.storeImagePath,
//               let data = try? Data(contentsOf: url) {
//                DispatchQueue.main.async {
//                    self.imageView?.image = UIImage(data: data)
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self.imageView?.image = UIImage(systemName: "photo")
//                }
//            }
//        }
//    }
//
//}


    func configure(with viewModel: StoreViewModel) {
           nameLabel?.text = viewModel.storeName
          
           timeLabel?.text = viewModel.businessHours

          
           updateOpenStatus(for: viewModel)

           DispatchQueue.global().async {
               if let url = viewModel.storeImagePath,
                  let data = try? Data(contentsOf: url) {
                   DispatchQueue.main.async {
                       self.imageView?.image = UIImage(data: data)
                   }
               } else {
                   DispatchQueue.main.async {
                       self.imageView?.image = UIImage(systemName: "photo")
                   }
               }
           }
       }
       
       
       func updateOpenStatus(for viewModel: StoreViewModel) {
           guard let businessHours = viewModel.businessHours else {
               openLabel.text = "Closed"
               openLabel.textColor = .red
               return
           }
           
          
           let currentTime = Date()
           let formatter = DateFormatter()
           formatter.dateFormat = "HH:mm"
           let currentTimeString = formatter.string(from: currentTime)

           let hours = businessHours.split(separator: "-")
           
           if hours.count == 2 {
               let openTimeString = String(hours[0])
               let closeTimeString = String(hours[1])
               
               if currentTimeString >= openTimeString && currentTimeString <= closeTimeString {
                   openLabel.text = "Open"
                   openLabel.textColor = .green
               } else {
                   openLabel.text = "Closed"
                   openLabel.textColor = .red
               }
           } else {
               openLabel.text = "Closed"
               openLabel.textColor = .red
           }
       }
   }
