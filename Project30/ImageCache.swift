//
//  ImageCache.swift
//  Project30
//
//  Created by kirsty darbyshire on 20/05/2019.
//  Copyright © 2019 Hudzilla. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    // singleton, only one cache, everyone shares it
    static let sharedCache = ImageCache()
    
    var images = [String: UIImage]() // dictionary to cache our images
    weak var owner: SelectionViewController!
    
    func processImage(name currentImage: String) -> UIImage? {
        // if it's cached, have at it straight away
        if let image = getCachedImage(name: currentImage) {
            return image
        }
        
        let imageRootName = currentImage.replacingOccurrences(of: "Large", with: "Thumb")
        guard let path = Bundle.main.path(forResource: imageRootName, ofType: nil) else {
            return nil
        }
        guard let original = UIImage(contentsOfFile: path) else {
            return nil
        }
        
        let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
        let renderer = UIGraphicsImageRenderer(size: renderRect.size)
        
        let rounded = renderer.image { ctx in
            ctx.cgContext.addEllipse(in: renderRect)
            ctx.cgContext.clip()
            
            original.draw(in: renderRect)
        }
        
        // add this to our cache
        cacheImage(name: currentImage, image: rounded)
        
        return rounded
        
    }
    
    func processBigImage(name title: String) -> UIImage {
        let cacheName = "big" + title
        // if it's cached, have at it straight away
        if let image = getCachedImage(name: cacheName) {
            return image
        }

        guard let path = Bundle.main.path(forResource: title, ofType: nil) else {
            fatalError("Image loading \(title) has gone horribly wrong!")
        }
        let original = UIImage(contentsOfFile: path)!
        let maxDimension = max(owner.view.frame.width, owner.view.frame.height)
        
        let renderRect = CGRect(origin: .zero, size: CGSize(width: maxDimension, height: maxDimension))
        let renderer = UIGraphicsImageRenderer(size: renderRect.size)
        
        let rounded = renderer.image { ctx in
            
            ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: renderRect.size))
            ctx.cgContext.closePath()
            
            original.draw(in: renderRect)
        }
        
        // add this to our cache
        cacheImage(name: cacheName, image: rounded)
        
        return rounded
    }
    
    private func getCachedImage(name: String) -> UIImage? {
        if let image = images[name] {
            print ("image \(name) is found in the cache!")
            return image
        }
        // this is where you'd look for a saved version of the image if it wasn't in the cache
        return nil
    }
    
    private func cacheImage(name: String, image: UIImage) {
        // this is where you'd put the logic to limit what was stored by size or count or age...
        // also where you'd save things
        images[name] = image
    }
    
    func printCacheContents() {
        for (key, _) in images {
            print("\(key) is cached.")
        }

    }

}
