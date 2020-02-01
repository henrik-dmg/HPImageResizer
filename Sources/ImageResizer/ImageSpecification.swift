import Foundation
import CoreGraphics

//public protocol ImageSpecification {
//    var fileName: String { get}
//    var filePath: URL? { get}
//    var size: CGSize { get}
//    var imageFormat: ImageFormat { get}
//}

public struct ImageSpecification {
    var fileName: String
    var filePath: URL?
    var size: CGSize
    var imageFormat: ImageFormat

    public init(fileName: String, filePath: URL?, size: CGSize, imageFormat: ImageFormat) {
        self.fileName = fileName
        self.filePath = filePath
        self.size = size
        self.imageFormat = imageFormat
    }
}
