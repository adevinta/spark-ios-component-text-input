//
//  TextFieldView.swift
//  SparkTextField
//
//  Created by louis.borlee on 07/02/2024.
//  Copyright © 2024 Adevinta. All rights reserved.
//

import SwiftUI
import SparkTheming

/// A TextField that can be surrounded by left and/or right views
public struct TextFieldView<LeftView: View, RightView: View>: View {

    // MARK: - Properties

    private let titleKey: LocalizedStringKey
    private let text: Binding<String>
    private let type: TextFieldViewType
//    private let viewModel: TextInputViewModel


    private let theme: Theme
    private let intent: TextFieldIntent
    private let borderStyle: TextInputBorderStyle
    private let isReadOnly: Bool


    private let leftView: () -> LeftView
    private let rightView: () -> RightView

    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var isFocused: Bool

    // MARK: - Initialization
//
//    init(titleKey: LocalizedStringKey,
//         text: Binding<String>,
//         viewModel: TextInputViewModel,
//         type: TextFieldViewType,
//         leftView: @escaping (() -> LeftView),
//         rightView: @escaping (() -> RightView)) {
//        self.titleKey = titleKey
//        self.text = text
////        self.viewModel = viewModel
//        self.type = type
//        self.leftView = leftView
//        self.rightView = rightView
//    }

    init(
        _ titleKey: LocalizedStringKey,
        text: Binding<String>,
        theme: Theme,
        intent: TextFieldIntent,
        borderStyle: TextInputBorderStyle,
        type: TextFieldViewType,
        isReadOnly: Bool,
        leftView: @escaping (() -> LeftView),
        rightView: @escaping (() -> RightView)
    ) {
//        let viewModel = TextInputViewModel(
//            theme: theme,
//            intent: intent,
//            borderStyle: borderStyle
//        )
//        viewModel.isReadOnly = isReadOnly
//        self.init(
//            titleKey: titleKey,
//            text: text,
//            viewModel: viewModel,
//            type: type,
//            leftView: leftView,
//            rightView: rightView
//        )


       self.titleKey = titleKey
       self.text = text
//        self.viewModel = viewModel


        self.theme = theme
        self.intent = intent
        self.borderStyle = borderStyle
        self.isReadOnly = isReadOnly


       self.type = type
       self.leftView = leftView
       self.rightView = rightView
    }

    /// TextFieldView initializer
    /// - Parameters:
    ///   - titleKey: The textfield's current placeholder
    ///   - text: The textfield's text binding
    ///   - theme: The textfield's current theme
    ///   - intent: The textfield's current intent
    ///   - type: The type of field with its associated callback(s), default is `.standard()`
    ///   - isReadOnly: Set this to true if you want the textfield to be readOnly, default is `false`
    ///   - leftView: The TextField's left view, default is `EmptyView`
    ///   - rightView: The TextField's right view, default is `EmptyView`
    public init(_ titleKey: LocalizedStringKey,
                text: Binding<String>,
                theme: Theme,
                intent: TextFieldIntent,
                type: TextFieldViewType = .standard(),
                isReadOnly: Bool = false,
                leftView: @escaping () -> LeftView = { EmptyView() },
                rightView: @escaping () -> RightView = { EmptyView() }) {
        self.init(
            titleKey,
            text: text,
            theme: theme,
            intent: intent,
            borderStyle: .roundedRect,
            type: type,
            isReadOnly: isReadOnly,
            leftView: leftView,
            rightView: rightView
        )
    }

    // MARK: - View

    public var body: some View {
        TextFieldViewInternal(
            titleKey: self.titleKey,
            text: self.text,
            theme: self.theme,
            intent: self.intent,
            borderStyle: self.borderStyle,
            type: self.type,
            isReadOnly: self.isReadOnly,
            leftView: self.leftView,
            rightView: self.rightView
        )
        .isEnabled(self.isEnabled)
        .isFocused(self.isFocused)
        .focused(self.$isFocused)
    }
}
