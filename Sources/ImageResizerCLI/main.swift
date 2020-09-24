import Foundation
import ArgumentParser
import ImageResizer

struct HPResize: ParsableCommand {

    @Argument(help: "The image that should be resized")
    var image: URL

    @Option(name: .shortAndLong, help: "The scale to which the image should be scaled in percent")
    var scale: Int

    @Option(name: .shortAndLong, help: "The format of the output image")
    var format: ImageFormat

    @Flag(help: "Prints additional information during rendering")
    var verbose = false

    static var configuration = CommandConfiguration(
        commandName: "image-resizer",
        abstract: "Resizes an input image to a specified scale",
        helpNames: .shortAndLong)

    func run() throws {
        var isDirectory = ObjCBool(false)
        guard FileManager.default.fileExists(atPath: image.path, isDirectory: &isDirectory), !isDirectory.boolValue else {
            throw NSError(description: "The specified path does not exist or is a directory")
        }

        let resizer = try ImageResizer(sourceURL: image)
        let outputURL = makeOutputPath(for: image, scale: scale)
        try resizer.scaleImage(to: CGFloat(scale) / 100, destinationURL: outputURL, format: format)
    }

    func makeOutputPath(for url: Foundation.URL, scale: Int) -> Foundation.URL {
        let pathExtension = url.pathExtension.isEmpty ? nil : url.pathExtension
        let droppedURL = url.deletingPathExtension()

        let fileName = droppedURL.lastPathComponent + "@\(scale)"
        let constructedFileName = [fileName, pathExtension].compactMap { $0 }.joined(separator: ".")

        return url.deletingLastPathComponent().appendingPathComponent(constructedFileName)
    }

}

extension URL: ExpressibleByArgument {

    public init?(argument: String) {
        self.init(fileURLWithPath: argument)
    }

}

extension ImageFormat: ExpressibleByArgument {

    public init?(argument: String) {
        self.init(lowercased: argument.lowercased())
    }

}

HPResize.main()
