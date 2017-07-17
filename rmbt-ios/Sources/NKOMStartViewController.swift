/***************************************************************************
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
import UIKit
import RMBTClient
import PopupDialog

///
class NKOMStartViewController: NKOMAbstractStartViewController {

    ///
    @IBOutlet fileprivate var startButton: UIButton?

    ///
    @IBOutlet fileprivate var cpuUsageLabel: UILabel?

    ///
    @IBOutlet fileprivate var ramUsageLabel: UILabel?

    ///
    @IBOutlet fileprivate var ipv4StatusLabel: UILabel?

    ///
    @IBOutlet fileprivate var ipv6StatusLabel: UILabel?

    ///
    @IBOutlet fileprivate var trafficInLabel: UILabel?

    ///
    @IBOutlet fileprivate var trafficOutLabel: UILabel?

    ///
    @IBOutlet private var geoLocationLabel: UILabel?

    ///
    @IBOutlet private var geoLocationAccuracyLabel: UILabel?

    //

    ///
    private var currentPopupViewController: PopupTableViewController?

    ///
    private var infoTimer: Timer?

    ///
    private let cpuMonitor = RMBTCPUMonitor()

    ///
    private let ramMonitor = RMBTRAMMonitor()

    ///
    private let trafficCounter = RMBTTrafficCounter()

    ///
    private var lastTrafficDict = [String: NSNumber]()

    ///
    private let connectivityService = RMBT.newConnectivityService()

    ///
    private let connectivityRefreshRate = 10 // every 10sec

    ///
    private var lastConnectivityRefresh = 0

    //

    ///
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // make start button a circle
        if UIDevice.current.userInterfaceIdiom == .pad {
            startButton?.layer.cornerRadius = UIScreen.main.bounds.width / 16
        } else {
            startButton?.layer.cornerRadius = UIScreen.main.bounds.width / 8
        }

        startButton?.backgroundColor = MEASUREMENT_START_BUTTON_COLOR

        if RMBTTOS.sharedTOS.isCurrentVersionAccepted() {
            _ = RMBTLocationTracker.sharedTracker.startAfterDeterminingAuthorizationStatus(nil)
        }

        infoTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refreshNerdMode), userInfo: nil, repeats: true)

        refreshNerdMode()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        infoTimer?.invalidate()
        infoTimer = nil
    }

    ///
    override func viewDidLoad() {
        super.viewDidLoad()

        //startButton?.titleLabel?.text = L10n.Measurement.start

        ///////////////
        // Show TOS
        let tos = RMBTTOS.sharedTOS

        // If user hasn't agreed to new TOS version, show TOS modally
        if !tos.isCurrentVersionAccepted() {
            logger.debug("Current TOS version \(tos.currentVersion) > last accepted version \(tos.lastAcceptedVersion), showing dialog")
            perform(segue: StoryboardSegue.Main.showTermsAndConditions, sender: self)
            //performSegue(withIdentifier: StoryboardSegue.Main.showTermsAndConditions.rawValue, sender: self)
            return
        }
    }

    ///
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            // make start button a circle // TODO: remove duplicate code
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.startButton?.layer.cornerRadius = UIScreen.main.bounds.width / 16
            } else {
                self.startButton?.layer.cornerRadius = UIScreen.main.bounds.width / 8
            }
        })
    }

    private enum PopupType: Int {
        case hardware
        case traffic
        case ip
        case location
    }

    private func openPopup(type: PopupType) {

        var popupViewController: PopupTableViewController?

        switch type {
        case .hardware:
            let hardwarePopupViewController = StoryboardScene.Main.instantiateHardwarePopup()

            hardwarePopupViewController.cpuMonitor = cpuMonitor
            hardwarePopupViewController.ramMonitor = ramMonitor

            popupViewController = hardwarePopupViewController

        case .traffic:
            let trafficPopupViewController = StoryboardScene.Main.instantiateTrafficPopup()

            trafficPopupViewController.trafficCounter = trafficCounter

            popupViewController = trafficPopupViewController

        case .ip:
            let ipPopupViewController = StoryboardScene.Main.instantiateIpPopup()

            lastConnectivityRefresh = 0 // force update

            popupViewController = ipPopupViewController

        case .location:
            let locationPopupViewController = StoryboardScene.Main.instantiateLocationPopup()

            popupViewController = locationPopupViewController
        }

        if popupViewController == nil {
            return
        }

        let popup = PopupDialog(viewController: popupViewController!, buttonAlignment: .horizontal, transitionStyle: .fadeIn, gestureDismissal: true) {

            self.currentPopupViewController?.stop()
            logger.debug("DISMISS BLOCK")
            self.currentPopupViewController = nil
        }

        present(popup, animated: true, completion: nil)

        currentPopupViewController = popupViewController!
    }

    ///
    @IBAction func openHardwarePopup() {
        openPopup(type: .hardware)
    }

    ///
    @IBAction func openTrafficPopup() {
        openPopup(type: .traffic)
    }

    ///
    @IBAction func openIpPopup() {
        openPopup(type: .ip)
    }

    ///
    @IBAction func openLocationPopup() {
        if START_SCREEN_LOCATION_POPUP_ENABLED {
            openPopup(type: .location)
        }
    }

    ///
    @IBAction func startMeasurement() {

        let startFunc = {
            let measurementViewController = StoryboardScene.Main.instantiateMeasurementViewController()
            self.navigationController?.setViewControllers([measurementViewController], animated: false)
        }

        if (lastConnectivity?.networkType == .cellular && TEST_SHOW_TRAFFIC_WARNING_ON_CELLULAR_NETWORK) ||
            (lastConnectivity?.networkType == RMBTNetworkType.wiFi && TEST_SHOW_TRAFFIC_WARNING_ON_WIFI_NETWORK) {

            let alertController = UIAlertController(title: RMBTAppTitle(), message: L10n.Test.introMessage(RMBTAppTitle(), RMBTAppCustomerName()), preferredStyle: .alert)

            let startAction = UIAlertAction(title: L10n.General.Alertview.ok, style: .default) { _ in
                startFunc()
            }
            alertController.addAction(startAction)

            let dismissAction = UIAlertAction(title: L10n.General.Alertview.dismiss, style: .cancel) { _ in
                // do nothing
            }
            alertController.addAction(dismissAction)

            ///

            present(alertController, animated: true, completion: nil)

        } else {
            startFunc()
        }
    }

    ///
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO?
    }

    ///
    func refreshNerdMode() {
        if !(currentPopupViewController is IpPopupViewController) {
            currentPopupViewController?.update()
        }

        // CPU
        if let cpuUsage = cpuMonitor.getCPUUsage() {
            DispatchQueue.main.async {
                self.cpuUsageLabel?.text = String(format: "%.01f%%", cpuUsage[0].floatValue)
            }
        } else {
            DispatchQueue.main.async {
                self.cpuUsageLabel?.text = "-"
            }
        }

        // RAM
        let ramUsagePercentFree = ramMonitor.getRAMUsagePercentFree()
        if ramUsagePercentFree > 0 {
            DispatchQueue.main.async {
                self.ramUsageLabel?.text = String(format: "%.01f%%", ramUsagePercentFree)
            }
        } else {
            DispatchQueue.main.async {
                self.ramUsageLabel?.text = "-"
            }
        }

        // IP
        let currentTime = Int(Date().timeIntervalSince1970)
        if currentTime > lastConnectivityRefresh + connectivityRefreshRate {
            logger.debug("refreshing connectivity")
            lastConnectivityRefresh = currentTime

            connectivityService.checkConnectivity { connectivityInfo in
                if self.currentPopupViewController is IpPopupViewController {
                    (self.currentPopupViewController as! IpPopupViewController).connectivityInfo = connectivityInfo
                    self.currentPopupViewController?.update()
                }

                DispatchQueue.main.async {
                    self.updateIpBadge(ipInfo: connectivityInfo.ipv4, badge: self.ipv4StatusLabel)
                    self.updateIpBadge(ipInfo: connectivityInfo.ipv6, badge: self.ipv6StatusLabel)
                }
            }
        }

        // Traffic
        let traffic = trafficCounter.getTrafficCount() as [String: NSNumber]
        if lastTrafficDict.count == 0 {
            lastTrafficDict = traffic
        }

        // sent_diff = sent_wifi_diff + sent_wwan_diff
        let sent = UInt64((traffic["wifi_sent"]!.int64Value - lastTrafficDict["wifi_sent"]!.int64Value) + (traffic["wwan_sent"]!.int64Value - lastTrafficDict["wwan_sent"]!.int64Value))

        // recv_diff = sent_wifi_diff + sent_wwan_diff
        let recv = UInt64((traffic["wifi_received"]!.int64Value - lastTrafficDict["wifi_received"]!.int64Value) + (traffic["wwan_received"]!.int64Value - lastTrafficDict["wwan_received"]!.int64Value))

        let sentClassification = TrafficClassification.classifyBytesPerSecond(sent).rawValue
        let recvClassification = TrafficClassification.classifyBytesPerSecond(recv).rawValue

        let sentStr = NSMutableAttributedString(string: IconFont.trafficOut.repeating(3))

        sentStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(rgb: 0xEEEEEE), range: NSRange(location: 0, length: sentStr.mutableString.length))
        var filledAt = sentStr.mutableString.length - sentClassification
        sentStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(rgb: 0xE4161C), range: NSRange(location: 0, length: sentStr.mutableString.length - filledAt))

        let recvStr = NSMutableAttributedString(string: IconFont.trafficIn.repeating(3))

        recvStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(rgb: 0xEEEEEE), range: NSRange(location: 0, length: recvStr.mutableString.length))
        filledAt = recvStr.mutableString.length - recvClassification
        recvStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(rgb: 0xE4161C), range: NSRange(location: filledAt, length: recvStr.mutableString.length - filledAt))

        DispatchQueue.main.async {
            self.trafficInLabel?.attributedText = recvStr
            self.trafficOutLabel?.attributedText = sentStr
        }

        lastTrafficDict = traffic

        // update geolocation
        if let currentLocation = RMBTLocationTracker.sharedTracker.location { // TODO: watch geo location
            let formattedArray = currentLocation.rmbtFormattedArray()

            geoLocationLabel?.text = formattedArray[0] //currentLocation.rmbtFormattedString()
            geoLocationAccuracyLabel?.text = formattedArray[1]
        } else {
            geoLocationLabel?.text = L10n.Measurement.GeoLocation.failed
            geoLocationAccuracyLabel?.text = ""
        }
    }

    ///
    private func updateIpBadge(ipInfo: IPInfo, badge: UILabel?) {
        if ipInfo.connectionAvailable {
            badge?.icon = .check

            if ipInfo.nat {
                badge?.textColor = COLOR_CHECK_YELLOW
            } else {
                badge?.textColor = COLOR_CHECK_GREEN
            }
        } else {
            badge?.icon = .cross

            badge?.textColor = COLOR_CHECK_RED
        }
    }
}

// MARK: RMBTConnectivityTrackerDelegate

///
extension NKOMStartViewController {

    // TODO: enable/disable start button

    ///
    /*override func connectivityTrackerDidDetectNoConnectivity(tracker: RMBTConnectivityTracker) {
        super.connectivityTrackerDidDetectNoConnectivity(tracker)

        dispatch_async(dispatch_get_main_queue()) {
            self.startButton?.enabled = false
        }
    }*/

    ///
    /*override func connectivityTracker(tracker: RMBTConnectivityTracker, didDetectConnectivity connectivity: RMBTConnectivity) {
        super.connectivityTracker(tracker, didDetectConnectivity: connectivity)

        dispatch_async(dispatch_get_main_queue()) {
            self.startButton?.enabled = true
        }
    }*/
}

// MARK: SWRevealViewControllerDelegate

///
extension NKOMStartViewController {

    ///
    override func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        super.revealController(revealController, didMoveTo: position)

        let isPosLeft = position == .left

        startButton?.isUserInteractionEnabled = isPosLeft
    }
}
