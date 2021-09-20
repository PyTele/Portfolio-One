//
//  Award.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 19/07/2021.
//

import Foundation

struct Award: Decodable, Identifiable {
    var id: String { name } // swiftlint:disable:this identifier_name
    let name: String
    let description: String
    let color: String
    let criterion: String
    let value: Int
    let image: String

    static let allAwards = Bundle.main.decode([Award].self, from: "Awards.json")
    static let example = allAwards[0]
}
