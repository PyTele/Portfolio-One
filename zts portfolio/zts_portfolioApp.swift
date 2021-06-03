//
//  zts_portfolioApp.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 23/05/2021.
//

import SwiftUI

@main
struct zts_portfolioApp: App {
    @StateObject var dataController: DataController
    
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
