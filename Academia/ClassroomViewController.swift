//
//  ClassroomViewController.swift
//  Academia
//
//  Created by XCodeClub on 2018-08-30.
//  Copyright © 2018 BinaryChaos. All rights reserved.
//

import UIKit
import AVFoundation

class ClassroomViewController: UIViewController {

    var timer = Timer()
    var minutes = 3
    var seconds = 0
    let maxHealthBarWidth = 163
    var lifePercentage = 1.0
    let green = 120.0     // hue value for green
    var healthHue = 120.0
    
    //flags
    var lightBulb1OnFlag = false
    
    // create audio player to play end of class bell
    var player = AVAudioPlayer()
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var healthBar: UIImageView!
    @IBOutlet weak var student1: UIImageView!
    @IBOutlet weak var healthBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lightBulb1: UIButton!
    
    @IBAction func studentSelected(_ sender: Any)
    {
        if(lightBulb1OnFlag)        // does nothing if the light bulb isn't lit
        {
            turnLightBulbOff()
            displayChoice()
        }
    }
    
    @IBAction func incrementHealth(_ sender: Any?)
    {
        print("Did something good")
        var tempWidth = healthBarWidthConstraint.constant
        tempWidth += 50
        if tempWidth > CGFloat(maxHealthBarWidth)
        {
            tempWidth = CGFloat(maxHealthBarWidth)
        }
        healthBarWidthConstraint.constant = tempWidth
        updateHealthBarColor()
    }
    
    @IBAction func decrementHealth(_ sender: Any?)
    {
        print("Did something bad")
        var tempWidth = healthBarWidthConstraint.constant
        tempWidth -= 50
        if tempWidth < 0
        {
            tempWidth = 0
        }
        healthBarWidthConstraint.constant = tempWidth
        updateHealthBarColor()
    }
    
   
    
    func displayChoice()
    {
        // Create the action buttons for the alert
        let goodAction = UIAlertAction(title: "Do something good", style: .default, handler: {  // sets up the multi-actions if user selects a choice
            alert in print("Did something good")
            print("Did something better")
        })
        goodAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        let badAction = UIAlertAction(title: "Do something bad", style: .default, handler: {alert in
            print("Did something bad")
           // ********************* NEED TO ADD CODE TO DECREMENT AND INCREMENT HEALTH BASED ON CHOICES HERE *************************************
        })
        badAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        // create and configure the alert controller
        let alert = UIAlertController(title: "Alert Title", message: "This is the alert message and story", preferredStyle: .alert)
        alert.addAction(goodAction)
        alert.addAction(badAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func turnLightBulbOn()
    {
        if(!lightBulb1OnFlag)
        {
            lightBulb1.setImage(UIImage(named: "Lightbulb On"), for: .normal)
            lightBulb1OnFlag = true
        }
        
    }
    
    func turnLightBulbOff()
    {
        if(lightBulb1OnFlag)
        {
            lightBulb1.setImage(UIImage(named: "Lightbulb Off"), for: .normal)
            lightBulb1OnFlag = false
        }
        
    }
    func seeIfStudentHasAQuestion()
    {
        let rNumber = Int(arc4random_uniform(11))
        
        if rNumber > 8
        {
            turnLightBulbOn()
        }
    }
    
    @objc func decreaseTimer()    // timer function to decrement time by one each second
        // added @objc to get selector to run
    {
        if minutes >= 0      // timer will run while time is still on the clock
        {
            if seconds == 0     // sets when to reset seconds at the start of next minute
            {
                minutes -= 1    // decrements minutes when switches to next minute
                seconds = 59    // resets seconds at the start of the next minute
            }
            else
            {
                seconds -= 1                    // decrements timer by one
            }
            if seconds >= 10
            {
                timerLabel.text = String(minutes) + ":" + String(seconds)   // formats seconds for two digit numbers
                
                seeIfStudentHasAQuestion()
            }
            else
            {
                timerLabel.text = String(minutes) + ":0" + String(seconds)  // formats seconds for one digit numbers
                
                seeIfStudentHasAQuestion()
                if seconds == 0     // sets when to reset seconds at the start of next minute
                {
                    minutes -= 1    // decrements minutes when switches to next minute
                    seconds = 60    // resets seconds at the start of the next minute
                }
            }
            
        }
        else
        {
            timerLabel.text = "0:00"
            timer.invalidate()  // stops timer when reaches zero
            
            // play class bell to signal end of period
            player.play()
            
            let alert = UIAlertController(title: "End of Class", message: "Class is over.", preferredStyle: .alert)     // creates the pop up to end class and sets the text
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
                self.performSegue(withIdentifier: "ClassOver", sender: self)
                            }))
            self.present(alert, animated: true, completion: nil)    // sets what should happen when you press the OK button -> end of class scene
        }
    }
    
    func updateHealthBarColor()
    {
        // set color of health bar based on life percentage
        lifePercentage = Double(healthBarWidthConstraint.constant / CGFloat(maxHealthBarWidth))
        healthHue = lifePercentage * green
        healthBar.backgroundColor = UIColor(hue: CGFloat(healthHue/360), saturation: 1.0, brightness: 1.0, alpha: 1.0)    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
        
        if seconds >= 10
        {
            timerLabel.text = String(minutes) + ":" + String(seconds)   // formats seconds for two digit numbers
        }
        else
        {
            timerLabel.text = String(minutes) + ":0" + String(seconds)  // formats seconds for one digit numbers
        }
        
        // start timer countdown
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ClassroomViewController.decreaseTimer), userInfo: nil, repeats: true)
        
        // set file path for end of class period bell
        let audioPath = Bundle.main.path(forResource: "school_bell_short", ofType: "mp3")
        do
        {
           try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        }
        catch
        {
            
        }
        
        // set up width of health bar
        //healthBarWidthConstraint = NSLayoutConstraint(item: healthBar, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 41)
        healthBarWidthConstraint.constant = CGFloat(Double(maxHealthBarWidth) * lifePercentage)
        
        updateHealthBarColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
