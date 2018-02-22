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
    private var subscribedChannels: [PusherSwift.PusherChannel]
    
    init(host: String, key: String) {
        let options = PusherClientOptions(
            host: .cluster(host)
        )

        print(key)
        print(host)

        subscribedChannels = [PusherSwift.PusherChannel]()
        pusher = Pusher(key: key, options: options)
        pusher.connect()
        pusher.delegate = self
    }

    deinit {
        pusher.disconnect()
        pusher.unsubscribeAll()
    }

    func subscribe(toChannelIdentifier identifier: PusherChannelIdentifier) -> PusherSwift.PusherChannel
    {
        let channel = pusher.subscribe(identifier.rawValue)

        subscribedChannels.append(channel)

        return channel
    }

    func bindEventIdentifier(_ event: PusherEventIdentifier,
                             toChannel channel: PusherSwift.PusherChannel) {
        assert(subscribedChannels.contains(channel), "Not subscribed to channel \"\(channel.name)\".")

        channel.bind(eventName: event.rawValue) { something in
            print("Message received")
        }
    }

    func unsubscribe(fromChannel channel: PusherSwift.PusherChannel? = nil) {
        guard let aChannel = channel, let index = subscribedChannels.index(of: aChannel) else {
            pusher.disconnect()
            pusher.unsubscribeAll()
            return
        }

        pusher.unsubscribe(aChannel.name)
        subscribedChannels.remove(at: index)
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
