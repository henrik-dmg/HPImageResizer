import Foundation
import CoreGraphics

public struct ImageResizer {

    public init() {}

    public func resizeImage(at url: URL, with size: CGSize) throws -> CGMetadataImage {
        let image = try loadImage(at: url)

        return try scaleImage(image, to: size)
    }

    public func scaleImage(at url: URL, to scale: CGFloat) throws -> CGMetadataImage {
        let image = try loadImage(at: url)
        let scaledSize = image.cgImage.size.scaled(by: scale)

        return try scaleImage(image, to: scaledSize)
    }

    public func write(metaImage: CGMetadataImage, to destinationURL: URL, format: CFString = kUTTypePNG) throws {
        try write(image: metaImage.cgImage, with: metaImage.metadata, to: destinationURL, format: format)
    }

    public func write(image: CGImage, with metadata: CFDictionary?, to destinationURL: URL, format: CFString = kUTTypePNG) throws {
        guard let destination = CGImageDestinationCreateWithURL(destinationURL as CFURL, format, 1, metadata) else {
            throw NSError(description: "Failed to create destination image")
        }
        CGImageDestinationAddImage(destination, image, nil)
        if !CGImageDestinationFinalize(destination) {
            throw NSError(description: "Failed to write image to disk")
        }
    }

    public func loadImage(at url: URL) throws -> CGMetadataImage {
        guard
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            throw NSError(description: "Failed to load image file")
        }

        let metadata = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)
        return CGMetadataImage(cgImage: image, metadata: metadata)
    }

    public func scaleImage(_ image: CGMetadataImage, to size: CGSize) throws -> CGMetadataImage {
        let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.width),
            bitsPerComponent: image.cgImage.bitsPerComponent,
            bytesPerRow: image.cgImage.bytesPerRow,
            space: image.cgImage.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: image.cgImage.bitmapInfo.rawValue)
        context?.interpolationQuality = .high
        context?.draw(image.cgImage, in: CGRect(origin: .zero, size: size))

        guard let scaledImage = context?.makeImage() else {
            throw NSError(description: "Failed to render scaled image")
        }

        let modifiedMeta = injectNewResolution(size, into: image.metadata)

        return CGMetadataImage(cgImage: scaledImage, metadata: modifiedMeta)
    }

    private func injectNewResolution(_ size: CGSize, into metadata: CFDictionary?) -> CFDictionary? {
        guard var meta = metadata as? [String: AnyObject] else {
            return metadata
        }

        meta["PixelHeight"] = Int(size.height) as AnyObject
        meta["PixelWidth"] = Int(size.width) as AnyObject
        return meta as CFDictionary
    }

}

extension CGImage {

    var size: CGSize {
        CGSize(width: width, height: height)
    }

}
