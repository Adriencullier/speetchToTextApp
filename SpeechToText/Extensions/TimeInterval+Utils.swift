//
//  TimeInterval+Utils.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 17/06/2022.
//

import Foundation

extension TimeInterval {
    func minuteAndSecondToString() -> String {
        let timeFormatter = DateComponentsFormatter()
        timeFormatter.allowedUnits = [.minute, .second]
        timeFormatter.unitsStyle = .abbreviated
        guard let timeStr = timeFormatter.string(from: self) else {
            fatalError("this cas should not happen")
        }
        return timeStr
    }
}
