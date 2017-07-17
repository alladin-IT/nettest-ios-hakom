// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation
import UIKit

// swiftlint:disable file_length
// swiftlint:disable line_length
// swiftlint:disable type_body_length

protocol StoryboardSceneType {
  static var storyboardName: String { get }
}

extension StoryboardSceneType {
  static func storyboard() -> UIStoryboard {
    return UIStoryboard(name: self.storyboardName, bundle: Bundle(for: BundleToken.self))
  }

  static func initialViewController() -> UIViewController {
    guard let vc = storyboard().instantiateInitialViewController() else {
      fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
    }
    return vc
  }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
  func viewController() -> UIViewController {
    return Self.storyboard().instantiateViewController(withIdentifier: self.rawValue)
  }
  static func viewController(identifier: Self) -> UIViewController {
    return identifier.viewController()
  }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
  func perform<S: StoryboardSegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    performSegue(withIdentifier: segue.rawValue, sender: sender)
  }
}

enum StoryboardScene {
  enum History: String, StoryboardSceneType {
    static let storyboardName = "History"

    case uiTableViewControllerDGO3RSYfScene = "UITableViewController-dGO-3R-SYf"
    static func instantiateUiTableViewControllerDGO3RSYf() -> RMBT.MeasurementResultTableViewController {
      guard let vc = StoryboardScene.History.uiTableViewControllerDGO3RSYfScene.viewController() as? RMBT.MeasurementResultTableViewController
      else {
        fatalError("ViewController 'UITableViewController-dGO-3R-SYf' is not of the expected class RMBT.MeasurementResultTableViewController.")
      }
      return vc
    }

    case uiTableViewControllerOulBURI9Scene = "UITableViewController-oul-BU-rI9"
    static func instantiateUiTableViewControllerOulBURI9() -> RMBT.HistoryTableViewController {
      guard let vc = StoryboardScene.History.uiTableViewControllerOulBURI9Scene.viewController() as? RMBT.HistoryTableViewController
      else {
        fatalError("ViewController 'UITableViewController-oul-BU-rI9' is not of the expected class RMBT.HistoryTableViewController.")
      }
      return vc
    }
  }
  enum Info: StoryboardSceneType {
    static let storyboardName = "Info"

    static func initialViewController() -> RMBT.InfoViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? RMBT.InfoViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }
  }
  enum LaunchScreen: StoryboardSceneType {
    static let storyboardName = "LaunchScreen"

    static func initialViewController() -> UISplitViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? UISplitViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }
  }
  enum LaunchScreenAlladin: StoryboardSceneType {
    static let storyboardName = "LaunchScreenAlladin"
  }
  enum LaunchScreenHAKOM: StoryboardSceneType {
    static let storyboardName = "LaunchScreenHAKOM"
  }
  enum Main: String, StoryboardSceneType {
    static let storyboardName = "Main"

    static func initialViewController() -> SWRevealViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? SWRevealViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case swRevealViewControllerScene = "SWRevealViewController"
    static func instantiateSwRevealViewController() -> SWRevealViewController {
      guard let vc = StoryboardScene.Main.swRevealViewControllerScene.viewController() as? SWRevealViewController
      else {
        fatalError("ViewController 'SWRevealViewController' is not of the expected class SWRevealViewController.")
      }
      return vc
    }

    case hardwarePopupScene = "hardware_popup"
    static func instantiateHardwarePopup() -> RMBT.HardwarePopupViewController {
      guard let vc = StoryboardScene.Main.hardwarePopupScene.viewController() as? RMBT.HardwarePopupViewController
      else {
        fatalError("ViewController 'hardware_popup' is not of the expected class RMBT.HardwarePopupViewController.")
      }
      return vc
    }

    case ipPopupScene = "ip_popup"
    static func instantiateIpPopup() -> RMBT.IpPopupViewController {
      guard let vc = StoryboardScene.Main.ipPopupScene.viewController() as? RMBT.IpPopupViewController
      else {
        fatalError("ViewController 'ip_popup' is not of the expected class RMBT.IpPopupViewController.")
      }
      return vc
    }

    case locationPopupScene = "location_popup"
    static func instantiateLocationPopup() -> RMBT.LocationPopupViewController {
      guard let vc = StoryboardScene.Main.locationPopupScene.viewController() as? RMBT.LocationPopupViewController
      else {
        fatalError("ViewController 'location_popup' is not of the expected class RMBT.LocationPopupViewController.")
      }
      return vc
    }

    case measurementViewControllerScene = "measurement_view_controller"
    static func instantiateMeasurementViewController() -> RMBT.NKOMMeasurementViewController {
      guard let vc = StoryboardScene.Main.measurementViewControllerScene.viewController() as? RMBT.NKOMMeasurementViewController
      else {
        fatalError("ViewController 'measurement_view_controller' is not of the expected class RMBT.NKOMMeasurementViewController.")
      }
      return vc
    }

    case startViewControllerScene = "start_view_controller"
    static func instantiateStartViewController() -> RMBT.NKOMStartViewController {
      guard let vc = StoryboardScene.Main.startViewControllerScene.viewController() as? RMBT.NKOMStartViewController
      else {
        fatalError("ViewController 'start_view_controller' is not of the expected class RMBT.NKOMStartViewController.")
      }
      return vc
    }

    case trafficPopupScene = "traffic_popup"
    static func instantiateTrafficPopup() -> RMBT.TrafficPopupViewController {
      guard let vc = StoryboardScene.Main.trafficPopupScene.viewController() as? RMBT.TrafficPopupViewController
      else {
        fatalError("ViewController 'traffic_popup' is not of the expected class RMBT.TrafficPopupViewController.")
      }
      return vc
    }
  }
  enum Map: StoryboardSceneType {
    static let storyboardName = "Map"

    static func initialViewController() -> RMBT.RMBTMapViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? RMBT.RMBTMapViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }
  }
  enum QosResult: String, StoryboardSceneType {
    static let storyboardName = "QosResult"

    static func initialViewController() -> RMBT.QosMeasurementNewIndexViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? RMBT.QosMeasurementNewIndexViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case qosIndexNewScene = "qos_index_new"
    static func instantiateQosIndexNew() -> RMBT.QosMeasurementNewIndexViewController {
      guard let vc = StoryboardScene.QosResult.qosIndexNewScene.viewController() as? RMBT.QosMeasurementNewIndexViewController
      else {
        fatalError("ViewController 'qos_index_new' is not of the expected class RMBT.QosMeasurementNewIndexViewController.")
      }
      return vc
    }

    case qosIndexOldScene = "qos_index_old"
    static func instantiateQosIndexOld() -> RMBT.QosMeasurementIndexTableViewController {
      guard let vc = StoryboardScene.QosResult.qosIndexOldScene.viewController() as? RMBT.QosMeasurementIndexTableViewController
      else {
        fatalError("ViewController 'qos_index_old' is not of the expected class RMBT.QosMeasurementIndexTableViewController.")
      }
      return vc
    }
  }
  enum Settings: String, StoryboardSceneType {
    static let storyboardName = "Settings"

    static func initialViewController() -> RMBT.GeneralSettingsViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? RMBT.GeneralSettingsViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case hideWarning1Scene = "hide_warning1"
    static func instantiateHideWarning1() -> UITableViewController {
      guard let vc = StoryboardScene.Settings.hideWarning1Scene.viewController() as? UITableViewController
      else {
        fatalError("ViewController 'hide_warning1' is not of the expected class UITableViewController.")
      }
      return vc
    }

    case hideWarning2Scene = "hide_warning2"
    static func instantiateHideWarning2() -> RMBT.DeveloperModeSettingsViewController {
      guard let vc = StoryboardScene.Settings.hideWarning2Scene.viewController() as? RMBT.DeveloperModeSettingsViewController
      else {
        fatalError("ViewController 'hide_warning2' is not of the expected class RMBT.DeveloperModeSettingsViewController.")
      }
      return vc
    }

    case hideWarning3Scene = "hide_warning3"
    static func instantiateHideWarning3() -> RMBT.NerdModeSettingsViewController {
      guard let vc = StoryboardScene.Settings.hideWarning3Scene.viewController() as? RMBT.NerdModeSettingsViewController
      else {
        fatalError("ViewController 'hide_warning3' is not of the expected class RMBT.NerdModeSettingsViewController.")
      }
      return vc
    }
  }
  enum Terms: StoryboardSceneType {
    static let storyboardName = "Terms"

    static func initialViewController() -> RMBT.RMBTTOSViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? RMBT.RMBTTOSViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }
  }
}

enum StoryboardSegue {
  enum History: String, StoryboardSegueType {
    case showHistoryFilters = "show_history_filters"
    case showHistoryItem = "show_history_item"
    case showQosResults = "show_qos_results"
    case showQosResultsNew = "show_qos_results_new"
    case showResultDetails = "show_result_details"
    case showResultDetailsGrouped = "show_result_details_grouped"
    case showResultOnMap = "show_result_on_map"
    case unwindFromHistory
  }
  enum Info: String, StoryboardSegueType {
    case showGoogleMapsNotice = "show_google_maps_notice"
  }
  enum Main: String, StoryboardSegueType {
    case pushHelpViewController
    case pushHistoryViewController
    case pushHomeViewController
    case pushInfoViewController
    case pushMapViewController
    case pushSettingsViewController
    case pushStatisticsViewController
    case showMeasurementResult = "show_measurement_result"
    case showMeasurementViewController = "show_measurement_view_controller"
    case showTermsAndConditions = "show_terms_and_conditions"
    case swFront = "sw_front"
    case swRear = "sw_rear"
  }
  enum Map: String, StoryboardSegueType {
    case showMapFilter = "show_map_filter"
    case showMapOptions = "show_map_options"
    case showOwnMeasurementFromMap = "show_own_measurement_from_map"
  }
  enum QosResult: String, StoryboardSegueType {
    case showQosTest = "show_qos_test"
    case showQosTestDetail = "show_qos_test_detail"
    case showQosTestNew = "show_qos_test_new"
  }
  enum Terms: String, StoryboardSegueType {
    case showPublishPersonalData = "show_publish_personal_data"
  }
}

private final class BundleToken {}
