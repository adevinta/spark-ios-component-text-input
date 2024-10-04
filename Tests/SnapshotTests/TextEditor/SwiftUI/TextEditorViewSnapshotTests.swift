//
//  TextEditorViewSnapshotTests.swift
//  SparkTextEditorSnapshotTests
//
//  Created by robin.lemaire on 30/11/2023.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import SparkTextInput
@_spi(SI_SPI) import SparkCommon
@_spi(SI_SPI) import SparkCommonSnapshotTesting
@_spi(SI_SPI) import SparkThemingTesting
import SparkTheming
import SparkTheme
import SwiftUI

@available(iOS 16.0, *)
final class TextEditorViewSnapshotTests: SwiftUIComponentSnapshotTestCase {

    // MARK: - Properties

    private let theme: Theme = SparkTheme.shared

    // MARK: - Tests

    func test() throws {
        let scenarios = TextEditorScenarioSnapshotTests.allCases

        for scenario in scenarios {
            let configurations: [TextEditorConfigurationSnapshotTests] = try scenario.configuration(
                isSwiftUIComponent: true
            )

            for configuration in configurations {
                let view = SnapshotView(configuration: configuration)

                self.assertSnapshot(
                    matching: view,
                    modes: configuration.modes,
                    sizes: configuration.sizes,
                    testName: configuration.testName()
                )
            }
        }
    }
}

// MARK: - View

@available(iOS 16.0, *)
private struct SnapshotView: View {

    // MARK: - Type Alias

    private typealias Constants = TextEditorSnapshotConstants

    // MARK: - Properties

    @ScaledMetric var fixedHeight = TextEditorSnapshotConstants.fixedHeight
    private let theme: Theme = SparkTheme.shared
    let configuration: TextEditorConfigurationSnapshotTests

    // MARK: - Initialization

    init(configuration: TextEditorConfigurationSnapshotTests) {
        self.configuration = configuration
    }

    // MARK: - View

    var body: some View {
        TextEditorView(
            self.configuration.placeholder.text ?? self.configuration.content.text,
            text: .constant(self.configuration.content.text),
            theme: self.theme,
            intent: self.configuration.intent
        )
            .disabled(!self.configuration.state.isEnabled)
//            .height(self.configuration.height)
            .frame(width: Constants.width, height: self.configuration.height.isFixed ? self.fixedHeight : nil)
            .padding(Constants.padding)
            .fixedSize()
            .background(.background)
    }
}

// MARK: - Extension

private extension View {

    @ViewBuilder
    func height(_ height: TextEditorHeight) -> some View {
        if let height = height.value {
            self.frame(height: height)
        } else {
            self
        }
    }
}
