import AppKit
import Foundation
import CLIFoundation
import SPMUtility
import ImageResizer

struct ResizeCommand: Command {
    let command: String = "resize"
    let overview: String = "Resizes the passed in image to the specified scale"

    private let inputPath: OptionArgument<String>
    private let scale: OptionArgument<Int>
    private let verbose: OptionArgument<Bool>

    init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        inputPath = subparser.add(option: "--image", shortName: "-i", completion: .filename)
        scale = subparser.add(option: "--scale", shortName: "-s", completion: .unspecified)
        verbose = subparser.add(option: "--verbose", shortName: "-v")
    }

    func run(with arguments: ArgumentParser.Result) throws {
        guard let inputPathString = arguments.get(inputPath) else {
            throw NSError(description: "No input path was specified")
        }

        var isDirectory = ObjCBool(false)
        guard FileManager.default.fileExists(atPath: inputPathString, isDirectory: &isDirectory), !isDirectory.boolValue else {
            throw NSError(description: "The specified path does not exist or is a directory")
        }

        guard let scaleInt = arguments.get(scale) else {
            print("No scale was specified, exiting".with(.yellow))
            return
        }

        let fileURL = Foundation.URL(fileURLWithPath: inputPathString)
        let resizer = ImageResizer()
        let image = try resizer.scaleImage(at: fileURL, to: CGFloat(scaleInt)/100)

        let outputURL = makeOutputPath(for: fileURL, scale: scaleInt)

        try resizer.write(metaImage: image, to: outputURL, format: kUTTypeJPEG)
        //try resizer.write(image: image, to: fileURL, format: kUTTypePNG)
    }

    func makeOutputPath(for url: Foundation.URL, scale: Int) -> Foundation.URL {
        let pathExtension = url.pathExtension.isEmpty ? nil : url.pathExtension
        let droppedURL = url.deletingPathExtension()

        let fileName = droppedURL.lastPathComponent + "@\(scale)"
        let constructedFileName = [fileName, pathExtension].compactMap { $0 }.joined(separator: ".")

        return url.deletingLastPathComponent().appendingPathComponent(constructedFileName)
    }

}

extension NSImage {

    var nativeSize: NSSize {
        guard let rep = representations.first else {
            return .zero
        }
        return NSSize(width: rep.pixelsWide, height: rep.pixelsHigh)
    }

}

extension Foundation.URL {

    func loadImage() throws -> NSImage {
        guard let image = NSImage(contentsOf: self) else {
            throw NSError(description: "Could not load image at \(absoluteString)")
        }
        return image
    }

}
