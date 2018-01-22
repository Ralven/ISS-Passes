//
//  ViewController.swift
//  ISS Passes
//
//  Created by Rafael Aguilera on 1/18/18.
//  Copyright © 2018 Rafael Aguilera. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ISSTableViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: Properties
    /***************************************************************/
    let locationManager = CLLocationManager()
    var passList = [PassTimeModel]()
    var didFindLocation: Bool = false //needed to be used because GPS takes too long to shut off

    //MARK: Outlets
    /***************************************************************/
    @IBOutlet weak var passTableView: UITableView!
    
    //MARK: View Lifecycle
    /***************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Tableview
        passTableView.delegate = self
        passTableView.dataSource = self
        
        //Location Manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        SVProgressHUD.show()
    }

    //MARK: Networking
    /***************************************************************/
    func getPassTimesData(url: String){
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess{
                let passTimeJSON : JSON = JSON(response.result.value!)
                self.updatePassTimeData(json: passTimeJSON)
            }else {
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Connection Issues", message: "Cannot seem to connect to the internet make sure you have signal or are on wifi" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    func updatePassTimeData(json: JSON){
        if let passes = json["request"]["passes"].int{
            for index in 0..<passes{
                let passTimeItem = PassTimeModel()
                if let myDuration = json["response"][index]["duration"].int{
                    passTimeItem.duration = myDuration
                }else{
                    print("Could not get Duration")
                }
                if let myTime = json["response"][index]["risetime"].double{
                    passTimeItem.timeStamp = NSDate(timeIntervalSince1970: myTime)
                }else{
                    print("Could not get risetime")
                }
                passList.append(passTimeItem)
            }
            SVProgressHUD.dismiss()
            passTableView.reloadData()
        }else{
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Pass Times Unavailable Currently", message: "Pass Times do not seem to be available at the moment try again later" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count-1]
        //had to use bool because gps antennae power down time caused function to go off twice before fully shutting down.
        if didFindLocation == false{
            if location.horizontalAccuracy > 0 {
                locationManager.stopUpdatingLocation()
                didFindLocation = true
                let passTimes_URL = "http://api.open-notify.org/iss-pass.json?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)"
                getPassTimesData(url: passTimes_URL)
            }
        }
    }
    //didFailWithError method:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: "Location Unavailable", message: "Your Location is currently unavailable make sure location services are turned on and currently available." , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ISSTableViewController: UITableViewDelegate, UITableViewDataSource{
    //MARK: TableView
    /***************************************************************/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let passTime = passList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "passCell") as! PassCell
        cell.setPassTime(passTime: passTime)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
}


    
    
    










