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

import CoreLocation
import RMBTClient

///
let ICON_FONT_NAME = ""

///
let RMBT = RMBTBuilder().create()

// MARK: Other URLs used in the app

let RMBT_URL_HOST = "https://hakometarplus.hakom.hr"


/// Note: $lang will be replaced by the device language (de, en, sl, etc.)
//let RMBT_STATS_URL       = "\(RMBT_URL_HOST)/$lang/statistics"
let RMBT_STATS_URL       = "\(RMBT_URL_HOST)/statistics"
//let RMBT_HELP_URL        = "\(RMBT_URL_HOST)/$lang/help"
let RMBT_HELP_URL        = "\(RMBT_URL_HOST)/help"
//let RMBT_HELP_RESULT_URL = "\(RMBT_URL_HOST)/$lang/help"
let RMBT_HELP_RESULT_URL = "\(RMBT_URL_HOST)/help"

//let RMBT_PRIVACY_TOS_URL = "\(RMBT_URL_HOST)/$lang/tc"
let RMBT_PRIVACY_TOS_URL = "\(RMBT_URL_HOST)/tc"

//

let RMBT_ABOUT_URL       = "https://alladin.at"
let RMBT_PROJECT_URL     = RMBT_URL_HOST
let RMBT_PROJECT_EMAIL   = "hakometarplus@hakom.hr"

let RMBT_REPO_URL        = "https://github.com/alladin-it"
let RMBT_DEVELOPER_URL   = "https://alladin.at"

// MARK: Map options

/// Initial map center coordinates and zoom level
let RMBT_MAP_INITIAL_LAT: CLLocationDegrees = 45.363408
let RMBT_MAP_INITIAL_LNG: CLLocationDegrees = 16.763024

let RMBT_MAP_INITIAL_ZOOM: Float = 6.5

/// Zoom level to use when showing a test result location
let RMBT_MAP_POINT_ZOOM: Float = 12.0

/// In "auto" mode, when zoomed in past this level, map switches to points
let RMBT_MAP_AUTO_TRESHOLD_ZOOM: Float = 12.0

// Google Maps API Key

///#warning Please supply a valid Google Maps API Key. See https://developers.google.com/maps/documentation/ios/start#the_google_maps_api_key
let RMBT_GMAPS_API_KEY = ""

// MARK: Misc

/// Current TOS version. Bump to force displaying TOS to users again.
let RMBT_TOS_VERSION = 1

///////////////////

let TEST_SHOW_TRAFFIC_WARNING_ON_CELLULAR_NETWORK = true
let TEST_SHOW_TRAFFIC_WARNING_ON_WIFI_NETWORK = true

let TEST_USE_PERSONAL_DATA_FUZZING = true

// If set to false: Statistics is not visible, tap on map points doesn't show bubble, ...
let USE_OPENDATA = true

// Whether to show mnc-mcc or not
let STARTSCREEN_SHOW_MCC_MNC = false

let START_SCREEN_LOCATION_POPUP_ENABLED = true

let QOS_INDEX_USE_COLLECTION_VIEW = true
let HISTORY_DETAILS_USE_GROUPED_VIEW = false
