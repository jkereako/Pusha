//
//  PusherClient.swift
//  Pusher
//
//  Created by Jeff Kereakoglow on 2/18/18.
//  Copyright © 2018 Alexis Digital. All rights reserved.
//

import PusherSwift

final class PusherClient {
    var subscribedChannelIdentifiers: [PusherChannelIdentifier] {
        return Array(subscribedChannels.keys)
    }
    private let pusher: Pusher
    private var subscribedChannels: [PusherChannelIdentifier: PusherSwift.PusherChannel]
    
    init(host: String, key: String) {
        let options = PusherClientOptions(
            host: .cluster(host)
        )

        #if DEBUG
            print(key)
            print(host)
        #endif

        subscribedChannels = [PusherChannelIdentifier: PusherSwift.PusherChannel]()
        pusher = Pusher(key: key, options: options)
        pusher.connect()
        pusher.delegate = self
    }

    deinit {
        pusher.disconnect()
        pusher.unsubscribeAll()
    }

    func subscribe(toChannelIdentifier identifier: PusherChannelIdentifier) {
        assert(
            !subscribedChannelIdentifiers.contains(identifier),
            "Already subscribed to channel \(identifier.rawValue)"
        )

        let channel = pusher.subscribe(identifier.rawValue)

        subscribedChannels[identifier] = channel
    }

    func bindEventIdentifier(_ eventIdentifier: PusherEventIdentifier,
                             toChannelIdentifier channelIdentifier: PusherChannelIdentifier,
                             completionHandler: @escaping ([String: Any]) -> Void) {

        guard let channel = subscribedChannels[channelIdentifier] else {
            assertionFailure("Not subscribed to channel \(channelIdentifier.rawValue)")
            return
        }

        channel.bind(eventName: eventIdentifier.rawValue) { response in
            guard let jsonDictionary = response as? [String: Any] else {
                assertionFailure("Expected a JSON dictionary")
                return
            }

            completionHandler(jsonDictionary)
        }
    }

    func unsubscribe(fromChannelIdentifier channelIdentifier: PusherChannelIdentifier? = nil) {
        guard let identifier = channelIdentifier, let channel = subscribedChannels[identifier] else {
            pusher.disconnect()
            pusher.unsubscribeAll()
            return
        }

        pusher.unsubscribe(channel.name)
        subscribedChannels[identifier] = nil
    }
}

// MARK: - Pusher delegate
extension PusherClient: PusherDelegate {
    func failedToSubscribeToChannel(name: String, response: URLResponse?, data: String?,
                                    error: NSError?) {
        print("Failed to subscribe to channel")
    }
}
