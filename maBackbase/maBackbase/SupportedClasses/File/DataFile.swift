//
//  FileReader.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/30/19.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation

final class DataFile {

    private enum Constants {

        enum FileExtensions {

            static let json = "json"
        }
    }

    let name: String
    let url: URL
    let `extension`: String
    let rawData: Data
    let fileType: FileType

    // MARK: - LifeCycle

    init?(_ fileType: FileType) {

        if let url = Bundle(for: type(of: self))
            .url(forResource: "\(fileType.rawValue)", withExtension: Constants.FileExtensions.json) {

            do {
                self.rawData = try Data(contentsOf: url)

                self.fileType = fileType
                self.url = url
                self.extension = Constants.FileExtensions.json
                self.name = "\(fileType.rawValue)"

            } catch {
                return nil
            }

        } else {
            return nil
        }
    }
}
