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

///
typealias TCPTestExecutor = QOSTCPTestExecutor<QOSTCPTest>

///
class QOSTCPTestExecutor<T: QOSTCPTest>: QOSTestExecutorClass<T>, GCDAsyncSocketDelegate {

    fileprivate let RESULT_TCP_PORT_OUT     = "tcp_objective_out_port" // static stored properties not yet supported in generic types
    fileprivate let RESULT_TCP_PORT_IN      = "tcp_objective_in_port"
    fileprivate let RESULT_TCP_TIMEOUT      = "tcp_objective_timeout"
    fileprivate let RESULT_TCP_OUT          = "tcp_result_out"
    fileprivate let RESULT_TCP_IN           = "tcp_result_in"
    fileprivate let RESULT_TCP_RESPONSE_OUT = "tcp_result_out_response"
    fileprivate let RESULT_TCP_RESPONSE_IN  = "tcp_result_in_response"

    //

    fileprivate let TAG_TASK_TCPTEST_OUT = 1001
    fileprivate let TAG_TASK_TCPTEST_IN = 1002

    //

    fileprivate let TAG_TCPTEST_OUT_PING = -1
    fileprivate let TAG_TCPTEST_IN_PING = -2

    //

    ///
    fileprivate let socketQueue = DispatchQueue(label: "at.alladin.rmbt.tcp.socketQueue", attributes: DispatchQueue.Attributes.concurrent)

    ///
    fileprivate var tcpTestOutSocket: GCDAsyncSocket!

    ///
    fileprivate var tcpTestInSocket: GCDAsyncSocket!

    ///
    fileprivate var portOutFinished = false

    ///
    fileprivate var portInFinished = false

    //

    ///
    override init(delegateQueue: DispatchQueue, testObject: T, speedtestStartTime: UInt64) {
        super.init(delegateQueue: delegateQueue, testObject: testObject, speedtestStartTime: speedtestStartTime)
    }

    ///
    override func startTest() {
        super.startTest()

        testResult.set(RESULT_TCP_TIMEOUT, number: testObject.timeout)
    }

    ///
    override func executeTest() {
        qosLog.debug("EXECUTING TCP TEST")

        // port out test
        if let portOut = testObject.portOut {
            qosLog.debug("TCP TEST PORT OUT")

            testResult.set(RESULT_TCP_PORT_OUT, number: portOut) // put portOut in test result
            testResult.set(RESULT_TCP_OUT, value: "FAILED" as AnyObject?) // TODO: why is this cast necessary? // assume test failed if port was provided (don't have to set failed later, only have to success)

            // request tcp out test
            sendTaskCommand("TCPTEST OUT \(portOut)", withTimeout: timeoutInSec, tag: TAG_TASK_TCPTEST_OUT)
        }

        // port in test
        if let portIn = testObject.portIn {
            qosLog.debug("TCP TEST PORT IN")

            testResult.set(RESULT_TCP_PORT_IN, number: portIn) // put portIn in test result
            testResult.set(RESULT_TCP_IN, value: "FAILED" as AnyObject?) // TODO: why is this cast necessary? // assume test failed if port was provided (don't have to set failed later, only have to success)

            // request tcp in test
            sendTaskCommand("TCPTEST IN \(portIn)", withTimeout: timeoutInSec, tag: TAG_TASK_TCPTEST_IN)
        }

        // check if both params aren't set
        if testObject.portOut == nil && testObject.portIn == nil {
            testResult.set(RESULT_TCP_OUT, value: "NOT_SET" as AnyObject?) // TODO: why is this cast necessary?
            testResult.set(RESULT_TCP_IN, value: "NOT_SET" as AnyObject?) // TODO: why is this cast necessary?

            callFinishCallback()
        }
    }

    ///
    fileprivate func checkFinish() { // TODO: improve with something like CountDownLatch
        delegateQueue.async { // TODO: run in delegate queue!
            self.qosLog.debug("check finish")
            if self.testObject.portOut != nil && !self.portOutFinished {
                return
            }

            if self.testObject.portIn != nil && !self.portInFinished {
                return
            }

            // if (portOutFinished && portInFinished) { // TODO: use something like CountDownLatch...
                self.callFinishCallback()
            // }
        }
    }

// MARK: QOSControlConnectionDelegate methods

    ///
    override func controlConnection(_ connection: QOSControlConnection, didReceiveTaskResponse response: String, withTaskId taskId: UInt, tag: Int) {
        qosLog.debug("CONTROL CONNECTION DELEGATE FOR TASK ID \(taskId), WITH TAG \(tag), WITH STRING \(response)")

        switch tag {
            case TAG_TASK_TCPTEST_OUT:
                qosLog.debug("TCPTEST OUT response: \(response)")

                if response.hasPrefix("OK") {

                    // create client socket
                    tcpTestOutSocket = GCDAsyncSocket(delegate: self, delegateQueue: delegateQueue, socketQueue: socketQueue)

                    // connect client socket
                    do {
                        try tcpTestOutSocket.connect(toHost: testObject.serverAddress!, onPort: testObject.portOut!, withTimeout: timeoutInSec)
                    } catch {
                        // there was an error
                        qosLog.debug("connection error \(error)")
                        testDidFail()
                    }

                    qosLog.debug("created tcpTestOutSocket")
                } else {
                    testDidFail()
                }

            case TAG_TASK_TCPTEST_IN:

                // create server socket
                tcpTestInSocket = GCDAsyncSocket(delegate: self, delegateQueue: delegateQueue, socketQueue: socketQueue)

                do {
                    try tcpTestInSocket.accept(onPort: testObject.portIn!)
                } catch {
                    // TODO: check error (i.e. fail test if error) // try!
                    testDidFail()
                }

            default:
                // do nothing
                qosLog.debug("default case: do nothing")
        }
    }

// MARK: GCDAsyncSocketDelegate methods

    ///
    @objc func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        if sock == tcpTestInSocket {
            // read line
            SocketUtils.readLine(newSocket, tag: TAG_TCPTEST_IN_PING, withTimeout: timeoutInSec)
        }
    }

    ///
    @objc func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        qosLog.debug("DID CONNECT TO HOST \(host) on port \(port)")
        if sock == tcpTestOutSocket {
            // write "PING" and read response
            SocketUtils.writeLine(tcpTestOutSocket, line: "PING", withTimeout: timeoutInSec, tag: TAG_TCPTEST_OUT_PING)
            SocketUtils.readLine(tcpTestOutSocket, tag: TAG_TCPTEST_OUT_PING, withTimeout: timeoutInSec)
        }
    }

    ///
    @objc func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {

        let response: String = SocketUtils.parseResponseToString(data)! // !?
        let responseWithoutLastNewline = response.stringByRemovingLastNewline()

        if sock == tcpTestOutSocket {
            switch tag {
            case TAG_TCPTEST_OUT_PING:
                qosLog.debug("ping reponse: \(response)")

                testResult.set(RESULT_TCP_RESPONSE_OUT, value: responseWithoutLastNewline as AnyObject?) // TODO: why is this cast necessary?
                testResult.set(RESULT_TCP_OUT, value: "OK" as AnyObject?) // TODO: why is this cast necessary?

                // close socket
                // tcpTestOutSocket.disconnectAfterReadingAndWriting()

                qosLog.debug("TEST RESULT: \(testResult)")

                portOutFinished = true
                checkFinish()

            default:
                // do nothing
                qosLog.debug("do nothing")
            }
        } else {
            // should be newSocket // TODO: check!

            testResult.set(RESULT_TCP_RESPONSE_IN, value: responseWithoutLastNewline as AnyObject?) // TODO: why is this cast necessary?
            testResult.set(RESULT_TCP_IN, value: "OK" as AnyObject?) // TODO: why is this cast necessary?

            // close socket
            // sock.disconnectAfterReadingAndWriting()

            portInFinished = true
            checkFinish()
        }
    }

}
