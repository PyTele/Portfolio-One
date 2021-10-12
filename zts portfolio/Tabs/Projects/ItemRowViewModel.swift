//
//  ItemRowViewModel.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 11/10/2021.
//

import Foundation

extension ItemRowView {
    class ViewModel: ObservableObject {
        let project: Project
        let item: Item

        var title: String {
            item.itemTitle
        }

        var icon: String {
            if item.complete {
                return "checkmark.circle"
            } else if item.priority == 3 {
                return "exclamationmark.octagon.fill"
            } else if item.priority == 2 {
                return "exclamationmark.triangle.fill"
            } else if item.priority == 1 {
                return "exclamationmark.circle.fill"
            } else {
                return "checkmark.circle"
            }
        }

        var color: String? {
            if item.complete {
                return "green"
            } else if item.priority == 3 {
                return "red"
            } else if item.priority == 2 {
                return "yellow"
            } else if item.priority == 1 {
                return "green"
            } else {
                return nil
            }
        }

        var label: String {
            if item.complete {
                return "\(item.itemTitle), completed."
            } else if item.priority == 3 {
                return "\(item.itemTitle), High Priority Item"
            } else if item.priority == 2 {
                return "\(item.itemTitle), Medium Priority Item"
            } else if item.priority == 1 {
                return "\(item.itemTitle), Low Priority Item"
            } else {
                return "\(item.itemTitle)"
            }
        }

        init(project: Project, item: Item) {
            self.project = project
            self.item = item
        }
    }
}
