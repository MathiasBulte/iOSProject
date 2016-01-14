//
//  GameOverController.swift
//  AsteroidsiOS
//
//  Created by Mathias on 14/01/2016.
//  Copyright © 2016 Mathias. All rights reserved.
//
import UIKit
class GameOverController:UIViewController {
    override func viewDidAppear(animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:true)
    }
}