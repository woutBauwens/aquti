//
//  LocationRequest.swift
//  aquti
//
//  Created by Wout Bauwens on 22/12/2017.
//  Copyright © 2017 Wout Bauwens. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

public class LocationRequest: Equatable, Hashable {
    
    /// Typealias for success handler
    public typealias Success = ((CLLocation) -> (Void))
    
    /// Typealias for failure handler
    public typealias Failure = ((_ error: Error, _ location: CLLocation?) -> (Void))
    
    /// Type of operation of the request
    ///
    /// - oneshot: one shot; request will be stopped when a a success or failure is triggered.
    /// - continous: continous request will continue until manual stop is called
    /// - significant: only significant changes
    public enum Mode {
        case oneshot
        case continous
        case significant
    }
    
    /// Last achieved location for this request.
    public internal(set) var location: CLLocation? = nil
    
    /// Callback called on success
    internal var success: Success? = nil
    
    /// Callback called on failure
    internal var failure: Failure? = nil
    
    /// Operation mode the request
    public private(set) var mode: Mode
    
    /// Unique identifier of the request
    public private(set) var id: String = UUID().uuidString
    
    /// Accuracy of the request
    public private(set) var accuracy: CLLocationAccuracy
    
    /// Timeout manager
    public private(set) var timeout: Timer?
    
    /// Return the interval set for timeout
    public var timeoutInterval: TimeInterval? {
        return timeout?.timeInterval
    }
    
    /// Returns whether this is a subscription request or not
    public var isRecurring: Bool {
        return (self.mode == .continous || self.mode == .significant)
    }
    
    /// Initialize a new location request with given paramters.
    /// You don't need to allocate your own request, just user the `Location` functions.
    ///
    /// - Parameters:
    ///   - accuracy: desidered accuracy of the request
    ///   - timeout: timeout of the request, `nil` if timeout should not be considered.
    internal init(mode: Mode, accuracy: CLLocationAccuracy, timeout: Timer?) {
        self.mode = mode
        self.accuracy = accuracy
        self.timeout = Timer(timeout, callback: {
            LocationService.locationRequestDidTimedOut(self)
        })
    }
    
    /// Set the timeout interval of the request.
    ///
    /// - Parameter timeout: timeout, `nil` to ignore timeout (manual stop is required)
    /// - Returns: self
    public func timeout(_ timeout: Timer?) -> Self {
        self.timeout = Timer(timeout, callback: {
            LocationService.locationRequestDidTimedOut(self)
        })
        return self
    }
    
    /// Stop running request
    public func stop() {
        Locator.stopRequest(self)
    }
    
    /// Passed location has valid results for current request
    ///
    /// - Parameter location: location to verify
    /// - Returns: `true` if values from location are valid for this request
    internal func hasValidThrehsold(forLocation location: CLLocation) -> Bool {
        // This is a regular one-time location request
        let lastUpdateTime = fabs(location.timestamp.timeIntervalSinceNow)
        let lastAccuracy = location.horizontalAccuracy
        if (lastUpdateTime <= self.accuracy.nextUp &&
            lastAccuracy <= self.accuracy.nextDown) {
            return true
        }
        return false
    }
    
    /// Return the error status of the request, if any
    internal var error: Error? {
      //  switch LocationService.manager.serviceState {
      //  case .disabled:
      //      return .disabled
      //  case .notDetermined:
      //      return .notDetermined
      //  case .denied:
      //      return .denied
      //  case .restricted:
      //      return .restricted
      //  default:
      //      if Locator.updateFailed == true {
      //          return .error
      //      } else if self.timeout?.hasTimedout ?? false {
      //          return .timedout
      //      }
        return nil;
        }
    
    public static func ==(lhs: LocationRequest, rhs: LocationRequest) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var hashValue: Int {
        return self.id.hashValue
    }
}
