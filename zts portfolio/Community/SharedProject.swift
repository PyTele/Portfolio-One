//
//  SharedProject.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 17/11/2021.
//

import Foundation

struct SharedProject: Identifiable {
    let id: String
    let title: String
    let detail: String
    let owner: String
    let closed: Bool
    static let example = SharedProject(
        id: "1",
        title: "Example",
        detail: "Detail",
        owner: "zerotwoswift",
        closed: false
    )
}
