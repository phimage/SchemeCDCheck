//
//  main.swift
//  JSONToCoreData
//
//  Created by Anass TALII on 07/06/2017.
//  Copyright © 2017 phimage. All rights reserved.
//

import Foundation
import MomXML
import SWXMLHash
if CommandLine.arguments.count < 2 {
    print("Invalid usage. Missing path to .xcadatamodel file and sqlite database")
    print("usage: <model> <database.sqlite>")
    exit(1)
}

let argument = CommandLine.arguments[1]
var model: String = CommandLine.arguments[1]
var data: String = CommandLine.arguments[2]

var modelURL = URL(fileURLWithPath: model)
if modelURL.pathExtension == "xcdatamodeld" {
    modelURL = modelURL.appendingPathComponent("\(modelURL.deletingPathExtension().lastPathComponent).xcdatamodel")
}
if modelURL.pathExtension == "xcdatamodel" {
    modelURL = modelURL.appendingPathComponent("contents")
}

guard let xmlString = try? String(contentsOf: modelURL) else {
    print("Failed to read \(modelURL)")
    exit(1)
}
let xml = SWXMLHash.parse(xmlString)
guard let parsedMom = MomXML(xml: xml) else {
    print("Failed to parse \(modelURL)")
    exit(1)
}
guard let sqlite = Sqlite3() else {
    print("Cannot find sqlite3 command")
    exit(1)
}
let tables: [String: Table] = sqlite.tablesByName
for entity in parsedMom.model.entities {
    if let table = tables[entity.sqliteName] {
        let fields = table.fielsByName
        for attribute in entity.attributes {
            if let field = fields[attribute.sqliteName] {
                if field.type != attribute.attributeType.sqliteName {
                    print("🚫 Wrong type for field: \(entity.name)#\(attribute.name) - \(field.type) \( attribute.attributeType)=\(attribute.attributeType.sqliteName)")
                }
            } else {
                print("🚫 Missing field: \(entity.name)#\(attribute.name)")
            }
        }
    } else {
        print("🚫 Missing table: \(entity.name)")
    }
}

exit(0)
