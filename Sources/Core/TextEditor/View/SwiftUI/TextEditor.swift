//
//  TextEditor.swift
//  SparkEditor
//
//  Created by alican.aycil on 20.06.24.
//  Copyright © 2024 Adevinta. All rights reserved.
//

import SwiftUI
import SparkTheming

//enum Field: Hashable {
//        case text
//}
//
//public struct TextEditor: View {
//
//    // MARK: - Properties
//
//    private var defaultTexEditorTopPadding: CGFloat = 8
//    private var defaultTexEditorBottomPadding: CGFloat = 9
//    private var defaultTexEditorHorizontalPadding: CGFloat = 5
//    @ScaledMetric private var scaleFactor: CGFloat = 1.0
//
//    @ObservedObject private var viewModel: TextInputViewModel
//
//    @Binding private var text: String
//    private let title: String
//    @FocusState private var focusedField: Field?
//    @Environment(\.isEnabled) private var isEnabled
//    @State private var textViewEnabled: Bool = true
//
//    private var isPlaceholderTextHidden: Bool {
//        return !self.title.isEmpty && self.text.isEmpty
//    }
//
//    private var isPlaceholderHidden: Bool {
//        if #available(iOS 16.0, *) {
//            return self.isPlaceholderTextHidden || self.viewModel.isEditable
//        } else {
//            return self.isPlaceholderTextHidden || self.viewModel.isEditable || !self.isEnabled
//        }
//    }
//
//    // MARK: - Initialization
//
//    public init(
//        _ title: String,
//        text: Binding<String>,
//        theme: Theme,
//        intent: TextEditorIntent = .neutral
//    ) {
//        let viewModel = TextInputViewModel(
//            theme: theme,
//            intent: intent
//        )
//        self.title = title
//        self._text = text
//        self.viewModel = viewModel
//    }
//
//    // MARK: - View
//
//    public var body: some View {
//        ZStack(alignment: .leading) {
//            self.viewModel.backgroundColor.color
//
//            if #available(iOS 16.0, *) {
//                self.placeHolderView()
//                    .scrollIndicators(.never)
//                self.textViewView()
//                    .scrollContentBackground(.hidden)
//                    .scrollIndicators(.never)
//            } else {
//                self.placeHolderView()
//                self.textViewView()
//            }
//        }
//        .border(
//            width: self.viewModel.borderWidth * self.scaleFactor,
//            radius: self.viewModel.borderRadius * self.scaleFactor,
//            colorToken: self.viewModel.borderColor
//        )
//        .tint(self.viewModel.textColor.color)
//        .allowsHitTesting(self.viewModel.isEnabled)
//        .focused(self.$focusedField, equals: .text)
//        .onChange(of: self.focusedField) { focusedField in
//            self.viewModel.isFocused = focusedField == .text
//        }
//        .isEnabled(self.isEnabled) { isEnabled in
//            self.viewModel.isEnabled = isEnabled
//        }
//        .onChange(of: self.viewModel.isEnabled) { isEnabled in
//            if !isEnabled {
//                self.focusedField = nil
//            }
//            self.textViewEnabled = isEnabled
//        }
//        .onChange(of: self.viewModel.isEditable) { isEditable in
//            if isEditable {
//                self.focusedField = nil
//            }
//        }
//        .onTapGesture {
//            if !self.viewModel.isEditable {
//                self.focusedField = .text
//            }
//        }
//        .accessibilityElement()
//        .accessibilityIdentifier(TextEditorAccessibilityIdentifier.view)
//        .accessibilityLabel(self.title)
//        .accessibilityValue(self.text)
//    }
//
//    // MARK: - ViewBuilder
//
//    @ViewBuilder
//    private func textViewView() -> some View {
//        TextEditor(text: $text)
//            .font(self.viewModel.font.font)
//            .foregroundStyle(self.viewModel.textColor.color)
//            .padding(
//                EdgeInsets(
//                    top: .zero + self.scaleFactor,
//                    leading: (self.viewModel.leftSpacing * self.scaleFactor - self.defaultTexEditorHorizontalPadding),
//                    bottom: .zero + self.scaleFactor,
//                    trailing: (self.viewModel.rightSpacing * self.scaleFactor - self.defaultTexEditorHorizontalPadding)
//                )
//            )
//            .opacity(!self.isPlaceholderHidden || self.viewModel.isFocused ? 1 : 0)
//            .accessibilityHidden(true)
//            .environment(\.isEnabled, self.textViewEnabled)
//    }
//
//    @ViewBuilder
//    private func placeHolderView() -> some View {
//        ScrollView {
//            HStack(spacing: 0) {
//                VStack(spacing: 0) {
//                    Text(self.isPlaceholderTextHidden ? self.title : self.$text.wrappedValue)
//                        .textSelected(self.viewModel.isEditable)
//                        .font(self.viewModel.font.font)
//                        .foregroundStyle(self.isPlaceholderTextHidden ? self.viewModel.placeholderColor.color : self.viewModel.textColor.color)
//
//                        .padding(
//                            EdgeInsets(
//                                top: self.defaultTexEditorTopPadding + self.scaleFactor,
//                                leading: self.viewModel.leftSpacing * self.scaleFactor,
//                                bottom: self.defaultTexEditorBottomPadding + self.scaleFactor,
//                                trailing: self.viewModel.rightSpacing * self.scaleFactor
//                            )
//                        )
//                        .opacity(self.isPlaceholderHidden ? 1 : 0)
//                        .accessibilityHidden(true)
//
//                    Spacer(minLength: 0)
//                }
//                Spacer(minLength: 0)
//            }
//        }
//    }
//
//    // MARK: - Modifier
//
//    public func isEditable(_ value: Bool) -> some View {
//        self.viewModel.isEditable = value
//        return self
//    }
//}
//
//// MARK: - Extension
//
//private extension View {
//
//    func isEnabled(_ value: Bool, complition: @escaping (Bool) -> Void) -> some View {
//        DispatchQueue.main.async {
//            complition(value)
//        }
//        return self.disabled(!value)
//    }
//
//    @ViewBuilder
//    func textSelected(_ isEnabled: Bool) -> some View {
//        if isEnabled {
//            self.textSelection(.enabled)
//        } else {
//            self.textSelection(.disabled)
//        }
//    }
//}
