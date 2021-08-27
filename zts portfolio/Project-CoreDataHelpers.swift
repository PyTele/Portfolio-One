//
//  PRoject-CoreDataHelpers.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 04/06/2021.
//

import SwiftUI
import Foundation

extension Project {
    static let colors = ["Pink", "Purple", "Red", "Orange", "Gold", "Green", "Teal", "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]
    
    var projectTitle: String {
        title ?? NSLocalizedString("New Project", comment: "Create a new project")
    }
    
    var projectDetail: String {
        detail ?? ""
    }
    
    var projectColor: String {
        color ?? "Light Blue"
    }
    
    var projectItems: [Item] {
        items?.allObjects as? [Item] ?? []
    }
    
    var projectItemsDefaultSorted: [Item] {
        
        projectItems.sorted { first, second in
            if first.complete == false {
                if second.complete == true {
                    return true
                }
            } else if first.complete == true {
               if second.complete == false {
                    return false
                }
            }
            
            if first.priority > second.priority {
                return true
            } else if first.priority < second.priority {
                return false
            }
            
            return first.itemCreationDate < second.itemCreationDate
        }
    }
    
    var completionAmount: Double {
        let originalItems = items?.allObjects as? [Item] ?? []
        guard originalItems.isEmpty == false else { return 0 }
        
        let completedItems = originalItems.filter(\.complete)
        return Double(completedItems.count) / Double(originalItems.count)
    }
    
    var label: LocalizedStringKey {
        LocalizedStringKey("\(projectTitle), \(projectItems.count) Items, \(completionAmount * 100, specifier: "%g")% complete.")
    }
    
    static var example: Project {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let project = Project(context: viewContext)
        project.title = "Example Project"
        project.detail = "This is an example project"
        project.closed = true
        project.creationDate = Date()
        
        return project
    }
    
    func projectItemsSort(using sortOrder: Item.SortOrder) -> [Item] {
        switch sortOrder {
        case .title:
            return projectItems.sorted(by: \Item.itemTitle)
        case .creationDate:
            return projectItems.sorted(by: \Item.itemCreationDate)
        case .optimized:
            return projectItemsDefaultSorted
        }
    }
}
