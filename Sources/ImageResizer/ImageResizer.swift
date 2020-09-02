import Foundation
import ImageIO

public class ImageResizer {

    // MARK: - Properties

    let imageSource: CGImageSource
    let originalImageSize: CGSize

    // MARK: - Init

    public init(sourceURL: URL) throws {
        guard let imageSource = CGImageSourceCreateWithURL(sourceURL as NSURL, nil) else {
            throw NSError(description: "Could not load image at path: \(sourceURL.path)")
        }
        guard let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [AnyHashable: Any] else {
            throw NSError(description: "Could not read image properties at path: \(sourceURL.path)")
        }
        guard
            let pixelWidth = imageProperties[kCGImagePropertyPixelWidth as String] as! CFNumber?,
            let pixelHeight = imageProperties[kCGImagePropertyPixelHeight as String] as! CFNumber?
        else {
            throw NSError(description: "Could not read dimensions of image")
        }

        var width: CGFloat = 0
        var height: CGFloat = 0
        CFNumberGetValue(pixelWidth, .cgFloatType, &width)
        CFNumberGetValue(pixelHeight, .cgFloatType, &height)

        self.imageSource = imageSource
        self.originalImageSize = CGSize(width: width, height: height)
    }

    // MARK: - API

    public func resizeImage(to size: CGSize, destinationURL: URL) throws {
        let image = try resizeImage(to: size)
        try write(image: image, to: destinationURL)
    }

    public func scaleImage(to scale: CGFloat, destinationURL: URL) throws {
        let targetSize = originalImageSize.scaled(by: scale)
        try resizeImage(to: targetSize, destinationURL: destinationURL)
    }

    // Adapted from NSHipster https://nshipster.com/image-resizing/#technique-3-creating-a-thumbnail-with-image-io
    public func resizeImage(to size: CGSize) throws -> CGImage {
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
        ]

        guard let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else {
            throw NSError(description: "Could not scale loaded image")
        }
        return image
    }

    public func scaleImage(to scale: CGFloat) throws -> CGImage {
        let targetSize = originalImageSize.scaled(by: scale)
        return try resizeImage(to: targetSize)
    }

    public func write(image: CGImage, to url: URL) throws {
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, kUTTypePNG, 1, nil) else {
            throw NSError(description: "Could not create image destination")
        }
        CGImageDestinationAddImage(destination, image, nil)
        if !CGImageDestinationFinalize(destination) {
            throw NSError(description: "Failed to write scaled image to path: \(url.path)")
        }
    }

}
