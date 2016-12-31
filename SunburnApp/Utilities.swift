//
//  Utilities.swift
//  SunburnApp
//
//  Created by Jean Weatherwax on 12/30/16.
//  Copyright © 2016 Jean Weatherwax. All rights reserved.
//

import Foundation

class Utilities {
    
    func getStorage () -> UserDefaults {
        return UserDefaults.standard
    }
    
    func setSkinType (value: String) {
        let defaults = getStorage()
        defaults.setValue(value, forKey: defaultsKeys.skinType)
        defaults.synchronize()
    }
    
    func getSkinType () -> String {
        let defaults = getStorage()
        if let result = defaults.string(forKey: defaultsKeys.skinType) {
            return result
        } else {
            return SkinType().type1
        }
        
    }
    
}


