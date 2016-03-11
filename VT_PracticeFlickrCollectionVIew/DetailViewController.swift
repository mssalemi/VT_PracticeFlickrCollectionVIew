//
//  DetailViewController.swift
//  VT_PracticeFlickrCollectionVIew
//
//  Created by Mehdi Salemi on 3/10/16.
//  Copyright © 2016 MxMd. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate,  CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let locationManager = CLLocationManager()
    
    var photos : [Photo]!
    var cordinates : CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.reloadData()
        self.mapView.delegate = self
        self.mapView.setCenterCoordinate(cordinates, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        for photo in photos {
            print(photo.title)
            print(photo.image)
        }
        print(cordinates)
        collectionView.reloadData()
        print(mapView.centerCoordinate)
        mapView.setZoomByDelta(0.1, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PhotoDetailCell
    
        let photo = photos[indexPath.row]
        cell.photoImageView.image = photo.image
        cell.photoTitleLabel.text = photo.title
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        
    }
    
}

extension MKMapView {
    
    func setZoomByDelta(delta: Double, animated: Bool) {
        var _region = region;
        var _span = region.span;
        _span.latitudeDelta *= delta;
        _span.longitudeDelta *= delta;
        _region.span = _span;
        
        setRegion(_region, animated: animated)
    }
}
