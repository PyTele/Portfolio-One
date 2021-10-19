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
    @StateObject var unlockManager: UnlockManager

    init() {
        let dataController = DataController()
        let unlockManager = UnlockManager(dataController: dataController)
        
        _dataController = StateObject(wrappedValue: dataController)
        _unlockManager = StateObject(wrappedValue: unlockManager)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(unlockManager)
                .onReceive(
//                    Automatically save when we detect that we are no longer
//                    the foreground app. Use this rather than scene phase
//                    API so we can port to MacOS, where scene phase won't detect
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
