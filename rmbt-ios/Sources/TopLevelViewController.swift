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

///
class TopLevelViewController: UIViewController {

    ///
    @IBOutlet var sideBarButton: UIBarButtonItem?

    ///
    var revealControllerEnabled = true

    ///
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        if revealControllerEnabled {
            // Assign action for the side button
            sideBarButton?.target = revealViewController()
            sideBarButton?.action = #selector(SWRevealViewController.revealToggle(_:))

            view.addGestureRecognizer(revealViewController().edgeGestureRecognizer())
            view.addGestureRecognizer(revealViewController().tapGestureRecognizer())

            revealViewController().delegate = self
        } else {
            if let s = sideBarButton, let index = navigationItem.leftBarButtonItems?.index(of: s) {
                navigationItem.leftBarButtonItems?.remove(at: index)
            }
        }
    }
}

// MARK: SWRevealViewControllerDelegate

///
extension TopLevelViewController: SWRevealViewControllerDelegate {

    ///
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        let isPosLeft = position == .left

        if isPosLeft {
            view.removeGestureRecognizer(revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(revealViewController().edgeGestureRecognizer())
        } else {
            view.removeGestureRecognizer(revealViewController().edgeGestureRecognizer())
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
}
