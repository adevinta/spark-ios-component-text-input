//
//  TextEditorScenarioSnapshotTests.swift
//  SparkTextEditorSnapshotTests
//
//  Created by robin.lemaire on 30/11/2023.
//  Copyright © 2023 Adevinta. All rights reserved.
//

@testable import SparkTextInput
@_spi(SI_SPI) import SparkCommonSnapshotTesting
@_spi(SI_SPI) import SparkCommon
@_spi(SI_SPI) import SparkCommonTesting
import UIKit
import SwiftUI

enum TextEditorScenarioSnapshotTests: String, CaseIterable {
    case test1
    case test2
    case test3
    case test4
    case test5

    // MARK: - Type Alias

    typealias Constants = ComponentSnapshotTestConstants

    // MARK: - Configurations

    func configuration(isSwiftUIComponent: Bool) throws -> [TextEditorConfigurationSnapshotTests] {
        switch self {
        case .test1:
            return self.test1(isSwiftUIComponent: isSwiftUIComponent)
        case .test2:
            return self.test2(isSwiftUIComponent: isSwiftUIComponent)
        case .test3:
            return self.test3(isSwiftUIComponent: isSwiftUIComponent)
        case .test4:
            return self.test4(isSwiftUIComponent: isSwiftUIComponent)
        case .test5:
            return self.test5(isSwiftUIComponent: isSwiftUIComponent)
        }
    }

    // MARK: - Scenarios

    /// Test 1
    ///
    /// Description: To test all states with all lenght of text
    ///
    /// Content:
    /// - **states : all**
    /// - **content resilience : all**
    /// - a11y sizes : default
    /// - mode : default
    /// - height : flexible
    /// - placeholder: none
    private func test1(isSwiftUIComponent: Bool) -> [TextEditorConfigurationSnapshotTests] {
        let states = TextEditorState.allCases(isSwiftUIComponent: isSwiftUIComponent)
        let contentResiliences = TextEditorContentResilience.allCases(isSwiftUIComponent: isSwiftUIComponent)

        return states.flatMap { state in
            contentResiliences.map { contentResilience in
                return .init(
                    scenario: self,
                    state: state,
                    content: contentResilience,
                    placeholder: .empty,
                    height: .flexible
                )
            }
        }
    }

    /// Test 2
    ///
    /// Description: To test all a11y sizes for different height
    ///
    /// Content:
    /// - states : enabled
    /// - content resilience : filled with multiline text (small for UIKit)
    /// - **a11y sizes : all**
    /// - mode : default
    /// - **height : all**
    /// - placeholder: none
    private func test2(isSwiftUIComponent: Bool) -> [TextEditorConfigurationSnapshotTests] {
        let heights = TextEditorHeight.allCases

        return heights.map { height -> TextEditorConfigurationSnapshotTests in
                .init(
                    scenario: self,
                    state: .enabled,
                    content: isSwiftUIComponent ? .multilineText : .smallText,
                    placeholder: .empty,
                    height: height,
                    sizes: Constants.Sizes.all
                )
        }
    }

    /// Test 3
    ///
    /// Description: To test dark mode for all states
    ///
    /// Content:
    /// - **states : all**
    /// - content resilience : filled with small text
    /// - a11y sizes : default
    /// - mode : dark
    /// - height : flexible
    /// - placeholder: none
    private func test3(isSwiftUIComponent: Bool) -> [TextEditorConfigurationSnapshotTests] {
        let states = TextEditorState.allCases(isSwiftUIComponent: isSwiftUIComponent)

        return states.map { state -> TextEditorConfigurationSnapshotTests in
                .init(
                    scenario: self,
                    state: state,
                    content: .smallText,
                    placeholder: .empty,
                    height: .flexible,
                    modes: [.dark]
                )
        }
    }

    /// Test 4
    ///
    /// Description: To test different height for different content resilience
    ///
    /// Content:
    /// - states : enabled
    /// - **content resilience : all**
    /// - a11y sizes : default
    /// - mode : default
    /// - **height : all**
    /// - placeholder: none
    private func test4(isSwiftUIComponent: Bool) -> [TextEditorConfigurationSnapshotTests] {
        let contentResiliences = TextEditorContentResilience.allCases(isSwiftUIComponent: isSwiftUIComponent)
        let heights = TextEditorHeight.allCases

        return contentResiliences.flatMap { contentResilience in
            heights.map { height in
                return .init(
                    scenario: self,
                    state: .enabled,
                    content: contentResilience,
                    placeholder: .empty,
                    height: height
                )
            }
        }
    }

    /// Test 5
    ///
    /// Description: To test all states with all lenght of placeholder
    ///
    /// Content:
    /// - **states : all**
    /// - content resilience : none
    /// - a11y sizes : default
    /// - mode : default
    /// - height : flexible
    /// - **placeholder: all**
    private func test5(isSwiftUIComponent: Bool) -> [TextEditorConfigurationSnapshotTests] {
        let states = TextEditorState.allCases(isSwiftUIComponent: isSwiftUIComponent)
        let placeholders = TextEditorPlaceholder.allCases

        return states.flatMap { state in
            placeholders.map { placeholder in
                return .init(
                    scenario: self,
                    state: state,
                    content: .empty,
                    placeholder: placeholder,
                    height: .flexible
                )
            }
        }
    }
}