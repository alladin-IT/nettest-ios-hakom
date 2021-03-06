/***************************************************************************
 * Copyright 2013 appscape gmbh
 * Copyright 2014-2016 SPECURE GmbH
 * Copyright 2016-2017 alladin-IT GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ***************************************************************************/

import Foundation
import CoreLocation

///
public let RMBTLocationTrackerNotification = "RMBTLocationTrackerNotification"

///
open class RMBTLocationTracker: NSObject, CLLocationManagerDelegate {

    ///
    open static let sharedTracker = RMBTLocationTracker()

    ///
    open let locationManager: CLLocationManager

    ///
    open var authorizationCallback: EmptyCallback?

    ///
    open var location: CLLocation? {
        if let result = locationManager.location, CLLocationCoordinate2DIsValid(result.coordinate) {
            return result
        }

        return nil
    }

    ///
    override fileprivate init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 3.0
        //locationManager.requestAlwaysAuthorization()

        super.init()

        locationManager.delegate = self
    }

    ///
    open func stop() {
        #if os(iOS) // TODO: replacement for this method?
        locationManager.stopMonitoringSignificantLocationChanges()
        #endif
        locationManager.stopUpdatingLocation()
    }

    ///
    open func startIfAuthorized() -> Bool {
        let authorizationStatus = CLLocationManager.authorizationStatus()

        #if os(OSX) // TODO
        #else
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            #if os(iOS) // TODO: replacement for this method?
            locationManager.startUpdatingLocation()
            #endif
            return true
        }
        #endif

        return false
    }

    ///
    open func startAfterDeterminingAuthorizationStatus(_ callback: EmptyCallback?) {
        if startIfAuthorized() {
            callback?()
        } else if CLLocationManager.authorizationStatus() == .notDetermined {
            // Not determined yet
            authorizationCallback = callback

            #if os(OSX)
                // TODO
            #else
            locationManager.requestWhenInUseAuthorization()
            #endif
        } else {
            logger.warning("User hasn't enabled or authorized location services")
            callback?()
        }
    }

    #if os(OSX) // TODO
    #else

    ///
    open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: RMBTLocationTrackerNotification), object: self, userInfo:["locations": locations])
    }

    #endif

    ///
    open func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        #if os(iOS) // TODO: replacement for this method?
        if locationManager.responds(to: #selector(CLLocationManager.startUpdatingLocation)) {
            locationManager.startUpdatingLocation()
        }
        #endif

        if let authorizationCallback = self.authorizationCallback {
            authorizationCallback()
        }
    }

    ///
    open func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.error("Failed to obtain location \(error)")
    }

    ///
    open func forceUpdate() {
        stop()
        _ = startIfAuthorized()
    }
}
