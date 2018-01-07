
//
//  LocationServices.swift
//  aquti
//
//  Created by Wout Bauwens on 22/12/2017.
//  Copyright © 2017 Wout Bauwens. All rights reserved.
//

 import Foundation
 import CoreLocation

// Location service with singleton
// Source: https://bestpractiseios.blogspot.be/2017/01/global-locationmanager-singleton-class.html
// At first sight looks same as tutorial but added methods, changed some exsisting methodes, added locations list, ... . According to requirements
protocol LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: NSError)
}
 
 /// The main class responsibile of location services
public class LocationService: NSObject,CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation = CLLocation()
    var delegate: LocationServiceDelegate?
    var mapDelegate: MapViewController?
    private var locations = [CLLocation]()
    
    static let sharedInstance: LocationService = {
        let instance = LocationService()
        return instance
    }()
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        
        guard let locationManagers=self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManagers.requestAlwaysAuthorization()
            locationManagers.requestWhenInUseAuthorization()
        }
        
        locationManagers.startUpdatingLocation()
        
        locationManagers.desiredAccuracy = kCLLocationAccuracyBest
        locationManagers.pausesLocationUpdatesAutomatically = false
        locationManagers.distanceFilter = 0.1
        locationManagers.delegate = self
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        self.currentLocation = location
        updateLocation(currentLocation: location)
    }
    
    public func getDistance() -> Double {
        var dist = 0.0
        for (index, element) in locations.enumerated() {
            if(index == locations.count-1){
                break
            }
            dist += element.distance(from: locations[index+1])
        }
        return dist
    }
    
    public func getDrop() -> Double {
        return locations[0].altitude - currentLocation.altitude   // altitude is 0 in emulator
    }
    
    @nonobjc func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager?.startUpdatingLocation()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        }
    }
    
    // Private function
    private func updateLocation(currentLocation: CLLocation){
        locations.append(currentLocation)
        mapDelegate?.update()
        guard let delegate = self.delegate else {
            return
        }
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: NSError) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error: error)
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    func startMonitoringSignificantLocationChanges() {
        self.locationManager?.startMonitoringSignificantLocationChanges()
    }
}

//
//  LocationServices.swift
//  aquti
//
//  Created by Wout Bauwens on 22/12/2017.
//  Copyright © 2017 Wout Bauwens. All rights reserved.
//
/*
 import Foundation
 import CoreLocation
 import MapKit
 
 /// Shortcut to locator manager
 public let Locator: LocationService = LocationService.shared
 
 /// The main class responsibile of location services
 public class LocationService: NSObject, CLLocationManagerDelegate {
 
 internal static let shared = LocationService()
 internal var manager: CLLocationManager
 private var locationRequests: [LocationRequest] = []
 public private(set) var isUpdatingLocation: Bool = false
 
 /// Returns the most recent current location, or nil if the current
 /// location is unknown, invalid, or stale.
 private var _currentLocation: CLLocation? = nil
 public var currentLocation: CLLocation? {
 guard let l = self._currentLocation else {
 return nil
 }
 // invalid coordinates, discard id
 if (!CLLocationCoordinate2DIsValid(l.coordinate)) ||
 (l.coordinate.latitude == 0.0 || l.coordinate.longitude == 0.0) {
 return nil
 }
 return l
 }
 
 private override init() {
 self.manager = CLLocationManager()
 super.init()
 self.manager.delegate = self
 }
 
 /// Asynchronously requests the current location of the device using location services,
 /// optionally waiting until the user grants the app permission
 /// to access location services before starting the timeout countdown.
 ///
 /// - Parameters:
 ///   - accuracy: The accuracy level desired (refers to the accuracy and recency of the location).
 ///   - timeout: the amount of time to wait for a location with the desired accuracy before completing.
 ///   - onUpdate: update callback
 ///   - onFail: failure callback
 /// - Returns: request
 @discardableResult
 public func currentPosition(accuracy: CLLocationAccuracy, timeout: Timer? = nil,
 onSuccess: @escaping LocationRequest.Success, onFail: @escaping LocationRequest.Failure) -> LocationRequest {
 //    assert(Thread.isMainThread, "Locator functions should be called from main thread")
 let request = LocationRequest(mode: .oneshot, accuracy: accuracy, timeout: timeout)
 request.success = onSuccess
 request.failure = onFail
 // Start timer if needs to be started (not delayed and valid timer)
 request.timeout?.fire()
 // Append to the queue
 self.addLocation(request)
 return request
 }
 
 /// Returns the current state of location services for this app,
 /// based on the system settings and user authorization status.
 public var state: String {
 //return self.manager.
 return "No error";
 }
 
 /// Autocomplete places from input string. It uses Google Places API for Autocomplete.
 /// In order to use it you must obtain a free api key and set it to `Locator.apis.googleApiKey` property
 ///
 /// - Parameters:
 ///   - text: text to search
 ///   - timeout: timeout, `nil` uses default 10-seconds timeout interval
 ///   - onSuccess: success callback
 ///   - onFail: failure callback
 /// - Returns: request
 // @discardableResult
 // public func autocompletePlaces(with text: String, timeout: TimeInterval? = nil,
 //                                onSuccess: @escaping FindPlaceRequest_Success, onFail: @escaping FindPlaceRequest_Failure) -> FindPlaceRequest {
 //     let request = FindPlaceRequest_Google(input: text, timeout: timeout)
 //    request.success = onSuccess
 //    request.failure = onFail
 //    request.execute()
 //    return request
 //}
 
 /// Complete passed location request and remove from queue if possible.
 ///
 /// - Parameter request: request
 public func completeLocationRequest(_ request: LocationRequest?) {
 guard let r = request else { return }
 
 r.timeout?.invalidate() // stop any running timer
 self.removeLocationRequest(r) // remove from queue
 
 // SwiftLocation is not thread safe and should only be called from the main thread,
 // so we should already be executing on the main thread now.
 // DispatchQueue.main.async() is used to ensure that the completion block for a request
 // is not executed before the request ID is returned, for example in the
 // case where the user has denied permission to access location services and the request
 // is immediately completed with the appropriate error.
 DispatchQueue.main.async {
 if let error = r.error { // failed for some sort of error
 r.failure?(error,r.location)
 } else if let loc = r.location { // succeded
 r.success?(loc)
 }
 }
 }
 
 /// Removes a given location request from the array of requests,
 /// updates the maximum desired accuracy, and stops location updates if needed.
 ///
 /// - Parameter request: request to remove
 private func removeLocationRequest(_ request: LocationRequest?) {
 guard let r = request else { return }
 guard let idx = self.locationRequests.index(of: r) else { return }
 self.locationRequests.remove(at: idx)
 
 // Determine the maximum desired accuracy for all remaining location requests
 let maxAccuracy = self.maximumAccuracyInQueue()
 self.accuracy = maxAccuracy
 // Stop if no other location requests are running
 self.stopUpdatingLocationIfPossible()
 }
 
 /// Checks to see if there are any outstanding locationRequests,
 /// and if there are none, informs CLLocationManager to stop sending
 /// location updates. This is done as soon as location updates are no longer
 /// needed in order to conserve the device's battery.
 private func stopUpdatingLocationIfPossible() {
 let requests = self.activeLocationRequest(excludingMode: .significant)
 if requests.count == 0 { // can be stopped
 self.manager.stopUpdatingLocation()
 self.isUpdatingLocation = false
 }
 }
 
 internal func locationRequestDidTimedOut(_ request: LocationRequest) {
 if let _ = self.locationRequests.index(of: request) {
 self.completeLocationRequest(request)
 }
 }
 
 public func stopRequest(_ request: Request) -> Bool {
 if let r = request as? LocationRequest {
 return self.stopLocationRequest(r)
 }
 if let r = request as? HeadingRequest {
 return self.stopHeadingRequest(r)
 }
 return false
 }
 
 
 }
 */

