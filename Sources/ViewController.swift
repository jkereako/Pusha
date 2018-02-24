//
//  ViewController.swift
//  Pusher
//
//  Created by Jeff Kereakoglow on 2/18/18.
//  Copyright © 2018 Alexis Digital. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    // Hold a strong reference to the client so that it stays in memory
    private var client: PusherClient!

    override func viewDidLoad() {
        super.viewDidLoad()

        client = PusherClient(
            host: Environment.variable(forKey: .pusherCluster),
            key: Environment.variable(forKey: .pusherKey)
        )

        // Conceptually, channels and events are tightly coupled. That coupling is reflected in
        // `listenForEvent(:, onChannel:)` by simultaneously subscribing to the channel and binding
        // the closure to the event on that channel.
        client.listenForEvent(.messageReceived, onChannel: .playground) { response in
            print(response)
        }
    }
}

