//
//  Extension+Date.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 08.02.2023.
//

import Foundation

extension Date {
    func dateFormatString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .long
        dateFormatter.locale = .current
       return dateFormatter.string(from: self)
    }
}
