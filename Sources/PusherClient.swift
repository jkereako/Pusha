//
//  PusherClient.swift
//  Pusher
//
//  Created by Jeff Kereakoglow on 2/18/18.
//  Copyright © 2018 Alexis Digital. All rights reserved.
//

import PusherSwift

final class PusherClient {
    private let pusher: Pusher

    private var channel: PusherChannel?
    
    init(host: String, key: String) {
        let options = PusherClientOptions(
            host: .cluster(host)
        )
        pusher = Pusher(key: key, options: options)
        pusher.connect()
        pusher.delegate = self
    }

    func subscribe(toChannel channelName: String) {
        // subscribe to channel and bind to event
        channel = pusher.subscribe(channelName) 
    }

    func channel(bindEventName eventName: String) {
//        channel?.bind(eventName: eventName, callback: <#T##(Any?) -> Void#>)
    }

    func unsubscribe() {
        pusher.disconnect()
        pusher.unsubscribeAll()
    }
}


//@objc optional func registeredForPushNotifications(clientId: String)
//@objc optional func failedToRegisterForPushNotifications(response: URLResponse, responseBody: String?)
//@objc optional func subscribedToInterest(name: String)
//@objc optional func subscribedToInterests(interests: Array<String>)
//@objc optional func unsubscribedFromInterest(name: String)
//
//@objc optional func changedConnectionState(from old: ConnectionState, to new: ConnectionState)
//@objc optional func subscribedToChannel(name: String)
//@objc optional func failedToSubscribeToChannel(name: String, response: URLResponse?, data: String?, error: NSError?)

// MARK: - Pusher delegate
extension PusherClient: PusherDelegate {
    func failedToSubscribeToChannel(name: String, response: URLResponse?, data: String?,
                                    error: NSError?) {
        print("Failed to subscribe to channel")
    }
}
