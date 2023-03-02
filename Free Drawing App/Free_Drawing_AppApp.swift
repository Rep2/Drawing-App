//
//  Free_Drawing_AppApp.swift
//  Free Drawing App
//
//  Created by Ivan Rep on 02.03.2023..
//

import SwiftUI

@main
struct Free_Drawing_AppApp: App {
    var body: some Scene {
        WindowGroup {
            DrawingCanvas.View(
                store: .init(
                    initialState: .init(strokes: []),
                    reducer: DrawingCanvas()
                )
            )
        }
    }
}
