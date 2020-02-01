import Foundation

public struct CGMetadataImage {

    public let cgImage: CGImage
    public let metadata: CFDictionary?

    public init(cgImage: CGImage, metadata: CFDictionary?) {
        self.cgImage = cgImage
        self.metadata = metadata
    }

}
