//
//  Logger.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 7.12.2023.
//

import Foundation

final class Logger {
    static let shared = Logger()
    private init() { }
    var shouldPrint: Bool = true //prod'da false yap.

    func log(text: String, function: String = #function, line: Int = #line, filePath: String = #filePath) {
        guard shouldPrint else { return }
        print("🐞🐞🐞🐞🐞🐞🐞🐞")
        print("<<<<<-----")
        print("Error:", text)
        print("Function:", function)
        print("Line:", line)
        print("File Path:", filePath)
        print("----->>>>>")
    }
}
