//
//  ViewController.swift
//  SunburnApp
//
//  Created by Jean Weatherwax on 12/30/16.
//  Copyright © 2016 Jean Weatherwax. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var skinType = SkinType().type1 {
        didSet {
            skinTypeLabel.text = "Skin " + self.skinType
            Utilities().setSkinType(value: skinType)
            getWeatherData()
        }
    }
    
    var burnTime: Double = 10
    
    var UVIndex = 8
    

    @IBOutlet weak var burnTimeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var skinTypeLabel: UILabel!
    let locationManager = CLLocationManager()
    var coords = CLLocationCoordinate2D(latitude: 40, longitude: 40)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        skinType = Utilities().getSkinType()
        skinTypeLabel.text = "Skin: " + skinType
    }
    
    @IBAction func changeSkinClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Skin", message: "Please choose skin type.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: SkinType().type1, style: .default, handler: { (action) in
            self.skinType = SkinType().type1
        }))
        alert.addAction(UIAlertAction(title: SkinType().type2, style: .default, handler: { (action) in
            self.skinType = SkinType().type2
        }))
        alert.addAction(UIAlertAction(title: SkinType().type3, style: .default, handler: { (action) in
            self.skinType = SkinType().type3
        }))
        alert.addAction(UIAlertAction(title: SkinType().type4, style: .default, handler: { (action) in
            self.skinType = SkinType().type4
        }))
        alert.addAction(UIAlertAction(title: SkinType().type5, style: .default, handler: { (action) in
            self.skinType = SkinType().type5
        }))
        alert.addAction(UIAlertAction(title: SkinType().type6, style: .default, handler: { (action) in
            self.skinType = SkinType().type6
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func remindMeButtonClicked(_ sender: UIButton) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound] ) {
            (granted, error) in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: "Time's up!", arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: "You are about to get a sunburn! Put on sunblock or seek shade.", arguments: nil)
                content.sound = UNNotificationSound.default()
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (self.burnTime * 60), repeats: false)
                let request = UNNotificationRequest(identifier: "willburn", content: content, trigger: trigger)
                center.add(request)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location Location changed")
        
        if status == .authorizedWhenInUse {
            getLocation()
        } else if status == .denied {
            let alert = UIAlertController(title: "Error", message: "Go to settings and allow this app to access your location.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    func getLocation() {
        if let loc = locationManager.location?.coordinate {
            coords = loc
        }
        
    }
    
    func getWeatherData() {
        let url = WeatherURL(lat: String(coords.latitude), long: String(coords.longitude)).getFullURL()
        print("URL \(url)")
        Alamofire.request (url, method:.get).responseJSON { response in
            print("Alamo \(response.result)")
            if let json = response.result.value as? [String: Any] {
                print("json: \(json)")
                
                
                
                
                if let data = json["data"] as? Dictionary<String, AnyObject> {
                    if let weather = data["weather"] as? [Dictionary<String, AnyObject>] {
                        if let uv = weather[0]["uvIndex"] as? String {
                            if let uvI = Int(uv) {
                                self.UVIndex = uvI
                                print("At last UV index is \(uvI)")
                                self.updateUI(dataSuccess: true)
                                return
                            }
                        }
                    }
                }
            }
            
            self.updateUI(dataSuccess: false)
            
        }
        
    }
    
    func updateUI(dataSuccess: Bool) {
        DispatchQueue.main.async {
            //failed
            if !dataSuccess {
                self.statusLabel.text = "failed...retrying..."
                self.getWeatherData()
                return
            }
            //success
            self.activityIndicator.stopAnimating()
            self.statusLabel.text = "Got UV data!"
            self.calculateBurnTime()
            print("burn time: \(self.burnTime)")
            self.burnTimeLabel.text = String(self.burnTime)
        }
            
    }
    
    func calculateBurnTime() {
        var minToBurn: Double = 10
        switch skinType {
        case SkinType().type1:
            minToBurn = BurnTime().burn1
        case SkinType().type2:
            minToBurn = BurnTime().burn2
        case SkinType().type3:
            minToBurn = BurnTime().burn3
        case SkinType().type4:
            minToBurn = BurnTime().burn4
        case SkinType().type5:
            minToBurn = BurnTime().burn5
        case SkinType().type6:
            minToBurn = BurnTime().burn6
        default:
            minToBurn = BurnTime().burn1
        }
        
        burnTime = minToBurn / Double(self.UVIndex)
    }
    

    
}
