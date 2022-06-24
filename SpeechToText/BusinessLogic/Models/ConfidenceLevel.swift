//
//  ConfidenceLevel.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 24/06/2022.
//

import Foundation
import SwiftUI

/// Transcription confidence level
enum ConfidenceLevel {
    case good
    case medium
    case bad
    
    var description: String {
        switch self {
        case .good:
            return "Bon"
        case .medium:
            return "Moyen"
        case .bad:
            return "Mauvais"
        }
    }
    
    var smiley: String {
        switch self {
        case .good:
            return "🤩"
        case .medium:
            return "🤔"
        case .bad:
            return "🤬"
        }
    }
    
    var color: Color {
        switch self {
        case .good:
            return .green
        case .medium:
            return .orange
        case .bad:
            return .red
        }
    }
    
    var confidenceStr: String {
        return self.smiley
        + " "
        + "Niveau de confiance"
        + " "
        + self.description
        + " "
        + self.smiley
    }
}
