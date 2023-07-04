//
//  OpenAPIDocValidator.swift
//  OpenAPIKitForValidation
//
//  Created by mikaurakawa on 2023/07/02.
//

import Foundation
import OpenAPIKit
import Yams

final class OpenAPIDocValidator {
    let url: URL?

    init(url: URL?) {
        self.url = url
    }

    func validate() {
        guard let fileURL = url,
              let fileContents = try? String(contentsOf: fileURL, encoding: .utf8)
        else { fatalError("cannot read file") }

        do {
            let decoder = YAMLDecoder()
            let openAPIDoc = try decoder.decode(OpenAPI.Document.self, from: fileContents)
            print("ここまできた")
            print(openAPIDoc.allServers)

            let encoder = YAMLEncoder()
            let encodedOpenAPIDoc = try encoder.encode(openAPIDoc)
            print(encodedOpenAPIDoc)

            try openAPIDoc.validate(using: Validator()
                .validating(.documentContainsPaths)
                .validating(.pathsContainOperations)
                .validating(.operationsContainResponses)
                .validating(.schemaComponentsAreDefined)
                .validating(.pathParametersAreDefined)
                .validating(.serverVariablesAreDefined)
                .validating(
                    "At least two servers are specified if one of them is the test server.",
                    check: \[OpenAPI.Server].count >= 2,
                    when: { context in
                        context.subject.map {
                            $0.urlTemplate.absoluteString
                        }.contains("localhost")
                    }
                )
            )

            print("ここまできた2")
        } catch let error {
            print("エラーになった")
            print(error)
            print(OpenAPI.Error(from: error).localizedDescription)
        }
    }

}
