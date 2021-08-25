//
//  ItemRowView.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 08/06/2021.
//

import SwiftUI

struct ItemRowView: View {
    @ObservedObject var project: Project
    @ObservedObject var item: Item
    
    var icon: some View {
        if item.complete {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(Color.green)
        } else if item.priority == 3 {
            return Image(systemName: "exclamationmark.octagon.fill")
                .foregroundColor(Color.red)
        } else if item.priority == 2 {
            return Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(Color.yellow)
        } else if item.priority == 1 {
            return Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(Color.green)
        } else {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(.clear)
        }
    }
    
    var label: Text {
        if item.complete {
            return Text("\(item.itemTitle), completed.")
        } else if item.priority == 3 {
            return Text("\(item.itemTitle), High Priority Item")
        } else if item.priority == 2 {
            return Text("\(item.itemTitle), Medium Priority Item")
        } else if item.priority == 1 {
            return Text("\(item.itemTitle), Low Priority Item")
        } else {
            return Text("\(item.itemTitle)")
        }
    }
    
    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            Label {
                Text(item.itemTitle)
            } icon: {
                icon
            }
        }
        .accessibilityLabel(label)
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(project: Project.example, item: Item.example)
    }
}
