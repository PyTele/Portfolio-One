//
//  ProjectSearch.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 20/10/2021.
//

import CoreSpotlight
import SwiftUI

struct ProjectSearch: View {
    @State private var searchText = ""
    
    @State var searchResults = [CSSearchableItem]()
    @State var searchQuery: CSSearchQuery?

    var body: some View {
        VStack {
            Button("Add to Spotlight", action: addToSpotlight)

            TextField("Search Spotlight", text: $searchText.onChange(search))
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            List(searchResults, id: \.uniqueIdentifier) { item in
                Text(item.attributeSet.title ?? "Unknown title")
            }
        }
    }

    func addToSpotlight() {
        let titles = ["Hello, World", "This is a test", "Testing 1, 2, 3", "Goodbye, World"]

        for title in titles {
            let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
            attributeSet.title = title

            let searchableItem = CSSearchableItem(
                uniqueIdentifier: title,
                domainIdentifier: nil,
                attributeSet: attributeSet
            )

            CSSearchableIndex.default().indexSearchableItems([searchableItem])
        }
    }

    func search() {
        searchQuery?.cancel()
        var matches = [CSSearchableItem]()

        let queryString = "title == \"*\(searchText)*\"c"
        searchQuery = CSSearchQuery(queryString: queryString, attributes: ["title"])

        searchQuery?.foundItemsHandler = { items in
            matches.append(contentsOf: items)
        }

        searchQuery?.completionHandler = { _ in
            DispatchQueue.main.async {
                self.searchResults = matches
            }
        }

        searchQuery?.start()
    }
}
