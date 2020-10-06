//
//  DemoURL.swift
//  Cassini
//
//  Created by In Taek Cho on 2020-09-22.
//

import Foundation

struct DemoURL {
    static let Stanford = "http://comm.stanford.edu/mm/2013/02/mcclatchy-hall-directions.jpg"
    
    static let NASA = [
        "Cassini" : "http://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg",
        "Earth" : "http://www.nasa.gov/sites/default/files/wave_earth_mosaic_3.jpg",
        "Saturn" : "http://www.nasa.gov/sites/default/files/saturn_collage.jpg"
    ]
    
    static func NASAImageNamed(imageName: String?) -> URL? {
        if let urlstring = NASA[imageName ?? ""] {
            return URL(string: urlstring)
        } else {
             return nil
        }
    }
}
