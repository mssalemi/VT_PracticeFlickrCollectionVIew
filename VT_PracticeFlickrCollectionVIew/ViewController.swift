//
//  ViewController.swift
//  VT_PracticeFlickrCollectionVIew
//
//  Created by Mehdi Salemi on 3/9/16.
//  Copyright © 2016 MxMd. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var imageText: UIImageView!
    
    //Mark : UI Elements
    
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func go(sender: UIButton) {
        let long = Double(longitudeTextField.text!)
        let lat = Double(latitudeTextField.text!)
        
        getImagesFromCordinate(long!, lat: lat!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func getImagesFromCordinate(long : Double, lat: Double){
        
        activityIndicator.startAnimating()
        
        print("Starting Request")
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: createURL(long, lat: lat))
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
            print(photosDictionary)
            
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
                print("\(photo["title"]!) at URL ->  \(photo["url_m"]!)")
            }
            
            for photo in photos {
                print(photo.title)
                print(photo.image)
            }
            
            // Just for Testing to make sure the image Loaded Properly
            dispatch_async(dispatch_get_main_queue()) {
                print("Updating image with \(photos[0].title)")
                self.imageText.image = photos[0].image
                
                // Now Load new View Controller with Collection View Objects... Hopefully
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
                controller.photos = photos
                let
                cord = CLLocationCoordinate2DMake(Double(self.latitudeTextField.text!)!, Double(self.longitudeTextField.text!)!)
                controller.cordinates = cord
                self.navigationController!.pushViewController(controller, animated: true)
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
        return urlString
    }
    
}

