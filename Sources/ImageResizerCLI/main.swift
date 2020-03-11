import Foundation
import CLIFoundation
import ArgumentParser
import ImageResizer

struct HPResize: ParsableCommand {

    @Option(name: .shortAndLong, help: "The image that should be resized")
    var image: String

    @Option(name: .shortAndLong, help: "The scale to which the image should be scaled in percent")
    var scale: Int

    @Flag(help: "Prints additional information during rendering")
    var verbose: Bool

    static var configuration = CommandConfiguration(
        commandName: "hpresize",
        abstract: "Resizes an input image to a specified scale",
        helpNames: .shortAndLong)

    func run() throws {
        var isDirectory = ObjCBool(false)
        guard FileManager.default.fileExists(atPath: image, isDirectory: &isDirectory), !isDirectory.boolValue else {
            throw NSError(description: "The specified path does not exist or is a directory")
        }

        let fileURL = Foundation.URL(fileURLWithPath: image)
        let resizer = ImageResizer()
        let image = try resizer.scaleImage(at: fileURL, to: CGFloat(scale)/100)

        let outputURL = makeOutputPath(for: fileURL, scale: scale)

        try resizer.write(metaImage: image, to: outputURL, format: kUTTypeJPEG)
    }

    func makeOutputPath(for url: Foundation.URL, scale: Int) -> Foundation.URL {
        let pathExtension = url.pathExtension.isEmpty ? nil : url.pathExtension
        let droppedURL = url.deletingPathExtension()

        let fileName = droppedURL.lastPathComponent + "@\(scale)"
        let constructedFileName = [fileName, pathExtension].compactMap { $0 }.joined(separator: ".")

        return url.deletingLastPathComponent().appendingPathComponent(constructedFileName)
    }

}

HPResize.main()
