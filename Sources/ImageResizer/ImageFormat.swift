import Foundation

public enum ImageFormat {
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
    case livePhoto

    var cfIdentifier: CFString {
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
        case .livePhoto:
            return kUTTypeLivePhoto
        }
    }
}
