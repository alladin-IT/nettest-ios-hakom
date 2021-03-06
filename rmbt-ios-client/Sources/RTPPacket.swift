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
struct RTPPacket {

    ///
    var header: RTPHeader

    ///
    var payload: Data // [UInt32]

    //

    ///
    var length: Int {
        return header.length + payload.count
    }

    //

    ///
    init() {
        header = RTPHeader()

        payload = Data() // [UInt32](count: 1, repeatedValue: 0)
    }

// MARK: to/from data methods

    ///
    func toData() -> Data {
        let data = NSMutableData()

        data.append(header.toData() as Data)
        data.append(payload)

        return data as Data
    }

    ///
    static func fromData(_ packetData: Data) -> RTPPacket? {
        if packetData.count < 12 {
            return nil // packet size too small
        }

        var rtpPacket = RTPPacket()

        var offset = 0

        // header

        if let header = RTPHeader.fromData(packetData) {
            rtpPacket.header = header
            offset = header.length
        } else {
            return nil // header parsing failed
        }

        // payload
        rtpPacket.payload = packetData.subdata(in: offset..<packetData.count) // TODO: is this correct?
        // rtpPacket.payload = packetData.subdata(in: NSRange(location: offset, length: packetData.count - offset))

        return rtpPacket
    }

}
