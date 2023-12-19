import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    var speedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0 km/h"
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()

    var highestSpeedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Max: 0 km/h"
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()

    let clearButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("CLEAR", comment: ""), for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(clearHighestSpeed), for: .touchUpInside)
        return button
    }()
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        view.addSubview(speedLabel)
        view.addSubview(highestSpeedLabel)
        view.addSubview(clearButton)

        speedLabel.font = UIFont(name: "Digital dream Fat Narrow", size: 50)
        highestSpeedLabel.font = UIFont(name: "Digital dream Fat Narrow", size: 20)
        clearButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        clearButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        clearButton.layer.cornerRadius = 10
        clearButton.clipsToBounds = true

        setupLocationManager()
        
        // Activate constraints based on the initial device orientation as user decides about initial device orientation
        if UIDevice.current.orientation.isLandscape {
            activateLandscapeConstraints()
            speedLabel.font = UIFont(name: "Digital dream Fat Narrow", size: 75) // Adjusted font size for landscape
        } else {
            activatePortraitConstraints()
            speedLabel.font = UIFont(name: "Digital dream Fat Narrow", size: 50) // Default font size for portrait
        }
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
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

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        if UIDevice.current.orientation.isLandscape {
            activateLandscapeConstraints()
            speedLabel.font = UIFont(name: "Digital dream Fat Narrow", size: 75) // Adjusted font size for landscape
        } else {
            activatePortraitConstraints()
            speedLabel.font = UIFont(name: "Digital dream Fat Narrow", size: 50) // Default font size for portrait
        }
    }

    func activatePortraitConstraints() {
        NSLayoutConstraint.activate([
            speedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            speedLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            highestSpeedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            highestSpeedLabel.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: 100),

            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.topAnchor.constraint(equalTo: highestSpeedLabel.bottomAnchor, constant: 25),
        ])
    }

    func activateLandscapeConstraints() {
        NSLayoutConstraint.activate([
            speedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            speedLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            highestSpeedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            highestSpeedLabel.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: 50), // Adjusted spacing for landscape

            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.topAnchor.constraint(equalTo: highestSpeedLabel.bottomAnchor, constant: 25),
        ])
    }
}
