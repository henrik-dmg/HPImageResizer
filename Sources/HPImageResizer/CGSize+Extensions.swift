import Foundation
import CoreGraphics

public extension CGSize {

	/// Scales the current size by the passed in factor
	/// - Parameter factor: The factor by which the `CGSize` should be scaled
	/// - Throws: Throws if the passed in factor is less than or equal to 0
	/// - Returns: A new, scaled `CGSize` instance
    func scaled(by factor: CGFloat) throws -> CGSize {
        guard factor > 0.00 else {
			throw NSError(code: 3, description: "Unable to scale size to factor \(factor)")
        }
        return CGSize(width: width * factor, height: height * factor)
    }

}
