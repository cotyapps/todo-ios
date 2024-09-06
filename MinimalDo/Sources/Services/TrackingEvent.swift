import Foundation
import KovaleeSDK

enum TrackingEvent {
    case firstAppOpen
    case appOpen
    case naAttActivate
    case naAttDeactivate

    case naNotificationActivate
    case naNotificationDeactivate

    case pageView(String)

    case acTodoListCreated
    case acTodoListEdited
    case acTodoListDeleted

    case acTodoItemCreated
    case acTodoItemCompleted(String)

    var eventName: String {
        switch self {
        case .firstAppOpen:
            "first_app_open"
        case .appOpen:
            "app_open"
        case .naAttActivate:
            "na_att_activate"
        case .naAttDeactivate:
            "na_att_deactivate"
        case .naNotificationActivate:
            "na_notification_activate"
        case .naNotificationDeactivate:
            "na_notification_deactivate"
        case .acTodoListCreated:
            "ac_todo_list_created"
        case .pageView:
            "page_view"
        case .acTodoListEdited:
            "ac_todo_list_edited"
        case .acTodoListDeleted:
            "ac_todo_list_deleted"
        case .acTodoItemCreated:
            "ac_todo_item_created"
        case .acTodoItemCompleted:
            "ac_todo_item_completed"
        }
    }

    var properties: [String: Any]? {
        switch self {
        case let .pageView(screen):
            ["screen": screen]
        case let .acTodoItemCompleted(source):
            ["source": source]
        default:
            nil
        }
    }
}

enum UserProperty {
    case pushNotificationAllowed(Bool)
    case premium(Bool)
    
    var keyString: String {
        switch self {
        case .pushNotificationAllowed:
            "push_notification_allowed"
        case .premium:
            "premium"
        }
    }
    
    var value: String {
        switch self {
        case let .pushNotificationAllowed(notiAllowed):
            notiAllowed ? "yes" : "no"
        case let .premium(isPremium):
            isPremium ? "yes" : "no"
        }
    }
}

extension Kovalee {
    static func sendEvent(event: TrackingEvent) {
        Self.sendEvent(withName: event.eventName, andProperties: event.properties)
    }
    
    static func setUserProperty(prop: UserProperty) {
        Self.setUserProperty(key: prop.keyString, value: prop.value)
    }
}
