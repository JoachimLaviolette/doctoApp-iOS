//
//  ImageService.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 25/12/2019.
//  Copyright © 2019 LAVIOLETTE JOACHIM. All rights reserved.
//

import UIKit
import Foundation

enum StorageType {
    case UserDefaults
    case FileSystem
}

class ImageService {
    // Store the given image in the given storage type
    public func store(image: UIImage, key: String, storageType: StorageType) {
        if let pngRepresentation = image.pngData() {
            switch storageType {
                case .FileSystem:
                    if let filePath = self.filePath(imageKey: key) {
                        do { try pngRepresentation.write(to: filePath, options: .atomic) }
                        catch let e { print("The following error occurred when trying to save the file on disk: ", e) }
                    }
                case .UserDefaults:
                    UserDefaults.standard.set(pngRepresentation, forKey: key)
            }
        }
    }
    
    // Retrieve an image from the given storage type
    public func retrieve(key: String, storageType: StorageType) -> UIImage? {
        switch storageType {
            case .FileSystem:
                if let filePath = self.filePath(imageKey: key),  let fileData = FileManager.default.contents(atPath: filePath.path), let image = UIImage(data: fileData) { return image }
            case .UserDefaults:
                if let imageData = UserDefaults.standard.object(forKey: key) as? Data, let image = UIImage(data: imageData) { return image }
        }
        
        return nil
    }
    
    // Build a file path for the given image key
    private func filePath(imageKey: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(imageKey + ".png")
    }
}
