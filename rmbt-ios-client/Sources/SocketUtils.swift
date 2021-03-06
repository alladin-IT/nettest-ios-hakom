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
import CocoaAsyncSocket

/// contains convenience methods for working with sockets
class SocketUtils {

    ///
    class func writeLine(_ sock: GCDAsyncSocket, line: String, withTimeout timeout: TimeInterval, tag: Int) { // TODO: use nano seconds timeouts
        var line = line

        // append \n to command if not already done
        if !line.hasSuffix("\n") {
            line = line + "\n"
        }

        logger.verbose("-- writing line '\(line)'")

        if let lineData = line.data(using: String.Encoding.utf8) {
            sock.write(lineData, withTimeout: timeout, tag: tag)
        } else {
            // TODO: return false or error?
        }
    }

    ///
    class func readLine(_ sock: GCDAsyncSocket, tag: Int, withTimeout timeout: TimeInterval) {
        if let data = "\n".data(using: String.Encoding(rawValue: QOS_SOCKET_DEFAULT_CHARACTER_ENCODING)) {
            sock.readData(to: data, withTimeout: timeout, tag: tag)
        }
    }

    /// parses NSData object to String using default encoding
    class func parseResponseToString(_ data: Data) -> String? {
        if let str = NSString(data: data, encoding: QOS_SOCKET_DEFAULT_CHARACTER_ENCODING) {
            return str as String
        }

        return nil
    }

}
