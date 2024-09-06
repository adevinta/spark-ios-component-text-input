//
//  TextEditorUIView.swift
//  SparkEditor
//
//  Created by alican.aycil on 23.05.24.
//  Copyright © 2024 Adevinta. All rights reserved.
//

import UIKit
import Combine
import SparkTheming
@_spi(SI_SPI) import SparkCommon

// TODO: bug quand on change le dynamic type

/// Spark TextEditorUIView, subclasses UITextEditor
public final class TextEditorUIView: UITextView {

    // MARK: - Components

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        return label
    }()

    // MARK: - Public Properties

    /// The textview's current theme.
    public var theme: Theme {
        get {
            return self.viewModel.theme
        }
        set {
            self.viewModel.theme = newValue
        }
    }

    /// The textview's current intent.
    public var intent: TextEditorIntent {
        get {
            return self.viewModel.intent
        }
        set {
            self.viewModel.intent = newValue
        }
    }

    /// The textview's current placeholder.
    public var placeholder: String? {
        get {
            return self.placeholderLabel.text
        }
        set {
            self.placeholderLabel.text = newValue
            self.viewModel.contentChanged(with: self.text)
        }
    }

    // MARK: - Override Properties

    /// The textview's text.
    public override var text: String! {
        didSet {
            self.viewModel.contentChanged(with: self.text)
        }
    }

    /// The textview's attributedText.
    public override var attributedText: NSAttributedString! {
        didSet {
            self.viewModel.contentChanged(with: self.text)
        }
    }

    /// The textview's userInteractionEnabled.
    public override var isUserInteractionEnabled: Bool {
        didSet {
            self.viewModel.isEnabled = self.isUserInteractionEnabled
        }
    }

    /// The textview's isEditable.
    public override var isEditable: Bool {
        didSet {
            self.viewModel.isReadOnly = !self.isEditable
        }
    }

    // MARK: - Private Properties

    @ScaledUIMetric private var scaleFactor: CGFloat = 1.0

    private var placeholderVerticalPaddingConstraints: [NSLayoutConstraint] = []
    private var placeholderHorizontalPaddingsConstraints: [NSLayoutConstraint] = []

    private let viewModel: TextEditorViewModel

    private var cancellables = Set<AnyCancellable>()

    private let notificationNames = [
        UITextView.textDidChangeNotification,
        UITextView.textDidBeginEditingNotification,
        UITextView.textDidEndEditingNotification
    ]

    // MARK: - Initialization

    /// TextEditorUIView initializer
    /// - Parameters:
    ///   - theme: The textviews's current theme
    ///   - intent: The textviews's current intent
    public init(
        theme: Theme,
        intent: TextEditorIntent
    ) {
        self.viewModel = .init(theme: theme, intent: intent)

        super.init(
            frame: .zero,
            textContainer: nil
        )

        // Setup
        self.setupView()
    }

    deinit {
        self.unsetNotificationCenter()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        // Accessibility
        self.accessibilityIdentifier = TextEditorAccessibilityIdentifier.view

        // Properties
        self.adjustsFontForContentSizeCategory = true
        self.showsHorizontalScrollIndicator = false
        self.textContainer.lineFragmentPadding = 0

        // Subviews
        self.addSubview(self.placeholderLabel)

        // Setup Observer
        self.setupNotificationCenter()

        // Setup constraints
        self.setupConstraints()

        // Setup publisher subcriptions
        self.setupSubscriptions()
    }

    // MARK: - Constraints

    private func setupConstraints() {
        self.setupViewConstraints()
        self.setupPlaceholderConstraints()
    }

    /// Setup the size constraints for this view.
    private func setupViewConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.heightAnchor.constraint(greaterThanOrEqualToConstant: TextInputConstants.height).isActive = true
    }

    /// Setup the imageView constraints.
    private func setupPlaceholderConstraints() {
        self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        self.placeholderVerticalPaddingConstraints = [
            self.placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.placeholderLabel.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor)
        ]

        self.placeholderHorizontalPaddingsConstraints = [
            self.placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.placeholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]

        NSLayoutConstraint.activate(self.placeholderVerticalPaddingConstraints + self.placeholderHorizontalPaddingsConstraints)
    }

    // MARK: - Subscribe

    private func setupSubscriptions() {
        self.viewModel.$textColor.subscribe(in: &self.cancellables) { [weak self] textColor in
            guard let self else { return }
            self.textColor = textColor.uiColor
            self.tintColor = textColor.uiColor
        }

        self.viewModel.$backgroundColor.removeDuplicates(by: { lhs, rhs in
            lhs.equals(rhs)
        })
        .subscribe(in: &self.cancellables) { [weak self] backgroundColor in
            self?.backgroundColor = backgroundColor.uiColor
        }

        self.viewModel.$borderColor.removeDuplicates(by: { lhs, rhs in
            lhs.equals(rhs)
        })
        .subscribe(in: &self.cancellables) { [weak self] borderColor in
            self?.setBorderColor(from: borderColor)
        }

        self.viewModel.$placeholderColor.removeDuplicates(by: { lhs, rhs in
            lhs.equals(rhs)
        })
        .subscribe(in: &self.cancellables) { [weak self] placeholderColor in
            self?.placeholderLabel.textColor = placeholderColor.uiColor
        }

        self.viewModel.$borderWidth.removeDuplicates()
            .subscribe(in: &self.cancellables) { [weak self] borderWidth in
            guard let self else { return }
            self.setBorderWidth(borderWidth * self.scaleFactor)
        }

        self.viewModel.$borderRadius.removeDuplicates()
            .subscribe(in: &self.cancellables) { [weak self] borderRadius in
            guard let self else { return }
            self.setCornerRadius(borderRadius * self.scaleFactor)
        }

        self.viewModel.$leftSpacing.removeDuplicates()
            .subscribe(in: &self.cancellables) { [weak self] spacing in
                self?.updatePaddings()
            }

        self.viewModel.$rightSpacing.removeDuplicates()
            .subscribe(in: &self.cancellables) { [weak self] spacing in
                self?.updatePaddings()
            }

        self.viewModel.$dim.removeDuplicates().subscribe(in: &self.cancellables) { [weak self] dim in
            guard let self else { return }
            self.alpha = dim
        }

        self.viewModel.$font.subscribe(in: &self.cancellables) { [weak self] font in
                guard let self else { return }
                self.font = font.uiFont
                self.placeholderLabel.font = font.uiFont
            }

        self.viewModel.$isPlaceholder
            .removeDuplicates().subscribe(in: &self.cancellables) { [weak self] isPlaceholder in
                guard let self else { return }

                self.placeholderLabel.isHidden = !isPlaceholder
                self.accessibilityLabel = isPlaceholder ? self.placeholder : self.text
            }

        self.viewModel.$verticalSpacing
            .removeDuplicates().subscribe(in: &self.cancellables) { [weak self] isPlaceholder in
                self?.updatePaddings()
            }
    }

    // MARK: - Notification Center

    private func setupNotificationCenter() {
        for name in self.notificationNames {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(textViewFiredWithNotification(_:)),
                name: name,
                object: self
            )
        }
    }

    private func unsetNotificationCenter() {
        for name in self.notificationNames {
            NotificationCenter.default.removeObserver(
                self,
                name: name,
                object: self
            )
        }
    }

    // MARK: - Update

    private func updatePaddings() {
        // Placeholder
        for constraint in placeholderHorizontalPaddingsConstraints {
            constraint.constant = self.viewModel.leftSpacing // TODO: replace to horizontalSpacing
        }

        for constraint in placeholderVerticalPaddingConstraints {
            constraint.constant = self.viewModel.verticalSpacing
        }

        self.placeholderLabel.updateConstraintsIfNeeded()

        // Container
        // TODO: add scaleFactor ?
        self.textContainerInset = UIEdgeInsets(
            top: self.viewModel.verticalSpacing,
            left: self.viewModel.leftSpacing,
            bottom: self.viewModel.verticalSpacing,
            right: self.viewModel.rightSpacing
        )

        // TODO: check if needed
         self.setNeedsLayout()
    }

    // MARK: - Action

    @objc
    private func textViewFiredWithNotification(_ notification: Notification) {
        self.viewModel.contentChanged(with: self.text)
    }

    // MARK: - Responder

    public override func becomeFirstResponder() -> Bool {
        let bool = super.becomeFirstResponder()
        self.viewModel.isFocused = bool
        return bool
    }

    public override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        self.viewModel.isFocused = false
        return true
    }

    // MARK: - Trait Collection

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            self.setBorderColor(from: self.viewModel.borderColor)
        }

        guard previousTraitCollection?.preferredContentSizeCategory != self.traitCollection.preferredContentSizeCategory else { return }

        self._scaleFactor.update(traitCollection: self.traitCollection)
        self.setBorderWidth(self.viewModel.borderWidth * self.scaleFactor)
        self.updatePaddings()
    }

    // TODO: check the intrinsicContentSize
}
