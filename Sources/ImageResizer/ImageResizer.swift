import Foundation
import CoreGraphics

public struct ImageResizer {

    public let sourceImageURL: URL

    @discardableResult public func resizeImage(with specification: ImageSpecification) -> Bool {
        guard
            let imageSource = CGImageSourceCreateWithURL(sourceImageURL as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            return false
        }

        let context = CGContext(
            data: nil,
            width: Int(specification.size.width),
            height: Int(specification.size.width),
            bitsPerComponent: image.bitsPerComponent,
            bytesPerRow: image.bytesPerRow,
            space: image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: image.bitmapInfo.rawValue)
        context?.interpolationQuality = .high
        context?.draw(image, in: CGRect(origin: .zero, size: specification.size))

        guard let scaledImage = context?.makeImage() else {
            return false
        }

        let destinationURL: URL
        if let specificationURL = specification.filePath {
            destinationURL = specificationURL.appendingPathComponent(specification.fileName)
        } else {
            destinationURL = sourceImageURL.deletingLastPathComponent().appendingPathComponent(specification.fileName)
        }
        return writeCGImage(scaledImage, to: destinationURL, format: specification.imageFormat.cfIdentifier)
    }

    private func writeCGImage(_ image: CGImage, to destinationURL: URL, format: CFString = kUTTypePNG) -> Bool {
        guard let destination = CGImageDestinationCreateWithURL(destinationURL as CFURL, format, 1, nil) else {
            return false
        }
        CGImageDestinationAddImage(destination, image, nil)
        return CGImageDestinationFinalize(destination)
    }
}
