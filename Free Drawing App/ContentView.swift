//
//  ContentView.swift
//  Free Drawing App
//
//  Created by Ivan Rep on 02.03.2023..
//

import ComposableArchitecture
import SwiftUI

struct DrawingCanvas: ReducerProtocol {
    struct State: Equatable {
        var strokes: [[CGPoint]]
    }

    enum Action {
        case addPoint(CGPoint)
        case finishStroke
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .addPoint(let point):
                if state.strokes.isEmpty {
                    state.strokes.append([])
                }
                let count = state.strokes.count
                state.strokes[count - 1].append(point)
                return .none
            case .finishStroke:
                state.strokes.append([])
                return .none
            }
        }
    }

    struct View {
        let store: StoreOf<DrawingCanvas>
    }
}

extension DrawingCanvas.View: View {
    var body: some View {
        WithViewStore(store) { viewStore in
            Canvas { context, size in
                for stroke in viewStore.strokes {
                    let path = Path(curving: stroke)

                    var context = context

                    context.stroke(
                        path,
                        with: .color(.blue),// .color(stroke.color),
                        style: StrokeStyle(
                            lineWidth: 5,
                            lineCap: .round, lineJoin: .round
//                            dash: [1, stroke.spacing * stroke.width]
                        )
                    )
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        viewStore.send(.addPoint(value.location))
                    }
                    .onEnded { _ in
                        viewStore.send(.finishStroke)
                    }
            )
        }
    }
}

extension Path {
    init(curving points: [CGPoint]) {
        self = Path { path in
            guard let firstPoint = points.first else { return }

            path.move(to: firstPoint)
            var previous = firstPoint

            for point in points.dropFirst() {
                let middle = CGPoint(x: (point.x + previous.x) / 2, y: (point.y + previous.y) / 2)
                path.addQuadCurve(to: middle, control: previous)
                previous = point
            }

            path.addLine(to: previous)
        }
    }
}
