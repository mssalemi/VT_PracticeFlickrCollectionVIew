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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBAction func randomPhotos(sender: UIButton) {
        newCollection()
    }
    
    var photos : [Photo]!
    var cordinates : CLLocationCoordinate2D!
    var pages : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.reloadData()
        self.mapView.delegate = self
        self.mapView.setCenterCoordinate(cordinates, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        collectionView.reloadData()
        mapView.setZoomByDelta(0.1, animated: true)
        print(pages)
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
    
    func newCollection(){
        
        func completionHandler(photoArray : [Photo], cordinates : CLLocationCoordinate2D, page : Int) {
            self.photos = photoArray
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
            self.newCollectionButton.enabled = true
        }
        newCollectionButton.enabled = false
        self.activityIndicator.startAnimating()
        FlickrClient.sharedClient().getPhotos(cordinates.latitude, long: cordinates.longitude, handler: completionHandler, random: true, pages: pages)
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
