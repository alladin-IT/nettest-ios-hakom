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
import RMBTClient

///
class GeneralSettingsViewController: AbstractSettingsViewController {

    ///
    @IBOutlet fileprivate var sideBarButton: UIBarButtonItem?

    ///
    @IBOutlet fileprivate var forceIPv4Switch: UISwitch?

    ///
    @IBOutlet fileprivate var forceIPv6Switch: UISwitch?

    ///
    @IBOutlet fileprivate var soundsSwitch: UISwitch?

    ///
    @IBOutlet fileprivate var qosMeasurementsSwitch: UISwitch?

    ///
    @IBOutlet fileprivate var anonymousModeSwitch: UISwitch?

    ///
    //@IBOutlet fileprivate var nerdModeSwitch: UISwitch?

    ///
    //@IBOutlet fileprivate var nerdModeQosEnabledLabel: UILabel?

    ///
    //@IBOutlet private var publishPersonalDataTableViewCell: UITableViewCell?

    // TODO: dismiss number input fields!

    ///
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        sideBarButton?.target = revealViewController()
        sideBarButton?.action = #selector(SWRevealViewController.revealToggle(_:))

        // Set the gesture
        view.addGestureRecognizer(revealViewController().edgeGestureRecognizer())
        view.addGestureRecognizer(revealViewController().tapGestureRecognizer())

        revealViewController().delegate = self

        //////////////////
        // General
        //////////////////

        // forceIPv4Switch
        bindSwitch(forceIPv4Switch, toSettingsKeyPath: "nerdModeForceIPv4") { value in // when enabled, force ipv6 will be disabled
            if value && self.forceIPv6Switch?.isOn ?? false {
                self.settings.nerdModeForceIPv6 = false
                self.forceIPv6Switch?.setOn(false, animated: true)
            }
        }

        // forceIPv6Switch
        bindSwitch(forceIPv6Switch, toSettingsKeyPath: "nerdModeForceIPv6") { value in // when enabled, force ipv4 will be disabled
            if value && self.forceIPv4Switch?.isOn ?? false {
                self.settings.nerdModeForceIPv4 = false
                self.forceIPv4Switch?.setOn(false, animated: true)
            }
        }

        // sounds
        bindSwitch(soundsSwitch, toSettingsKeyPath: "soundsEnabled", onToggle: nil)

        // qos measurements
        bindSwitch(qosMeasurementsSwitch, toSettingsKeyPath: "nerdModeQosEnabled", onToggle: nil)

        // anonymous mode
        bindSwitch(anonymousModeSwitch, toSettingsKeyPath: "anonymousModeEnabled", onToggle: nil)

        // nerd mode
        /*bindSwitch(nerdModeSwitch, toSettingsKeyPath: "nerdModeEnabled") { on in
            if on {
                self.updateNerdModeQosLabel()
            }

            //self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
            self.tableView.reloadData()
        }*/
    }

    ///
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //updateNerdModeQosLabel()
    }

    ///
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        RMBT.refreshSettings()
    }

// MARK: Support

    ///
    /*fileprivate func updateNerdModeQosLabel() {
        logger.debug("\(self.settings.nerdModeQosEnabled)")
        nerdModeQosEnabledLabel?.text = settings.nerdModeQosEnabled ? "QOS enabled" : "QOS disabled" // TODO: localization
    }*/

// MARK: Table view

    ///
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && !customerIsAlladin() { // hide sounds if not alladin...
            return 0
        }

        return super.tableView(tableView, numberOfRowsInSection: section)
    }

    ///
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 && !customerIsAlladin() { // hide sounds if not alladin...
            return nil
        }

        return super.tableView(tableView, titleForHeaderInSection: section)
    }

    ///
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 && !customerIsAlladin() { // hide sounds if not alladin...
            return nil
        }

        return super.tableView(tableView, titleForFooterInSection: section)
    }

    ///
    /*override func numberOfSections(in tableView: UITableView) -> Int {
        /*if RMBTAppCustomerName().lowercased() == "hakom" { // hide nerd mode settings
            return 1
        }*/

        return settings.debugUnlocked ? 3 : 2
    }*/

    ///
    /*override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return settings.nerdModeEnabled ? 2 : 1
        default:
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }*/
}

// MARK: SWRevealViewControllerDelegate

///
extension GeneralSettingsViewController: SWRevealViewControllerDelegate {

    ///
    func revealControllerPanGestureBegan(_ revealController: SWRevealViewController!) {
        self.tableView.isScrollEnabled = false
    }

    ///
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        self.tableView.isScrollEnabled = false
    }

    ///
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        let posLeft = (position == .left)

        tableView.isScrollEnabled = posLeft
        tableView.allowsSelection = posLeft

        if posLeft {
            view.removeGestureRecognizer(revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(revealViewController().edgeGestureRecognizer())
        } else {
            view.removeGestureRecognizer(revealViewController().edgeGestureRecognizer())
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }

}
