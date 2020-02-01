import Foundation
import CLIFoundation

var registry = CommandRegistry(usage: "<command> <options>", overview: "SwiftyWebsite")
registry.register(command: ResizeCommand.self)
registry.run()
