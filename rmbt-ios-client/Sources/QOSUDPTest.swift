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

///
class QOSUDPTest: QOSTest {

    fileprivate let PARAM_NUM_PACKETS_OUT = "out_num_packets"
    fileprivate let PARAM_NUM_PACKETS_IN = "in_num_packets"

    fileprivate let PARAM_PORT_OUT = "out_port"
    fileprivate let PARAM_PORT_IN = "in_port"

    fileprivate let PARAM_DELAY = "delay"

    //

    var packetCountOut: UInt16?
    var packetCountIn: UInt16?

    var portOut: UInt16?
    var portIn: UInt16?

    var delay: UInt64 = 300_000_000 // 300 ms

    //

    ///
    override var description: String {
        return super.description + ", [packetCountOut: \(packetCountOut), packetCountIn: \(packetCountIn), portOut: \(portOut), portIn: \(portIn), delay: \(delay)]"
    }

    //

    ///
    override init(testParameters: QOSTestParameters) {
        // packetCountOut
        if let packetCountOutString = testParameters[PARAM_NUM_PACKETS_OUT] as? String {
            if let packetCountOut = UInt16(packetCountOutString) {
                self.packetCountOut = packetCountOut
            }
        }

        // packetCountIn
        if let packetCountInString = testParameters[PARAM_NUM_PACKETS_IN] as? String {
            if let packetCountIn = UInt16(packetCountInString) {
                self.packetCountIn = packetCountIn
            }
        }

        // portOut
        if let portOutString = testParameters[PARAM_PORT_OUT] as? String {
            if let portOut = UInt16(portOutString) {
                self.portOut = portOut
            }
        }

        // portIn
        if let portInString = testParameters[PARAM_PORT_IN] as? String {
            if let portIn = UInt16(portInString) {
                self.portIn = portIn
            }
        }

        // delay
        if let delayString = testParameters[PARAM_DELAY] as? NSString {
            let delay = delayString.longLongValue
            if delay > 0 {
                self.delay = UInt64(delay)
            }
        }

        super.init(testParameters: testParameters)
    }

    ///
    override func getType() -> QOSMeasurementType {
        return .UDP
    }

}
