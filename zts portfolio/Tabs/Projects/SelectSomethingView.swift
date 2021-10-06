//
//  SelectSomethingView.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 03/07/2021.
//

import SwiftUI

struct SelectSomethingView: View {
    var body: some View {
        Text("Please select somthing from the menu to begin.")
            .italic()
            .foregroundColor(.secondary)
    }
}

struct SelectSomethingView_Previews: PreviewProvider {
    static var previews: some View {
        SelectSomethingView()
    }
}
