/***************************************************************************
 * Copyright 2016 SPECURE GmbH
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
import ObjectMapper

///
class SpeedMeasurementRequest: BasicRequest {

    ///
    var uuid: String?

    ///
    var ndt = false

    ///
    var anonymous = false

    ///
    var time: UInt64?

    ///
    var version: String?

    ///
    var testCounter: UInt?

    ///
    var geoLocation: GeoLocation?

    ///
    override func mapping(map: Map) {
        super.mapping(map: map)

        uuid        <- map["uuid"]
        ndt         <- map["ndt"]
        anonymous   <- map["anonymous"]
        time        <- (map["time"], UInt64NSNumberTransformOf)
        version     <- map["version"]
        testCounter <- map["test_counter"]

        geoLocation <- map["geo_location"]
    }
}
