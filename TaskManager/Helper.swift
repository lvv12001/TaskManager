//
//  DateHelper.swift
//  TaskManager
//
//  Created by Viatcheslav Lebedev on 31.05.2022.
//

import Foundation
import SwiftUI

// some helpers...
class Helper {
    
    static let screen = UIScreen.main.bounds
    
    static func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateStr = formatter.string(from: date)
        return dateStr
    }
    
    
}
