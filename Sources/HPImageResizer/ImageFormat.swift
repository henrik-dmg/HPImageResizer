import Foundation
import ImageIO
#if !os(macOS)
import MobileCoreServices
#endif

/// A type that can be used to specify the desired output format of an image
public enum ImageFormat: String, Equatable, Hashable, CaseIterable {

	/// The JPEG format
    case jpeg
	/// The JPEG2000 format
    case jpeg2000
	/// The TIFF format
    case tiff
	/// The PICT format
    case pict
	/// The GIF format
    case gif
	/// The PNG format
    case png
	/// The QuickTime Image format
    case quickTimeImage
	/// The Apple ICNS format
    case appleICNS
	/// The BMP format
    case bmp
	/// The ICO format
    case ico
	/// The RAW format
    case raw
	/// The SVG format
    case svg

    var fileEndings: [String] {
        switch self {
        case .jpeg:
            return ["jpg", "jpeg"]
        case .jpeg2000:
            return ["jp2", "j2k", "jpf", "jpx", "jpm", "mj2"]
        case .tiff:
            return ["jpg", "jpeg", "jpe", "jif", "jfif", "jfi"]
        case .pict:
            return ["pict", "pct", "pic"]
        case .gif:
            return ["gif"]
        case .png:
            return ["png"]
        case .quickTimeImage:
            return ["qt"]
        case .appleICNS:
            return ["icns"]
        case .bmp:
            return ["bmp", "dib"]
        case .ico:
            return ["ico"]
        case .raw:
            return ["dng"]
        case .svg:
            return ["svg"]
        }
    }

    var cfIdentifier: CFString {
        switch self {
        case .jpeg:
            return kUTTypeJPEG
        case .jpeg2000:
            return kUTTypeJPEG2000
        case .tiff:
            return kUTTypeTIFF
        case .pict:
            return kUTTypePICT
        case .gif:
            return kUTTypeGIF
        case .png:
            return kUTTypePNG
        case .quickTimeImage:
            return kUTTypeQuickTimeImage
        case .appleICNS:
            return kUTTypeAppleICNS
        case .bmp:
            return kUTTypeBMP
        case .ico:
            return kUTTypeICO
        case .raw:
            return kUTTypeRawImage
        case .svg:
            return kUTTypeScalableVectorGraphics
        }
    }

    init?(lowercased: String) {
        guard let format = ImageFormat.allCases.first(where: { $0.rawValue.lowercased() == lowercased }) else {
            return nil
        }
        self = format
    }
    
}
