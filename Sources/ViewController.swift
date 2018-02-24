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

        // REVIEW: Find a better way to couple events with channels.
        client.subscribe(toChannelIdentifier: .playground)
        client.bindEventIdentifier(.messageReceived, toChannelIdentifier: .playground) { response in
            print(response)
        }
    }
}

