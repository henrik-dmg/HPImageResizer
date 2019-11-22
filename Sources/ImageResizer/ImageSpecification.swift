import Foundation
import CoreGraphics

public protocol ImageSpecification {
    var fileName: String { get}
    var filePath: URL? { get}
    var size: CGSize { get}
    var imageFormat: ImageFormat { get}
}
