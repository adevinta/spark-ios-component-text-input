//
//  TextEditorGetVerticalSpacingUseCase.swift
//  SparkTextField
//
//  Created by robin.lemaire on 05/09/2024.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import Foundation
import SparkTheming

// TODO: test

// sourcery: AutoMockable
protocol TextEditorGetVerticalSpacingUseCaseable {
    func execute(font: any TypographyFontToken) -> CGFloat
}

final class TextEditorGetVerticalSpacingUseCase: TextEditorGetVerticalSpacingUseCaseable {

    // MARK: - Methods

    func execute(font: any TypographyFontToken) -> CGFloat {
        return (TextInputConstants.height - (font.uiFont.lineHeight)) / 2
    }
}
