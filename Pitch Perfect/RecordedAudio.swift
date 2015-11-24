//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by gakshay on 10/31/15.
//  Copyright © 2015 gakshay. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL!, title: String!){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
