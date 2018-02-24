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
    private var subscribedChannels: [PusherChannelIdentifier: PusherChannel]
    
    init(host: String, key: String) {
        let options = PusherClientOptions(host: .cluster(host))

        #if DEBUG
            print(key)
            print(host)
        #endif

        subscribedChannels = [PusherChannelIdentifier: PusherChannel]()
        pusher = Pusher(key: key, options: options)
        pusher.connect()
        pusher.delegate = self
    }

    deinit {
        pusher.disconnect()
        pusher.unsubscribeAll()
    }

    /// Invokes a completion handler when an event on a channel is triggered.
    ///
    /// - Parameters:
    ///   - eventIdentifier: The name of the event to listen for
    ///   - channelIdentifier: The name of the channel
    ///   - eventHandler: The closure to execute when the event is triggered
    func listenForEvent(_ eventIdentifier: PusherEventIdentifier,
                        onChannel channelIdentifier: PusherChannelIdentifier,
                        eventHandler: @escaping ([String: Any]) -> Void) {

        // It's likely that a single channel will have multiple events. Make sure we don't
        // over-subscribe to a channel.
        if !subscribedChannelIdentifiers.contains(channelIdentifier) {
            subscribe(toChannelIdentifier: channelIdentifier)
        }

        // I can't think of a better way to safely unwrap this optional.
        guard let channel = subscribedChannels[channelIdentifier] else {
            assertionFailure("Not subscribed to channel \(channelIdentifier.rawValue)")
            return
        }

        channel.bind(eventName: eventIdentifier.rawValue) { response in
            guard let jsonDictionary = response as? [String: Any] else {
                assertionFailure("Expected a JSON dictionary")
                return
            }

            eventHandler(jsonDictionary)
        }
    }

    func unsubscribe(fromChannel channelIdentifier: PusherChannelIdentifier? = nil) {
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

// MARK: - Private helper methods
private extension PusherClient {
    func subscribe(toChannelIdentifier identifier: PusherChannelIdentifier) {
        assert(
            !subscribedChannelIdentifiers.contains(identifier),
            "Already subscribed to channel \(identifier.rawValue)"
        )

        let channel = pusher.subscribe(identifier.rawValue)

        subscribedChannels[identifier] = channel
    }
}
