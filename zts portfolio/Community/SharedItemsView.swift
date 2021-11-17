//
//  SharedItemsView.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 17/11/2021.
//

import CloudKit
import SwiftUI

struct SharedItemsView: View {
    let project: SharedProject
    
    @State private var items = [SharedItem]()
    @State private var itemLoadState = LoadState.inactive
    
    var body: some View {
        List {
            Section {
                switch itemLoadState {
                case .inactive, .loading:
                    ProgressView()
                case .noResults:
                    Text("No results")
                case .success:
                    ForEach(items) { item in
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            
                            if item.detail.isEmpty == false {
                                Text(item.detail)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(project.title)
        .onAppear(perform: fetchSharedItems)
    }
    
    func fetchSharedItems() {
        guard itemLoadState == .inactive else { return }
        itemLoadState = .loading
        
        let recordID = CKRecord.ID(recordName: project.id)
        let reference = CKRecord.Reference(recordID: recordID, action: .none)
        
        let pred = NSPredicate(format: "project == %@", reference)
        let sort = NSSortDescriptor(key: "title", ascending: true)
        let query = CKQuery(recordType: "Item", predicate: pred)
        query.sortDescriptors = [sort]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["title", "detail", "complete"]
        operation.resultsLimit = 50
        
        operation.recordFetchedBlock = { record in
            let id = record.recordID.recordName
            let title = record["title"] as? String ?? "No title"
            let detail = record["detail"] as? String ?? ""
            let complete = record["complete"] as? Bool ?? false
            
            let sharedItem = SharedItem(id: id, title: title, detail: detail, complete: complete)
            items.append(sharedItem)
            itemLoadState = .success
        }
        
        operation.queryCompletionBlock = { _, _ in
            if items.isEmpty {
                itemLoadState = .noResults
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
}

struct SharedItemsView_Previews: PreviewProvider {
    static var previews: some View {
        SharedItemsView(project: SharedProject.example)
    }
}
