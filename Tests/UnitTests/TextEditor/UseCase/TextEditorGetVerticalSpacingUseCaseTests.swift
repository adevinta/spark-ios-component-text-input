//
//  TextEditorGetVerticalSpacingUseCaseTests.swift
//  SparkTextFieldUnitTests
//
//  Created by robin.lemaire on 11/09/24.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import XCTest

@testable import SparkTextInput
import SparkTheming
@_spi(SI_SPI) import SparkThemingTesting

final class TextEditorGetVerticalSpacingUseCaseTests: XCTestCase {

    // MARK: - Properties

    private let themeMock = ThemeGeneratedMock.mocked()

    // MARK: - Tests

    func test_execute() {
        // GIVEN
        let useCase = TextEditorGetVerticalSpacingUseCase()

        let font = TypographyFontTokenGeneratedMock()
        font.uiFont = UIFont.systemFont(ofSize: 20)

        // WHEN
        let spacing = useCase.execute(
            font: font
        )

        // THEN
        let expectedSpacing = (TextInputConstants.height - font.uiFont.lineHeight) / 2
        XCTAssertEqual(spacing, expectedSpacing)
    }
}
