import UIKit
import AVFoundation

struct Helper {

  static func rotationTransform() -> CGAffineTransform {
    switch UIDevice.current.orientation {
    case .landscapeLeft:
      return CGAffineTransform(rotationAngle: .pi/2)
    case .landscapeRight:
      return CGAffineTransform(rotationAngle: -.pi/2)
    case .portraitUpsideDown:
      return CGAffineTransform(rotationAngle: .pi)
    default:
      return CGAffineTransform.identity
    }
  }

  static func videoOrientation() -> AVCaptureVideoOrientation {
    switch UIDevice.current.orientation {
    case .portrait: return .portrait
    case .landscapeLeft: return .landscapeRight
    case .landscapeRight: return .landscapeLeft
    case .portraitUpsideDown: return .portraitUpsideDown
    default: return .portrait
    }
  }
}
