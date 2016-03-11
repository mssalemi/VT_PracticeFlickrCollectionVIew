//
//  Constants.swift
//  VT_PracticeFlickrCollectionVIew
//
//  Created by Mehdi Salemi on 3/9/16.
//  Copyright © 2016 MxMd. All rights reserved.
//

struct Constants {
    
    //          https://api.flickr.com/services/rest/?
    //          method=flickr.photos.search
    //          &api_key=d52f65b6a7c1376da515bfe3d1a4d7a8
    //          &lat=43&lon=79
    //          &format=json
    //          &nojsoncallback=1
    
    // MARK: Flickr
    struct Flickr {
        static let APIBaseURL = "https://api.flickr.com/services/rest/?"
    }
    
    // MARK: Flickr Parameter Keys
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let latitude = "lat"
        static let longitude = "lon"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let Extras = "extras"
    }
    
    // MARK: Flickr Parameter Values
    struct FlickrParameterValues {
        static let APIKey = "198a0bf44842f55e073db26b0491efd2"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1"
        static let PhotoFromCordinateMethod = "flickr.photos.search"
        static let MediumURL = "url_m"
        
    }
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
}

/*
Virtual Tourist
Key:
198a0bf44842f55e073db26b0491efd2

Secret:
4c34ee1524c6bbe6
*/