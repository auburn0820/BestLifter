//
//  Best_LifterApp.swift
//  Best Lifter
//
//  Created by νΌμμ on 2021/04/04.
//

import SwiftUI

@main
struct Best_LifterApp: App {
    //    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDeleagte
//    let persistenceController = PersistenceController.shared
    
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            Main()
        }
    }
}
