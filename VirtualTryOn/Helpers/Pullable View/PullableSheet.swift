//
//  PullableSheet.swift
//  PullableSheet
//
//  Created by Tatsuya Tanaka on 20180723.
//  Copyright © 2018年 tattn. All rights reserved.
//

import UIKit

public enum State: Int {
    case open
    case partialOpen
}

protocol  PullableDelegate {
    func pullableViewScrollEnded()
}

open class PullableSheet: UIViewController {
    
    open var snapPoints: [SnapPoint] = [.min, .max] {
        didSet { snapPoints.sort() }
    }

    private var pullableMinY: CGFloat {
        return snapPoints.first?.y ?? SnapPoint.min.y
    }

    private var pullableMaxY: CGFloat {
        return snapPoints.last?.y ?? SnapPoint.max.y
    }

    private let topBarStyle: TopBarStyle
    public var state: State
    private var radius: CGFloat
    private var delegate: PullableDelegate!
    private var parentView: UIView?
    private let contentViewController: UIViewController?
    private weak var contentScrollView: UIScrollView?
    private var contentScrollViewPreviousOffset: CGFloat = 0

    init(content: UIViewController, topBarStyle: TopBarStyle = .default, state: State = .open, radius: CGFloat) {
        self.contentViewController = content
        self.topBarStyle = topBarStyle
        self.state = state
        self.radius = radius
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        contentViewController = nil
        topBarStyle = .default
        state = .open
        radius = 13
        super.init(coder: aDecoder)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        guard let view = parentView else { return }
        self.view.frame.size.height = view.frame.height - pullableMinY
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        close()
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func setupViews() {
        view.backgroundColor = .clear
        view.layer.cornerRadius = radius
        view.clipsToBounds = true

        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)

        let topBar = topBarStyle.view
        view.addSubview(topBar)
        topBar.center.x = view.center.x
        topBar.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]

        if let content = contentViewController {
            addContainerView(content)
            content.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                content.view.topAnchor.constraint(equalTo: view.topAnchor),
                content.view.leftAnchor.constraint(equalTo: view.leftAnchor),
                content.view.rightAnchor.constraint(equalTo: view.rightAnchor),
                content.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
//            if #available(iOS 11.0, *) {
//                content.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//            } else {
//                content.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//            }
        }

//        setupBluredView()
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let view = parentView else { return }
        self.view.frame.size.height = view.frame.height - pullableMinY + 35
    }

    open override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        close()
    }

    private func setupBluredView() {
        let blurEffect = UIBlurEffect(style: .light) // .dark
        let visualEffect = UIVisualEffectView(effect: blurEffect)
        let bluredView = UIVisualEffectView(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)

        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds

        view.insertSubview(bluredView, at: 0)
    }

    open func add(to viewController: UIViewController, view: UIView? = nil) {
        parentView = view ?? viewController.view
        delegate = viewController as! VirtualTryOnViewController
        viewController.addContainerView(self, view: view)
        self.view.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    }

    open func scroll(toY y: CGFloat, duration: Double = 0.6) {
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.allowUserInteraction], animations: {
            self.view.frame.origin.y = y
        }, completion: nil)
    }

    open func close() {
        scroll(toY: pullableMinY)
        state = .open
    }

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.contentScrollView = scrollView

        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
            state = .open
        } else if view.frame.minY > pullableMinY {
            scrollView.contentOffset.y = contentScrollViewPreviousOffset
            state = .partialOpen
        }
        contentScrollViewPreviousOffset = scrollView.contentOffset.y
    }

    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        defer { recognizer.setTranslation(.zero, in: self.view) }
        if let scrollView = self.contentScrollView {
            let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
            if velocity > 0 && scrollView.contentOffset.y > 0 {
                return
            }
        }
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        self.view.frame.origin.y = min(max(y + translation.y, self.pullableMinY), self.pullableMaxY)
        
        if recognizer.state == .ended, !self.snapPoints.isEmpty {
            let targetY = self.nearestPoint(of: y)
            let distance = abs(y - targetY)
            let duration = max(min(distance / velocity.y, distance / (UIScreen.main.bounds.height / 3)), 0.3)
            if(targetY < self.view.frame.height / 2) {
                self.state = .open
            } else {
                self.state = .partialOpen
            }
            DispatchQueue.main.async {
                self.delegate.pullableViewScrollEnded()
            }
            self.scroll(toY: targetY, duration: Double(duration))
        }
    }
}

extension PullableSheet: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
