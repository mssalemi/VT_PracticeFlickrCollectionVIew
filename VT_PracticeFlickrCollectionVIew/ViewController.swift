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
        
        func completionHandler(photoArray : [Photo], cords : CLLocationCoordinate2D, page : Int) {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
            controller.photos = photoArray
            let cord = CLLocationCoordinate2DMake(Double(self.latitudeTextField.text!)!, Double(self.longitudeTextField.text!)!)
            controller.cordinates = cord
            controller.pages = page
            self.navigationController!.pushViewController(controller, animated: true)
            self.activityIndicator.stopAnimating()
        }
        
        FlickrClient.sharedClient().getPhotos(Double(self.latitudeTextField.text!)!, long: Double(self.longitudeTextField.text!)!, handler: completionHandler, random: false, pages: 1)
    }    
}

