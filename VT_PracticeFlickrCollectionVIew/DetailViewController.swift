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
        
        activityIndicator.startAnimating()
        self.photos = [Photo]()
        collectionView.reloadData()
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: createURL(cordinates.longitude, lat: cordinates.latitude))
        let request = NSURLRequest(URL: url!)
        print(url!)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                print(parsedResult)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                print("Cannot create dictionary")
                return
            }
            print(photosDictionary["pages"])
            
            /* GUARD: Are the "photos" and "photo" keys in our result? */
            guard let photoArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String:AnyObject]] else {
                print("Cannot find keys '\(Constants.FlickrResponseKeys.Photos)' and '\(Constants.FlickrResponseKeys.Photo)' in \(parsedResult)")
                return
            }
            print(photoArray)
            
            var photos = [Photo]()
            
            print("Going Through Dictionary getting the items we need")
            for photo in photoArray {
                var newPhoto = Photo()
                newPhoto.title = photo["title"] as! String
                newPhoto.image = UIImage(data: NSData(contentsOfURL: NSURL(string: photo["url_m"] as! String)!)!)
                photos.append(newPhoto)
            }
            
            // Just for Testing to make sure the image Loaded Properly
            dispatch_async(dispatch_get_main_queue()) {
                // Now Load new View Controller with Collection View Objects... Hopefully
                self.photos = photos
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
        task.resume()

        
        
    }
    
    private func createURL(long: Double, lat: Double) -> String{
        var urlString = Constants.Flickr.APIBaseURL
        urlString += Constants.FlickrParameterKeys.Method + "=" + Constants.FlickrParameterValues.PhotoFromCordinateMethod
        urlString += "&" + Constants.FlickrParameterKeys.APIKey + "=" + Constants.FlickrParameterValues.APIKey
        urlString += "&" + Constants.FlickrParameterKeys.latitude + "=\(lat)"
        urlString += "&" + Constants.FlickrParameterKeys.longitude + "=\(long)"
        urlString += "&" + Constants.FlickrParameterKeys.Format + "=" + Constants.FlickrParameterValues.ResponseFormat
        urlString += "&" + Constants.FlickrParameterKeys.NoJSONCallback + "=" + Constants.FlickrParameterValues.DisableJSONCallback
        urlString += "&" + Constants.FlickrParameterKeys.Extras + "=" + Constants.FlickrParameterValues.MediumURL
        urlString += "&" + Constants.FlickrParameterKeys.PerPage + "=" + Constants.FlickrParameterValues.PerPage
        urlString += "&" + Constants.FlickrParameterKeys.Page + "=" + "\(Int(arc4random_uniform(UInt32(pages!))))"
        return urlString
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
