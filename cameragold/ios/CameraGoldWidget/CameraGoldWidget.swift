import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), widgetData: WidgetData.placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), widgetData: WidgetData.placeholder)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Load widget data from shared container
        let widgetData = loadWidgetData()
        
        let currentDate = Date()
        let entry = SimpleEntry(date: currentDate, widgetData: widgetData)
        entries.append(entry)

        // Schedule next update in 15 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
        completion(timeline)
    }
    
    private func loadWidgetData() -> WidgetData {
        guard let userDefaults = UserDefaults(suiteName: "group.com.cameragold.app.widgets"),
              let data = userDefaults.data(forKey: "widget_data") else {
            return WidgetData.placeholder
        }
        
        do {
            let decoder = JSONDecoder()
            let widgetData = try decoder.decode(WidgetData.self, from: data)
            return widgetData
        } catch {
            print("Failed to decode widget data: \(error)")
            return WidgetData.placeholder
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let widgetData: WidgetData
}

struct CameraGoldWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(widgetData: entry.widgetData)
        case .systemMedium:
            MediumWidgetView(widgetData: entry.widgetData)
        default:
            SmallWidgetView(widgetData: entry.widgetData)
        }
    }
}

struct SmallWidgetView: View {
    let widgetData: WidgetData
    
    var body: some View {
        ZStack {
            // Background photo
            AsyncImage(url: URL(string: widgetData.thumbnailUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "camera.fill")
                            .foregroundColor(.gray)
                            .font(.title)
                    )
            }
            .clipped()
            
            // Gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Content overlay
            VStack {
                HStack {
                    Text(widgetData.groupName)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "arrow.clockwise")
                        .font(.caption2)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 8)
                .padding(.top, 8)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        AsyncImage(url: URL(string: widgetData.senderAvatar)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 16, height: 16)
                                .clipShape(Circle())
                        } placeholder: {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 16, height: 16)
                        }
                        
                        Text(widgetData.senderName)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        Spacer()
                    }
                    
                    Text(timeAgoString(from: widgetData.timestamp))
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
        }
        .containerBackground(for: .widget) {
            Color.black
        }
        .widgetURL(URL(string: "cameragold://photo/\(widgetData.photoId)?groupId=\(widgetData.groupId)"))
    }
}

struct MediumWidgetView: View {
    let widgetData: WidgetData
    
    var body: some View {
        HStack(spacing: 0) {
            // Left side - Photo
            ZStack {
                AsyncImage(url: URL(string: widgetData.thumbnailUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "camera.fill")
                                .foregroundColor(.gray)
                                .font(.title)
                        )
                }
                .clipped()
            }
            .frame(width: 120)
            
            // Right side - Info
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(widgetData.groupName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "arrow.clockwise")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    AsyncImage(url: URL(string: widgetData.senderAvatar)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 24, height: 24)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 24, height: 24)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(widgetData.senderName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .lineLimit(1)
                        
                        Text(timeAgoString(from: widgetData.timestamp))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                if !widgetData.caption.isEmpty {
                    Text(widgetData.caption)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            .padding(.leading, 12)
            .padding(.vertical, 8)
            .padding(.trailing, 8)
        }
        .containerBackground(for: .widget) {
            Color(UIColor.systemBackground)
        }
        .widgetURL(URL(string: "cameragold://photo/\(widgetData.photoId)?groupId=\(widgetData.groupId)"))
    }
}

@main
struct CameraGoldWidget: Widget {
    let kind: String = "CameraGoldWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CameraGoldWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Camera Gold")
        .description("See the latest photos from your friends")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Helper Functions

private func timeAgoString(from timestamp: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: timestamp / 1000)
    let now = Date()
    let components = Calendar.current.dateComponents([.minute, .hour, .day], from: date, to: now)
    
    if let days = components.day, days > 0 {
        return "\(days)d ago"
    } else if let hours = components.hour, hours > 0 {
        return "\(hours)h ago"
    } else if let minutes = components.minute, minutes > 0 {
        return "\(minutes)m ago"
    } else {
        return "Now"
    }
}

// MARK: - Widget Data Model

struct WidgetData: Codable {
    let groupId: String
    let groupName: String
    let photoId: String
    let photoUrl: String
    let thumbnailUrl: String
    let senderName: String
    let senderAvatar: String
    let timestamp: TimeInterval
    let caption: String
    let reactionCount: Int
    let hasNewContent: Bool
    
    static let placeholder = WidgetData(
        groupId: "placeholder",
        groupName: "Camera Gold",
        photoId: "placeholder",
        photoUrl: "",
        thumbnailUrl: "",
        senderName: "Take a photo to get started",
        senderAvatar: "",
        timestamp: Date().timeIntervalSince1970 * 1000,
        caption: "",
        reactionCount: 0,
        hasNewContent: false
    )
}
