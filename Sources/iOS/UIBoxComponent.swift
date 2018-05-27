//
//  UIBoxComponent.swift
//  TinyComponent
//
//  Created by Roy Hsu on 2018/4/8.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - UIBoxComponent

import UIKit

/// The box component provides a convenient way to wrap a component as the content with the custom padding insets.
/// Note: The box component will override the content mode of the content component.
public final class UIBoxComponent: Component {

    internal final let containerView: UIView

    internal final var contentView: UIView { return contentComponent.view }

    internal final let contentComponent: Component

    private final let contentViewTopConstraint: NSLayoutConstraint

    private final let contentViewLeadingConstraint: NSLayoutConstraint

    private final let contentViewBottomConstraint: NSLayoutConstraint

    private final let contentViewTrailingConstraint: NSLayoutConstraint

    public final var paddingInsets: UIEdgeInsets

    /// - Parameters:
    ///   - contentMode: The default mode is .automatic with zero value of estimated size. This will prevent the list rendering with empty content. Please make sure to give a non-zero size for the list to properly render its content.
    ///   - contentComponent: The content component to wrap with.
    public init(
        contentMode: ComponentContentMode = .automatic(estimatedSize: .zero),
        contentComponent: Component
    ) {

        self.contentMode = contentMode

        self.containerView = UIView()

        self.contentComponent = contentComponent

        let contentView = contentComponent.view

        self.contentViewTopConstraint = containerView.topAnchor.constraint(equalTo: contentView.topAnchor)

        self.contentViewLeadingConstraint = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)

        self.contentViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

        self.contentViewTrailingConstraint = containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)

        self.paddingInsets = UIEdgeInsets(
            top: contentViewTopConstraint.constant,
            left: contentViewLeadingConstraint.constant,
            bottom: contentViewBottomConstraint.constant,
            right: contentViewTrailingConstraint.constant
        )

        self.prepare()

    }

    // MARK: Set Up

    fileprivate final func prepare() {

        prepareLayout()

        containerView.backgroundColor = contentView.backgroundColor

    }

    fileprivate final func prepareLayout() {

        contentViewBottomConstraint.priority = UILayoutPriority(900.0)

        contentViewTrailingConstraint.priority = UILayoutPriority(900.0)

    }

    // MARK: Component

    public final var contentMode: ComponentContentMode

    public final func render() {

        renderLayout()

        containerView.backgroundColor = contentView.backgroundColor

    }

    fileprivate final func renderLayout() {

        NSLayoutConstraint.deactivate(
            [
                contentViewTopConstraint,
                contentViewLeadingConstraint,
                contentViewBottomConstraint,
                contentViewTrailingConstraint
            ]
        )

        contentView.removeFromSuperview()

        let initialSize: CGSize

        switch contentMode {

        case let .fixed(size): initialSize = size

        case let .automatic(estimatedSize): initialSize = estimatedSize

        }

        contentComponent.contentMode = .automatic(
            estimatedSize: CGSize(
                width: initialSize.width - paddingInsets.left - paddingInsets.right,
                height: initialSize.height - paddingInsets.top - paddingInsets.bottom
            )
        )

        contentComponent.render()

        contentView.frame.origin = CGPoint(
            x: paddingInsets.left,
            y: paddingInsets.top
        )

        containerView.frame.size = CGSize(
            width: contentComponent.preferredContentSize.width + paddingInsets.left + paddingInsets.right,
            height: contentComponent.preferredContentSize.height + paddingInsets.top + paddingInsets.bottom
        )

        contentView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(contentView)

        contentViewTopConstraint.constant = -paddingInsets.top

        contentViewLeadingConstraint.constant = -paddingInsets.left

        contentViewBottomConstraint.constant = paddingInsets.bottom

        contentViewTrailingConstraint.constant = paddingInsets.right

        NSLayoutConstraint.activate(
            [
                contentViewTopConstraint,
                contentViewLeadingConstraint,
                contentViewBottomConstraint,
                contentViewTrailingConstraint
            ]
        )

    }

    // MARK: ViewRenderable

    public final var view: View { return containerView }

    public final var preferredContentSize: CGSize { return view.bounds.size }

}
