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
import AVFoundation
import RMBTClient

///
class NKOMMeasurementViewController: NKOMAbstractStartViewController {

    ///
    fileprivate var rmbtClient: RMBTClient?

    ///
    fileprivate var measurementResultUuid: String?

    ///
    var runAgain = false

    ///
    private var player: AVAudioPlayer? // = AVAudioPlayer()

    //

    ///
    @IBOutlet fileprivate var measurementGaugeView: MeasurementGaugeView?

    ///
    @IBOutlet fileprivate var pingValueLabel: UILabel?

    ///
    @IBOutlet fileprivate var downloadValueLabel: UILabel?

    ///
    @IBOutlet fileprivate var uploadValueLabel: UILabel?

    ///
    @IBOutlet fileprivate var startAgainButton: UIButton?

    ///
    @IBOutlet fileprivate var viewMeasurementReportButton: UIButton?

    //

    ///
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    ///
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.shared.isIdleTimerDisabled = true // Disallow turning off the screen

        //

        if UIDevice.current.userInterfaceIdiom == .pad {
            startAgainButton?.layer.cornerRadius = UIScreen.main.bounds.width / 16
        } else {
            startAgainButton?.layer.cornerRadius = UIScreen.main.bounds.width / 8 //(startButton?.bounds.size.width)! / 2 // "!"?
        }

        // rounded corners for viewMeasurementReportButton
        if let reportButton = viewMeasurementReportButton {
            reportButton.layer.cornerRadius = reportButton.bounds.height / 2
            reportButton.backgroundColor = MEASUREMENT_REPORT_BUTTON_COLOR
        }
    }

    ///
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        UIApplication.shared.isIdleTimerDisabled = false // Allow turning off the screen again
    }

    //
    override func viewDidLoad() {
        super.viewDidLoad()

        startMeasurement()
    }

    ///
    override func viewDidAppear(_ animated: Bool) {
        if runAgain {
            runAgain = false
            startMeasurement()
        }
    }

    ///
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            // make start button a circle // TODO: remove duplicate code
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.startAgainButton?.layer.cornerRadius = UIScreen.main.bounds.width / 16
            } else {
                self.startAgainButton?.layer.cornerRadius = UIScreen.main.bounds.width / 8
            }
        })
    }

    ///
    @IBAction fileprivate func startMeasurement() {
        playStupidJingle("start_sound")

        prepareViewForMeasurement()

        rmbtClient = RMBT.newClient()
        rmbtClient?.delegate = self
        rmbtClient?.startMeasurement()

        // reset measurement result
        measurementResultUuid = nil
    }

    ////////////////////////
    ///
    private func playStupidJingle(_ name: String) {
        if !(customerIsAlladin() && RMBTSettings.sharedSettings.soundsEnabled) {
            return
        }

        if let jingleUrl = Bundle.main.url(forResource: name, withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: jingleUrl)

                player?.prepareToPlay()
                player?.play()
            } catch let error {
                print(error.localizedDescription)
                // TODO
            }
        }
    }
    ////////////////////////

    ///
    fileprivate func stopMeasurement() {
        rmbtClient?.stopMeasurement()
    }

    ///
    fileprivate func returnToStartScreen() {
        let startViewController = StoryboardScene.Main.instantiateStartViewController()

        showNavigationItems()

        navigationController?.setViewControllers([startViewController], animated: false)
    }

    ///
    fileprivate func prepareViewForMeasurement() {
        hideNavigationItems()
        hideMeasurementResultButton()

        measurementGaugeView?.progressType = .speed

        startAgainButton?.setIcon(.ping, for: .normal)
        startAgainButton?.backgroundColor = MEASUREMENT_START_BUTTON_DURING_MEASUREMENT_COLOR
        startAgainButton?.isEnabled = false

        pingValueLabel?.text = " "
        downloadValueLabel?.text = " "
        uploadValueLabel?.text = " "
    }

    ///
    @IBAction func viewTapped() {
        if let running = rmbtClient?.running, running {

            let alertController = UIAlertController(title: L10n.Measurement.Abort.title, message: L10n.Measurement.Abort.question, preferredStyle: .alert)

            let continueAction = UIAlertAction(title: L10n.Measurement.Abort.continue, style: .default) { _ in
                // do nothing
            }
            alertController.addAction(continueAction)

            let abortAction = UIAlertAction(title: L10n.Measurement.Abort.abortButton, style: .cancel) { _ in
                self.stopMeasurement()
                self.returnToStartScreen()
            }
            alertController.addAction(abortAction)

            ///

            present(alertController, animated: true, completion: nil)
        }
    }

    ///
    @IBAction func measurementResultViewTapped() {
        performSegue(withIdentifier: StoryboardSegue.Main.showMeasurementResult.rawValue, sender: nil)
    }

    ///
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch StoryboardSegue.Main(rawValue: segue.identifier!)! {
            case .showMeasurementResult:
                if let measurementResultViewController = segue.destination as? MeasurementResultTableViewController {
                    measurementResultViewController.measurementUuid = measurementResultUuid
                    measurementResultViewController.measuredNow = true
                    measurementResultViewController.qosResultsAvailable = RMBTSettings.sharedSettings.nerdModeQosEnabled
                }
            default:
                break
        }
    }

    fileprivate func resetStartAgainButton() {
        startAgainButton?.backgroundColor = MEASUREMENT_START_BUTTON_COLOR
        startAgainButton?.isEnabled = true

        startAgainButton?.setIcon(.start, for: .normal)
    }

    ///
    fileprivate func showMeasurementResultButton() {
        viewMeasurementReportButton?.isHidden = false

        playStupidJingle("finish_sound")
    }

    ///
    fileprivate func hideMeasurementResultButton() {
        viewMeasurementReportButton?.isHidden = true
    }
}

///
extension NKOMMeasurementViewController: RMBTClientDelegate {

    ///
    //private var currentSpeedMeasurementPhase: SpeedMeasurementPhase

    ///
    func measurementDidComplete(_ client: RMBTClient, withResult result: String) {
        logger.debug("DID COMPLETE")

        self.measurementResultUuid = result

        DispatchQueue.main.async {
            self.showNavigationItems()
            self.showMeasurementResultButton()
            self.resetStartAgainButton()
        }
    }

    ///
    func measurementDidFail(_ client: RMBTClient, withReason reason: RMBTClientCancelReason) {
        logger.debug("MEASUREMENT FAILED: \(reason)")

        var message = L10n.Measurement.UnknownError.message
        let title = L10n.Measurement.UnknownError.title

        switch reason { // TODO: show alert
        case .userRequested:
            logger.debug("Test cancelled on users request")
            returnToStartScreen()
            return
        case .appBackgrounded:
            logger.debug("Test cancelled because app backgrounded")
            message = L10n.Test.abortedMessage
        case .mixedConnectivity:
            logger.debug("Test cancelled because of mixed connectivity")
            startMeasurement()
            return
        case .noConnection:
            logger.debug("Test cancelled because of NO connectivity")
            message = L10n.Test.Connection.lost
        case .errorFetchingSpeedMeasurementParams:
            logger.debug("Test cancelled because test params couldn't be fetched")
            message = L10n.Test.Connection.couldNotConnect
        case .errorSubmittingSpeedMeasurement:
            logger.debug("Test cancelled because test result couldn't be uploaded to the control server")
            message = L10n.Test.Result.notSubmitted
        // TODO: other errors
        default:
            break
        }

        /////////////////////

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let startOverAction = UIAlertAction(title: L10n.Test.tryAgain, style: .default) { _ in
            self.startMeasurement()
        }
        alertController.addAction(startOverAction)

        let dismissAction = UIAlertAction(title: L10n.General.Alertview.dismiss, style: .cancel) { _ in
            self.returnToStartScreen()
        }
        alertController.addAction(dismissAction)

        ///

        present(alertController, animated: true, completion: nil)
    }

    //

    ///
    func speedMeasurementDidMeasureSpeed(_ kbps: UInt64, inPhase phase: SpeedMeasurementPhase) {
        let speedString = RMBTSpeedMbpsString(kbps, withMbps: false)
        let speedLogValue = RMBTSpeedLogValue(kbps, gaugeParts: 4, log10Max: log10(1000))

        DispatchQueue.main.async {

            switch phase {
            case .down:
                self.downloadValueLabel?.text = "\(speedString)"
            case .up:
                self.uploadValueLabel?.text = "\(speedString)"
            default:
                break
            }

            self.measurementGaugeView?.value = speedLogValue
        }
    }

    ///
    func speedMeasurementDidStartPhase(_ phase: SpeedMeasurementPhase) {
        DispatchQueue.main.async {

            self.measurementGaugeView?.value = 0

            switch phase {
            //case .Init:
            //case .latency:
            case .down:
                self.startAgainButton?.setIcon(.down, for: .normal)
            case .initUp:
            //case .up:
                self.startAgainButton?.setIcon(.up, for: .normal)
            default:
                break
            }
        }
    }

    ///
    func speedMeasurementDidFinishPhase(_ phase: SpeedMeasurementPhase, withResult result: UInt64) {
        DispatchQueue.main.async {

            switch phase {
            case .latency:
                self.pingValueLabel?.text = "\(RMBTFormatNumber(NSNumber(value: Double(result) * 1.0e-6)))"

                self.measurementGaugeView?.progress = 1/3
            case .down:
                self.downloadValueLabel?.text = RMBTSpeedMbpsString(result, withMbps: false)

                self.measurementGaugeView?.progress = 2/3
            case .up:
                self.uploadValueLabel?.text = RMBTSpeedMbpsString(result, withMbps: false)

                self.measurementGaugeView?.progress = 1
            default:
                break
            }

            self.measurementGaugeView?.value = 0
        }
    }

    ///
    func speedMeasurementDidUpdateProgress(_ progress: Float, inPhase phase: SpeedMeasurementPhase) {
        DispatchQueue.main.async {
            let p = Double(progress * 1/3)

            switch phase {
            case .Init:
                self.measurementGaugeView?.progress = p * 0.5
            case .latency:
                self.measurementGaugeView?.progress = 1/6 + p * 0.5
            case .down:
                self.measurementGaugeView?.progress = 1/3 + p
            case .initUp:
                self.measurementGaugeView?.progress = 2/3 + p * 0.2
            case .up:
                self.measurementGaugeView?.progress = 2/3 + 1/3 * 0.2 + p * 0.8
            default:
                break
            }
        }
    }

// MARK: 

    ///
    func qosMeasurementDidStart(_ client: RMBTClient) {
        DispatchQueue.main.async {
            self.measurementGaugeView?.progressType = .qos

            self.startAgainButton?.setIcon(.qos, for: .normal)
        }
    }

    ///
    func qosMeasurementDidUpdateProgress(_ client: RMBTClient, progress: Float) {
        DispatchQueue.main.async {
            self.measurementGaugeView?.progress = Double(progress)
        }
    }
}

// MARK: SWRevealViewControllerDelegate

///
extension NKOMMeasurementViewController {

    ///
    override func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        super.revealController(revealController, didMoveTo: position)

        let isPosLeft = position == .left

        startAgainButton?.isUserInteractionEnabled = isPosLeft
    }
}
