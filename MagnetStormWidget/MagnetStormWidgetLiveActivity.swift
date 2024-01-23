//
//  MagnetStormWidgetLiveActivity.swift
//  MagnetStormWidget
//
//  Created by SHIN MIKHAIL on 22.01.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MagnetStormWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MagnetStormWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MagnetStormWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MagnetStormWidgetAttributes {
    fileprivate static var preview: MagnetStormWidgetAttributes {
        MagnetStormWidgetAttributes(name: "World")
    }
}

extension MagnetStormWidgetAttributes.ContentState {
    fileprivate static var smiley: MagnetStormWidgetAttributes.ContentState {
        MagnetStormWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MagnetStormWidgetAttributes.ContentState {
         MagnetStormWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MagnetStormWidgetAttributes.preview) {
   MagnetStormWidgetLiveActivity()
} contentStates: {
    MagnetStormWidgetAttributes.ContentState.smiley
    MagnetStormWidgetAttributes.ContentState.starEyes
}
