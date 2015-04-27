//
//  ViewController.swift
//  ISTScan
//
//  Created by Thamonwan choesuwan on 4/11/2558 BE.
//  Copyright (c) 2558 weeravit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var txtSubject: UILabel!
    @IBOutlet weak var txtLesson: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var button: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set color navigatorbar
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#ffd740", alpha: 0.75)
        
        customUI()
    }
    
    // Hide status bar on current page
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Hide NavigationBar on current page
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if(shareSubject != nil) {
            self.txtSubject.textColor = UIColor(hexString: "#5af158")
            self.txtSubject.text = shareSubject["code"].description + " " + shareSubject["nameth"].description
        }
        if(shareLesson != nil) {
            self.txtLesson.textColor = UIColor(hexString: "#5af158")
            self.txtLesson.text = shareLesson["name"].description
        }
        
        super.viewWillAppear(animated)
    }
    
    // Show NavigationBar on another page
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    @IBAction func tapped(sender: UIButton) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        shareDate = dateFormatter.stringFromDate(datePicker.date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func customUI() {
        for btn in self.button {
            btn.layer.cornerRadius = 3
            btn.layer.borderColor = UIColor.whiteColor().CGColor
            btn.layer.borderWidth = 0.2
        }
        
        self.datePicker.backgroundColor = UIColor(hexString: "#ffffff", alpha: 0.3)
    }

}

