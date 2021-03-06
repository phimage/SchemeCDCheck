import Foundation

func run(cmd: String, args: String...) -> (output: String, error: String, exitCode: Int32) {

    var output: String = ""
    var error: String = ""

    let task = Process()
    task.launchPath = cmd
    task.arguments = args

    let outpipe = Pipe()
    task.standardOutput = outpipe
    let errpipe = Pipe()
    task.standardError = errpipe

    task.launch()

    let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
    if let string = String(data: outdata, encoding: .utf8) {
        output = string.trimmingCharacters(in: .newlines)
    }

    let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
    if let string = String(data: errdata, encoding: .utf8) {
        error = string.trimmingCharacters(in: .newlines)
    }

    task.waitUntilExit()
    let status = task.terminationStatus

    return (output, error, status)
}

import MomXML
extension MomEntity {

    var sqliteName: String {
        return "Z\(name.uppercased())"
    }
}
extension MomAttribute {

    var sqliteName: String {
        return "Z\(name.uppercased())"
    }
}
extension MomAttribute.AttributeType {

    var sqliteName: String {
        switch self {
        case .string:
            return "VARCHAR"
        case .date:
            return "TIMESTAMP"
        case .integer32:
            return "INTEGER"
        case .boolean:
            return "INTEGER"
        default:
            return self.rawValue.uppercased()
        }
    }

}
