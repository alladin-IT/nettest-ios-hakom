// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
// swiftlint:disable nesting
// swiftlint:disable variable_name
// swiftlint:disable valid_docs
// swiftlint:disable type_name

enum L10n {

  enum Connectivity {
    /// Cellular
    static let cellular = L10n.tr("connectivity.cellular")
    /// Not connected
    static let notConnected = L10n.tr("connectivity.not-connected")
    /// WiFi
    static let wifi = L10n.tr("connectivity.wifi")
  }

  enum General {

    enum Alertview {
      /// Cancel
      static let cancel = L10n.tr("general.alertview.cancel")
      /// Close
      static let close = L10n.tr("general.alertview.close")
      /// Dismiss
      static let dismiss = L10n.tr("general.alertview.dismiss")
      /// Error
      static let error = L10n.tr("general.alertview.error")
      /// OK
      static let ok = L10n.tr("general.alertview.ok")
      /// Reload
      static let reload = L10n.tr("general.alertview.reload")
      /// Success
      static let success = L10n.tr("general.alertview.success")
    }
  }

  enum History {

    enum Filter {
      /// Device
      static let device = L10n.tr("history.filter.device")
      /// Network Type
      static let networktype = L10n.tr("history.filter.networktype")
    }

    enum Qos {

      enum Detail {
        /// Test
        static let test = L10n.tr("history.qos.detail.test")
      }

      enum Headline {
        /// Details
        static let details = L10n.tr("history.qos.headline.details")
        /// Tests
        static let tests = L10n.tr("history.qos.headline.tests")
      }
    }

    enum Result {
      /// More Details
      static let moreDetails = L10n.tr("history.result.more-details")
      /// Time
      static let time = L10n.tr("history.result.time")

      enum Headline {
        /// Details
        static let details = L10n.tr("history.result.headline.details")
        /// Map
        static let map = L10n.tr("history.result.headline.map")
        /// Measurement
        static let measurement = L10n.tr("history.result.headline.measurement")
        /// Network
        static let network = L10n.tr("history.result.headline.network")
        /// Quality of Service Tests
        static let qos = L10n.tr("history.result.headline.qos")
      }

      enum Map {
        /// Accuracy
        static let accuracy = L10n.tr("history.result.map.accuracy")
        /// Invalid Coordinates
        static let invalidCoordinates = L10n.tr("history.result.map.invalid-coordinates")
        /// Latitude
        static let latitude = L10n.tr("history.result.map.latitude")
        /// Longitude
        static let longitude = L10n.tr("history.result.map.longitude")
        /// Map Result
        static let result = L10n.tr("history.result.map.result")
        /// Show Map
        static let show = L10n.tr("history.result.map.show")
      }

      enum Qos {
        /// Details
        static let details = L10n.tr("history.result.qos.details")
        /// Results
        static let results = L10n.tr("history.result.qos.results")
        /// Result Details
        static let resultsDetail = L10n.tr("history.result.qos.results-detail")

        enum Details {
          /// Description
          static let description = L10n.tr("history.result.qos.details.description")
          /// Failed
          static let failed = L10n.tr("history.result.qos.details.failed")
          /// Succeeded
          static let succeeded = L10n.tr("history.result.qos.details.succeeded")
        }
      }
    }

    enum Sync {
      /// Sync Code
      static let codeText = L10n.tr("history.sync.code-text")
      /// To merge history of two different devices, request sync code of one device and enter it into the other.
      static let merge = L10n.tr("history.sync.merge")
      /// History synchronisation was successful.
      static let successMessage = L10n.tr("history.sync.success-message")
      /// Sync
      static let sync = L10n.tr("history.sync.sync")

      enum Code {
        /// Copy Code
        static let copy = L10n.tr("history.sync.code.copy")
        /// Enter Code
        static let enter = L10n.tr("history.sync.code.enter")
        /// Enter Sync Code:
        static let enterText = L10n.tr("history.sync.code.enter-text")
        /// Request Code
        static let request = L10n.tr("history.sync.code.request")
      }
    }

    enum Uibar {
      /// Filter
      static let filter = L10n.tr("history.uibar.filter")
      /// Sync
      static let sync = L10n.tr("history.uibar.sync")
    }
  }

  enum Intro {

    enum Location {

      enum Question {
        /// To determine location, please enable location service in device settings.
        static let message = L10n.tr("intro.location.question.message")
        /// Using Location
        static let title = L10n.tr("intro.location.question.title")
      }
    }

    enum Network {

      enum Connection {
        /// Unknown
        static let nameUnknown = L10n.tr("intro.network.connection.name-unknown")
        /// No network connection available
        static let unavailable = L10n.tr("intro.network.connection.unavailable")
      }
    }

    enum Popup {
      /// Location
      static let location = L10n.tr("intro.popup.location")

      enum Hardware {
        /// App RAM
        static let appRam = L10n.tr("intro.popup.hardware.app-ram")
        /// CPU
        static let cpu = L10n.tr("intro.popup.hardware.cpu")
        /// System RAM
        static let systemRam = L10n.tr("intro.popup.hardware.system-ram")
        /// Hardware Usage
        static let usage = L10n.tr("intro.popup.hardware.usage")
      }

      enum Ip {
        /// Connection in Progress...
        static let connectionProgress = L10n.tr("intro.popup.ip.connection-progress")
        /// IP Connections
        static let connections = L10n.tr("intro.popup.ip.connections")
        /// n/a
        static let noIpText = L10n.tr("intro.popup.ip.no-ip-text")
        /// IPv4 External
        static let v4External = L10n.tr("intro.popup.ip.v4-external")
        /// IPv4 Internal
        static let v4Internal = L10n.tr("intro.popup.ip.v4-internal")
        /// IPv6 External
        static let v6External = L10n.tr("intro.popup.ip.v6-external")
        /// IPv6 Internal
        static let v6Internal = L10n.tr("intro.popup.ip.v6-internal")
      }

      enum Location {
        /// Accuracy
        static let accuracy = L10n.tr("intro.popup.location.accuracy")
        /// Age
        static let age = L10n.tr("intro.popup.location.age")
        /// Altitude
        static let altitude = L10n.tr("intro.popup.location.altitude")
        /// Position
        static let position = L10n.tr("intro.popup.location.position")
        /// Source
        static let source = L10n.tr("intro.popup.location.source")
      }

      enum Traffic {
        /// Background Traffic
        static let background = L10n.tr("intro.popup.traffic.background")
        /// Download Traffic
        static let download = L10n.tr("intro.popup.traffic.download")
        /// Upload Traffic
        static let upload = L10n.tr("intro.popup.traffic.upload")
      }
    }
  }

  enum Map {

    enum Callout {
      /// Measurement
      static let measurement = L10n.tr("map.callout.measurement")
      /// Network
      static let network = L10n.tr("map.callout.network")
    }

    enum Options {

      enum Filter {
        /// Overlay
        static let overlay = L10n.tr("map.options.filter.overlay")
      }

      enum Overlay {
        /// Auto
        static let auto = L10n.tr("map.options.overlay.auto")
        /// Heatmap
        static let heatmap = L10n.tr("map.options.overlay.heatmap")
        /// Municipality
        static let municipality = L10n.tr("map.options.overlay.municipality")
        /// Points
        static let points = L10n.tr("map.options.overlay.points")
        /// Regions
        static let regions = L10n.tr("map.options.overlay.regions")
        /// Settlements
        static let settlements = L10n.tr("map.options.overlay.settlements")
        /// Shapes
        static let shapes = L10n.tr("map.options.overlay.shapes")
        /// White Spots
        static let whitespots = L10n.tr("map.options.overlay.whitespots")
      }
    }
  }

  enum Measurement {

    enum Abort {
      /// Abort Test
      static let abortButton = L10n.tr("measurement.abort.abort-button")
      /// Continue
      static let `continue` = L10n.tr("measurement.abort.continue")
      /// Do you really want to cancel the measurement?
      static let question = L10n.tr("measurement.abort.question")
      /// Cancel?
      static let title = L10n.tr("measurement.abort.title")
    }

    enum GeoLocation {
      /// Could not determine current location.
      static let failed = L10n.tr("measurement.geo-location.failed")
    }

    enum UnknownError {
      /// Measurement was aborted due to an unknown error.
      static let message = L10n.tr("measurement.unknown_error.message")
      /// Measurement Error
      static let title = L10n.tr("measurement.unknown_error.title")
    }
  }

  enum Test {
    /// Test aborted. App switched to background.
    static let abortedMessage = L10n.tr("test.aborted-message")
    /// Test aborted
    static let abortedTitle = L10n.tr("test.aborted-title")
    /// Continue
    static let continueButton = L10n.tr("test.continue-button")
    /// WARNING! Each execution of %1$@ requires some data volume. The faster the tested connection the bigger the volume of data transmitted. %2$@ shall not be deemed responsible for excessive data consumption. When starting %1$@ the user is aware of possible data consumption and confirms his sole responsibility.
    static func introMessage(_ p1: String, _ p2: String) -> String {
      return L10n.tr("test.intro-message", p1, p2)
    }
    /// OK
    static let okButton = L10n.tr("test.ok-button")
    /// Repeat Test
    static let `repeat` = L10n.tr("test.repeat")
    /// Try Again
    static let tryAgain = L10n.tr("test.try-again")

    enum Connection {
      /// No sufficient connection established.
      static let couldNotConnect = L10n.tr("test.connection.could-not-connect")
      /// Connection Error
      static let error = L10n.tr("test.connection.error")
      /// Connection to measurement server lost. Test aborted.
      static let lost = L10n.tr("test.connection.lost")
    }

    enum Phase {
      /// Download
      static let download = L10n.tr("test.phase.download")
      /// Init
      static let `init` = L10n.tr("test.phase.init")
      /// Ping
      static let ping = L10n.tr("test.phase.ping")
      /// Upload
      static let upload = L10n.tr("test.phase.upload")
    }

    enum Ping {
      /// ms
      static let unit = L10n.tr("test.ping.unit")
    }

    enum Qos {
      /// Quality of Service Test failed.
      static let failed = L10n.tr("test.qos.failed")
    }

    enum Result {
      /// Test was completed, but results were not submitted to server.
      static let notSubmitted = L10n.tr("test.result.not-submitted")
    }

    enum Speed {
      /// Mbps
      static let unit = L10n.tr("test.speed.unit")
    }
  }

  enum Tos {
    /// I agree with %2$@'s PrivacyPolicy and Terms of Use for %1$@.
    static func message(_ p1: String, _ p2: String) -> String {
      return L10n.tr("tos.message", p1, p2)
    }
  }
}

extension L10n {
  fileprivate static func tr(_ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}

// swiftlint:enable type_body_length
// swiftlint:enable nesting
// swiftlint:enable variable_name
// swiftlint:enable valid_docs
