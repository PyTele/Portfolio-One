//
//  zts_portfolioApp.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 23/05/2021.
//

import SwiftUI

@main
struct zts_portfolioApp: App { // swiftlint:disable:this type_name
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
                .onReceive(
//                    Automatically save when we detect that we are no longer
//                    the foreground app. Use this rather than scene phase
//                    API so we can prot to MacOS, where scene phase won't detect
//                    our app loosing focus as of MacOS 11.1
                    NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                    perform: save
                )
        }
    }

    func save(_ note: Notification) {
        dataController.save()
    }
}
