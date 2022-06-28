//
//  ScanData.swift
//  ScanOcrApp
//
//  Created by Wahid on 28/06/22.
//

import Foundation

struct ScanData:Identifiable {
    var id = UUID()
    let content:String
    
    init(content:String) {
        self.content = content
    }
}
