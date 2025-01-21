//
//  ViewController.swift
//  NearByCoffeeShop
//
//  Created by Kumari Mansi on 17/01/25.
//






import UIKit
import MapKit
class ViewController: UIViewController {
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var nearBylabel: UILabel!
    @IBOutlet weak var storeCell: UICollectionView!
    
    var storeViewModels: [StoreViewModel] = []
    var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        nearBylabel.font = UIFont(name: "Circe-Bold", size: 16)
        
        storeCell.delegate = self
        storeCell.dataSource = self
        
        storeCell.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        storeCell.contentInsetAdjustmentBehavior = .never
        fetchStoreData()
        setupMapView()
        storeCell.isScrollEnabled = true
        storeCell.isUserInteractionEnabled = true
        
        if let flowLayout = storeCell.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            
            
            
        }
        
        
        func setupMapView() {
            
            mapView = MKMapView(frame: self.view.bounds)
            mapView.delegate = self
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            mapView.layer.zPosition = -1
             mapView.isUserInteractionEnabled = false
            self.view.addSubview(mapView)
            
            
            let initialCoordinate = CLLocationCoordinate2D(latitude: 28.592777, longitude: 77.31881081534289)
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: initialCoordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
    }

//    
//        func setupMapView() {
//                
//                mapView = MKMapView(frame: self.view.bounds)
//                mapView.delegate = self
//                mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//                mapView.layer.zPosition = -1
//               // mapView.isUserInteractionEnabled = true
//
//                self.view.addSubview(mapView)
//      }
//        
//        let initialCoordinate = CLLocationCoordinate2D(latitude: 28.592777, longitude: 77.31881081534289)
//        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        let region = MKCoordinateRegion(center: initialCoordinate, span: span)
//        mapView.setRegion(region, animated: true)
//        
//        
//       addGestureRecognizers()
//        
//        
//
//         }
//         
//         func addGestureRecognizers() {
//            
//             let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
//             mapView.addGestureRecognizer(panGesture)
//            
//             
//             let collectionPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleCollectionPanGesture(_:)))
//             collectionPanGesture.cancelsTouchesInView = false
//             storeCell.addGestureRecognizer(collectionPanGesture)
//         }
//         
//         @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
//             if gesture.state == .changed {
//             }
//         }
//         
//         @objc func handleCollectionPanGesture(_ gesture: UIPanGestureRecognizer) {
//             if gesture.state == .changed {
//             }
//         }
//   
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//            return true
//        }
//    
//    
    
    
    
    func fetchStoreData() {
        let parameters: [String: String] = [
            "pageSize": "10",
            "latitude": "28.592777",
            "longitude": "77.31881081534289",
            "page": "0"
        ]
        
        let headers: [String: String] = [
            "Content-Type": "application/json",
            "GUEST_USER_TOKEN": "5LlYVeSLsLCmCc0Js7CxpvSSTa3bivSqtZa09lMl46R0LwQ7Wu59ee+g3RKnMzo3VAhaNKgzPHDITfoU3l1w==",
            "DEVICE_TYPE": "iOS",
            "COUNTRY": "India",
            "modifiedTime": "1733721216400",
            "APP_VERSION": "2.1.8.8",
            "Accept-Language": "EN"
        ]
        
        ApiService.shared.fetchData(urlString: "http://restaurant-api.reciproci.com/api/ns/store/unsec/v1/getNearByStores",
                                    parameters: parameters,
                                    headers: headers) { (result: Result<StoreResponse, Error>) in
            switch result {
            case .success(let storeResponse):
                print("API Response: \(storeResponse)")
                self.storeViewModels = storeResponse.stores.map { StoreViewModel(store: $0) }
                DispatchQueue.main.async {
                    self.storeCell.reloadData()
                    self.addStoreAnnotations(stores: storeResponse.stores)
                }
            case .failure(let error):
                print("Error fetching stores: \(error.localizedDescription)")
            }
            
            
        }
    }
    
    func addStoreAnnotations(stores: [stores]) {
        mapView.removeAnnotations(mapView.annotations)
        
        for store in stores {
          
            guard let latitude = Double(store.latitude),
                  let longitude = Double(store.longitude) else {
                print("Invalid latitude/longitude for store: \(store.storeName)")
                continue
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            addAnnotation(title: store.storeName, coordinate: coordinate)
        }
        
      
        if let firstStore = stores.first {
            guard let latitude = Double(firstStore.latitude),
                  let longitude = Double(firstStore.longitude) else { return }
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func addAnnotation(title: String, coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
}


extension ViewController: MKMapViewDelegate {
   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       if annotation is MKUserLocation { return nil }

       let identifier = "StoreAnnotation"
       var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

       if annotationView == nil {
           annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
           annotationView?.canShowCallout = true
           annotationView?.pinTintColor = .red
       } else {
           annotationView?.annotation = annotation
       }

       return annotationView
   }
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let viewModel = storeViewModels[indexPath.row]
        cell.configure(with: viewModel)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let lay = collectionViewLayout as! UICollectionViewFlowLayout
        lay.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
               lay.minimumLineSpacing = 21.3
               return CGSize(width: 221, height: 200)
       
    }
}


