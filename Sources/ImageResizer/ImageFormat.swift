import Foundation

public enum ImageFormat: String, Equatable, Hashable, CaseIterable {

    case image
    case jpeg
    case jpeg2000
    case tiff
    case pict
    case gif
    case png
    case quickTimeImage
    case appleICNS
    case bmp
    case ico
    case raw
    case svg

    public var fileEndings: [String] {
        switch self {
        case .image:
            return []
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

    public var cfIdentifier: CFString {
        switch self {
        case .image:
            return kUTTypeImage
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

    public init?(lowercased: String) {
        guard let format = ImageFormat.allCases.first(where: { $0.rawValue.lowercased() == lowercased }) else {
            return nil
        }
        self = format
    }
    
}
