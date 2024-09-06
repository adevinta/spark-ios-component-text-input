//
//  TextEditorViewModel.swift
//  SparkEditor
//
//  Created by robin.lemaire on 05/09/2024.
//  Copyright © 2024 Adevinta. All rights reserved.
//

import Foundation
import SparkTheming

final class TextEditorViewModel: TextInputViewModel {

    // MARK: - Published Properties

    @Published private(set) var verticalSpacing: CGFloat = 0
    @Published private(set) var isPlaceholder: Bool = false

    // MARK: - Private Properties

    private let getVerticalSpacingUseCase: TextEditorGetVerticalSpacingUseCaseable

    // MARK: - Initialization

    init(
        theme: Theme,
        intent: TextEditorIntent,
        getVerticalSpacingUseCase: TextEditorGetVerticalSpacingUseCaseable = TextEditorGetVerticalSpacingUseCase()
    ) {
        self.getVerticalSpacingUseCase = getVerticalSpacingUseCase

        super.init(theme: theme, intent: intent)

        self.setVerticalSpacing()
    }

    // MARK: - Update

    func contentChanged(with text: String) {
        self.isPlaceholder = text.isEmpty
    }

    // MARK: - Setter

    private func setVerticalSpacing() {
        self.verticalSpacing = self.getVerticalSpacingUseCase.execute(font: self.font)
    }

    override func setFont() {
        super.setFont()

        self.setVerticalSpacing()
    }
}
