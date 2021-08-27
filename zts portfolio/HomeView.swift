//
//  HomeView.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 02/06/2021.
//

import CoreData
import SwiftUI

struct HomeView: View {
    static let tag: String? = "Home"
    let items: FetchRequest<Item>
    
    @FetchRequest(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)], predicate: NSPredicate(format: "closed = false")) var projects: FetchedResults<Project>
    
    @EnvironmentObject var dataController: DataController
    
    init() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "complete = false")

        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Item.priority, ascending: false)
        ]

        request.fetchLimit = 10
        items = FetchRequest(fetchRequest: request)
    }
    
    var projectRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(projects, content: ProjectSummaryView.init)
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                VStack(alignment: .leading) {
                    ItemListView(title: "Up next", items: items.wrappedValue.prefix(3))
                    ItemListView(title: "More to explore", items: items.wrappedValue.dropFirst(3))
                    
                            Button {
                                dataController.deleteAll()
                                try? dataController.createSampleData()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color.secondarySystemGroupedBackground)
                                    
                                    Text("Add Data")
                                }
                            }
                            
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .padding(.bottom)
                }
                .padding(.horizontal)
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
