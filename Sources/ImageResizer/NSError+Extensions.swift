import Foundation

public extension NSError {

    convenience init(code: Int = 1, description: String) {
        self.init(
            domain: "com.henrikpanhans.ImageResizer",
            code: code,
            userInfo: [NSLocalizedDescriptionKey: description])
    }

}
