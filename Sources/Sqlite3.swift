//
//  File.swift
//  
//
//  Created by phimage on 15/04/2020.
//

import Foundation

struct Sqlite3 {
    var bin: String
    init?() {
        let (sqlite3, _, _) = run(cmd: "/usr/bin/which", args: "sqlite3")
        self.bin = sqlite3
        if self.bin.isEmpty {
            return nil
        }
    }
    var tableNames: [String] {
        let (output, _, _) = run(cmd: bin, args: data, ".tables")
        return output.replacingOccurrences(of: "\n", with: " ").split(separator: " ").map { String($0) }
    }
    var tables: [Table] {
        var tables: [Table] = []
        for tableName in tableNames {
            var table = Table(name: tableName)
            let (outputF, _, _) = run(cmd: bin, args: data, "pragma table_info(\(tableName))")
            for fieldLine in outputF.components(separatedBy: "\n") {
                let fieldArray = fieldLine.components(separatedBy: "|")
                table.fields.append(Field(index: Int(fieldArray[0])!, name: fieldArray[1], type: fieldArray[2]))
            }
            tables.append(table)
        }
        return tables
    }

    var tablesByName: [String: Table] {
        return Dictionary(grouping: tables, by: { $0.name }).mapValues { ($0.first!) }
    }
}
struct Table {
    var name: String
    var fields: [Field] = []

    var fielsByName: [String: Field] {
        return Dictionary(grouping: fields, by: { $0.name }).mapValues { ($0.first!) }
    }
}
struct Field {
    var index: Int
    var name: String
    var type: String
}
