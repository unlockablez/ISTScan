//
//  SubjectViewController.swift
//  ISTScan
//
//  Created by Thamonwan choesuwan on 4/11/2558 BE.
//  Copyright (c) 2558 weeravit. All rights reserved.
//

import UIKit
import Alamofire

class SubjectViewController: UITableViewController {
    
    var datas : JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(.GET, "http://istscan.weeravit-it.com/webservice/getSubject.php")
            .responseJSON { (_, _, json, error) in
            if(error != nil) {
                let alert = UIAlertController(title: "ไม่สามารถโหลดข้อมูลได้", message: "คุณไม่ได้เชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "ตกลง", style: .Default, handler: {
                    (action: UIAlertAction!) in
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }))
                self.presentViewController(alert, animated: false, completion: nil)
            } else {
                self.datas = JSON(json!)
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        let head = self.datas[indexPath.row]["code"].description + " - " + self.datas[indexPath.row]["nameen"].description
        
        if (((indexPath.row+1) % 2) != 0) {
            cell.backgroundColor = UIColor(hexString: "#40c4ff", alpha: 0.07)
        } else {
            cell.backgroundColor = UIColor(hexString: "#ff5177", alpha: 0.07)
        }
        
        cell.textLabel?.text = head
        cell.detailTextLabel?.text = self.datas[indexPath.row]["nameth"].description
        
        return cell
    }
    
    // Event of selected cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        shareSubject = self.datas[indexPath.row]
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
