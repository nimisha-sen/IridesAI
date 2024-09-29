//
//  DiversityTheme.swift
//  Lamei
//
//  Created by Siddharth S on 29/09/24.
//

import Foundation

// Represents a diversity theme with a theme name and description
struct DiversityTheme: Codable, Hashable {
    let theme: String
    let description: String
}

// Represents the overall analysis structure returned by the LLM
struct DiversityAnalysis: Codable, Hashable {
    let diversityThemes: [DiversityTheme]
    let implicitDiversity: Bool
    let explicitDiversityMentions: Int

    enum CodingKeys: String, CodingKey {
        case diversityThemes = "diversity_themes"
        case implicitDiversity = "implicit_diversity"
        case explicitDiversityMentions = "explicit_diversity_mentions"
    }
}
