//
//  ViewController.swift
//  MinSpeed
//
//  Created by Jakub Białoskórski on 31/10/2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    // setup speed label programatically
    var speedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0 km/h"
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()

    // setup highest speed label programatically
    var highestSpeedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Max: 0 km/h"
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()

    // setup button programatically
    let clearButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("CLEAR", comment: ""), for: .normal) // localize CLEAR button string
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(clearHighestSpeed), for: .touchUpInside) // must be "self", ignore warning, otherwise reseting crashes the app
        return button
    }()

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        view.addSubview(speedLabel)
        view.addSubview(highestSpeedLabel)
        view.addSubview(clearButton)

        speedLabel.font = UIFont(name: "Digital dream Fat Narrow", size: 50) // set speed label font (must be actual font name)
        highestSpeedLabel.font = UIFont(name: "Digital dream Fat Narrow", size: 20) // set highest speed label font (must be actual font name)
        clearButton.widthAnchor.constraint(equalToConstant: 100).isActive = true // button width
        clearButton.heightAnchor.constraint(equalToConstant: 40).isActive = true // button height
        clearButton.layer.cornerRadius = 10 // make button edges round
        clearButton.clipsToBounds = true

        NSLayoutConstraint.activate([
            speedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), // make speed label central element
            speedLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor), // make speed label central element
            highestSpeedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            highestSpeedLabel.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: 100), // spacing between speedLabel and highSpeedLabel
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.topAnchor.constraint(equalTo: highestSpeedLabel.bottomAnchor, constant: 25), // spacing between highSpeedLabel and button
        ])

        setupLocationManager()
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation // best accuracy for GPS
        locationManager.distanceFilter = kCLDistanceFilterNone // refresh every movement being made
        if let speed = manager.location?.speed {
            let speedInKmPerHour = max(speed * 3.6, 0)
            speedLabel.text = String(format: "%.0f km/h", speedInKmPerHour)
            if speedInKmPerHour > highestSpeed {
                highestSpeed = speedInKmPerHour
                highestSpeedLabel.text = String(format: "Max: %.0f km/h", highestSpeed)
            }
        } else {
            speedLabel.text = "0 km/h"
        }
    }

    var highestSpeed: CLLocationSpeed = 0.0

    @objc func clearHighestSpeed() {
        highestSpeed = 0.0
        highestSpeedLabel.text = "Max: 0 km/h"
    }
}
