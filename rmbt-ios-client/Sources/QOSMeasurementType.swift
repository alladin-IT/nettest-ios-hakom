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
public enum QOSMeasurementType: String { // TODO: rename to QosMeasurementType
    case HttpProxy              = "http_proxy"
    case NonTransparentProxy    = "non_transparent_proxy"
    case WEBSITE                = "website"
    case DNS                    = "dns"
    case TCP                    = "tcp"
    case UDP                    = "udp"
    case VOIP                   = "voip"
    case TRACEROUTE             = "traceroute"

    ///
    static var localizedNameDict = [QOSMeasurementType: String]()
}

///
extension QOSMeasurementType: CustomStringConvertible {

    ///
    public var description: String {
        return QOSMeasurementType.localizedNameDict[self] ?? self.rawValue
    }
}
