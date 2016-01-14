//
//  SettingsController.swift
//  AsteroidsiOS
//
//  Created by Mathias on 24/12/2015.
//  Copyright © 2015 Mathias. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var colourView: UIView!
    var backgroundColour: UIColor!
    
    override func viewDidLoad() {
        updatePreview()
    }
    @IBAction func updatePreview() {
        let red = CGFloat(redSlider.value)
        let green = CGFloat(greenSlider.value)
        let blue = CGFloat(blueSlider.value)
        backgroundColour = UIColor(red: red, green: green, blue: blue, alpha: 1)
        colourView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueGame") {
            let gameController:GameViewController = segue.destinationViewController as! GameViewController
            gameController.backgroundColor = backgroundColour
        }
    }
}