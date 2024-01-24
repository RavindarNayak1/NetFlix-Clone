//
//  extentions.swift
//  NetflixClone
//
//  Created by Ravindar Nayak on 11/09/23.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased()+self.lowercased().dropFirst()
    }
    
}
