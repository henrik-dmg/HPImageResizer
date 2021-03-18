import Foundation
import ImageIO

/// A class that can scale and resize images in a high-performant way
public class ImageResizer {

    // MARK: - Properties

    private let imageSource: CGImageSource
    private let originalImageSize: CGSize

    // MARK: - Init

	/// Initialises a new `ImageResizer` instance with that loads the passed in image URL
	/// - Parameter sourceURL: The URL of the source image that is supposed to be resized or scaled
	/// - Throws: Throws if there's no existing file (that is also an image) at the passed URL or when the image properties could not be read
    public init(sourceURL: URL) throws {
        guard let imageSource = CGImageSourceCreateWithURL(sourceURL as NSURL, nil) else {
			throw NSError(code: 5,description: "Could not load image at path: \(sourceURL.path)")
        }
        guard let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [AnyHashable: Any] else {
			throw NSError(code: 4, description: "Could not read image properties at path: \(sourceURL.path)")
        }
        guard
            let pixelWidth = imageProperties[kCGImagePropertyPixelWidth as String] as! CFNumber?,
            let pixelHeight = imageProperties[kCGImagePropertyPixelHeight as String] as! CFNumber?
        else {
			throw NSError(code: 6, description: "Could not read dimensions of image")
        }

        var width: CGFloat = 0
        var height: CGFloat = 0
        CFNumberGetValue(pixelWidth, .cgFloatType, &width)
        CFNumberGetValue(pixelHeight, .cgFloatType, &height)

        self.imageSource = imageSource
        self.originalImageSize = CGSize(width: width, height: height)
    }

    // MARK: - API

	/// Resizes the loaded image
	/// - Parameter size: The desired target size of the resized image
	/// - Throws: Throws if the image could not be resized correctly
	/// - Returns: The resized image
    public func resizeImage(to size: CGSize) throws -> CGImage {
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
        ]

        guard let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else {
			throw NSError(code: 7, description: "Could not scale loaded image")
        }
        return image
    }

	/// Resizes the loaded image and writes it to the specified destination URL
	/// - Parameters:
	///   - size: The desired target size of the resized image
	///   - destinationURL: The URL the resized image should be written to
	///   - format: The format that the resized image should be written in
	/// - Throws: Throws if the image could not be resized correctly or writing to the destination URL failed
	public func resizeImage(to size: CGSize, destinationURL: URL, format: ImageFormat) throws {
		let image = try resizeImage(to: size)
		try write(image: image, to: destinationURL, format: format)
	}

	/// Scales the loaded image by a factor
	/// - Parameter scale: The desired relative scale of the scaled image
	/// - Throws: Throws if the image could not be scaled correctly
	/// - Returns: The scaled image
    public func scaleImage(to scale: CGFloat) throws -> CGImage {
        let targetSize = try originalImageSize.scaled(by: scale)
        return try resizeImage(to: targetSize)
    }

	/// Scales the loaded image and writes it to the specified destination URL
	/// - Parameters:
	///   - scale: The desired relative scale of the scaled image
	///   - destinationURL: The URL the scaled image should be written to
	///   - format: The format that the scaled image should be written in
	/// - Throws: Throws if the image could not be scaled correctly or writing to the destination URL failed
	public func scaleImage(to scale: CGFloat, destinationURL: URL, format: ImageFormat) throws {
		let targetSize = try originalImageSize.scaled(by: scale)
		try resizeImage(to: targetSize, destinationURL: destinationURL, format: format)
	}

	// MARK: - Helper

    private func write(image: CGImage, to url: URL, format: ImageFormat) throws {
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, format.cfIdentifier, 1, nil) else {
			throw NSError(code: 8, description: "Could not create image destination with format \(format.rawValue)")
        }
        CGImageDestinationAddImage(destination, image, nil)
        if !CGImageDestinationFinalize(destination) {
            throw NSError(code: 9, description: "Failed to write scaled image to path: \(url.path)")
        }
    }

}
