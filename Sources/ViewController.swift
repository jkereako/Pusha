//
//  ViewController.swift
//  Pusher
//
//  Created by Jeff Kereakoglow on 2/18/18.
//  Copyright © 2018 Alexis Digital. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let client = PusherClient(
            host: Environment.variable(forKey: .pusherCluster),
            key: Environment.variable(forKey: .pusherKey)
        )

        let channel = client.subscribe(toChannelIdentifier: .playground)
        client.bindEventIdentifier(.messageReceived, toChannel: channel)
    }
}

