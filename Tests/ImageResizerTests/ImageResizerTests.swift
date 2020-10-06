import XCTest
import CoreGraphics
@testable import ImageResizer

final class ImageResizerTests: XCTestCase {

    static var imageSourceURL: URL {
        let path = FileManager.default.currentDirectoryPath
        return URL(fileURLWithPath: path).appendingPathComponent("testingImage").appendingPathExtension("png")
    }

    func testScaleImageToFiftyPercent() throws {
        try writeTestingImage()
        let resizer = try ImageResizer(sourceURL: ImageResizerTests.imageSourceURL)
        let resizedImage = try resizer.scaleImage(to: 0.5)
        try cleanUp()

        XCTAssertEqual(resizedImage.width, 50)
        XCTAssertEqual(resizedImage.height, 25)
    }

    func writeTestingImage() throws {
        let image = try CGContext.makePlainWhiteImage(with: CGSize(width: 100, height: 50))
        guard let destination = CGImageDestinationCreateWithURL(ImageResizerTests.imageSourceURL as CFURL, "public.png" as CFString, 1, nil) else {
            throw NSError(description: "Could not create image destination")
        }
        CGImageDestinationAddImage(destination, image, nil)
        guard CGImageDestinationFinalize(destination) else {
            throw NSError(description: "Could not write image")
        }
    }

    func cleanUp() throws {
        try FileManager.default.removeItem(at: ImageResizerTests.imageSourceURL)
    }

}

extension CGContext {

    static func makePlainWhiteImage(with size: CGSize) throws -> CGImage {
        let context = try makeContext(with: size)
        return try context.makePlainWhiteImage()
    }

    static func makeContext(with size: CGSize) throws -> CGContext {
        let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )

        guard let cgContext = context else {
            throw NSError(description: "No context could be created")
        }
        return cgContext
    }

    func makePlainWhiteImage() throws -> CGImage {
        #if os(macOS)
        setFillColor(.white)
        #else
        if #available(iOS 13, *) {
            setFillColor(CGColor(gray: 1, alpha: 1))
        }
        #endif
        fill(CGRect(x: 0, y: 0, width: width / 2, height: height))
        guard let image = makeImage() else {
            throw NSError(description: "No image was rendered")
        }
        return image
    }

}
