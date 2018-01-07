//
//  DetailViewController.swift
//  aquti
//
//  Created by Wout Bauwens on 23/12/2017.
//  Copyright © 2017 Wout Bauwens. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage!
    
    // DetailList is filled inside the PageViewController according to the waterType
    var detailList: [[String]]!
    var secondsToSunset = 0
    
    
    private var time = Timer()
    private var seconds = 0
    // Source: https://medium.com/ios-os-x-development/build-an-stopwatch-with-swift-3-0-c7040818a10f
    private func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraits()
        
        self.tableView.separatorStyle = .none
        imageView.image = image
        
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(DetailViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateTimer() {
        seconds += 1
        if(secondsToSunset > 0){
            secondsToSunset -= 1
        }
        tableView.reloadData()
    }
    
    private func setupConstraits() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: 0).isActive = true
        tableView.heightAnchor.constraint(
            equalTo: view.heightAnchor,
            multiplier: 0.65).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(
            equalTo: view.heightAnchor,
            multiplier: 0.30).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailList[0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! DetailViewControllerTableCell
        cell.Info.text = detailList[0][indexPath.row]
        
        let dist = LocationService.sharedInstance.getDistance()
        switch cell.Info.text! {
        case "Zonsondergang":
            cell.Value.text = timeString(time: TimeInterval(secondsToSunset))
        case "Vaartijd":
            cell.Value.text = timeString(time: TimeInterval(seconds))
            break
        case "Afstand":
            cell.Value.text = Double(round(100*(dist/1000))/100).description + " km"
            break
        case "Gem. Snelheid":
            let kmh = Double(seconds)/3.6
            print(kmh.description)
            cell.Value.text =  Double(round(100*(dist/kmh))/100).description + " km/u"
            break
        case "Huidige snelheid":
            cell.Value.text = Double(round(100*(LocationService.sharedInstance.currentLocation.speed*3.6))/100).description + " km/u"
            break
        case "Afdaling":
            cell.Value.text = Double(round(100*(LocationService.sharedInstance.getDrop()))/100).description + " m"
            break
        default:
            cell.Value.text = detailList[1][indexPath.row]
            break
        }
        
        return cell
    }
}
