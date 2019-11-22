import Foundation
import CoreGraphics

public extension CGSize {
    func scaled(by factor: CGFloat) -> CGSize {
        guard factor > 0.00 else {
            print("Unable to scale size to factor", factor)
            return self
        }
        return CGSize(width: width * factor, height: height * factor)
    }
}
