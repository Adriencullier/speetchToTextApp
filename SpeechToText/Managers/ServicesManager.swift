//
//  ServicesManager.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 10/06/2022.
//

import Foundation

final class ServicesManager {
    let recordsService: RecordsService
    
    init() {
        self.recordsService = RecordsService()
    }
}
