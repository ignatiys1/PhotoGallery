//
//  Structures.swift
//  Photo Gallery
//
//  Created by Ignat Urbanovich on 19.12.21.
//

import Foundation
import UIKit

struct Credit: Decodable {
    var photo_url: String?
    var user_name: String?
    var user_url: String?
    var colors: [String] = []
}
