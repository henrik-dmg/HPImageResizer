import Foundation

public extension NSError {

    convenience init(description: String) {
        self.init(
            domain: "com.henrikpanhans.ImageResizer",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: description])
    }

}
