//
//  LoaderManager.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//


import UIKit
import NVActivityIndicatorView

class LoaderManager {
    // MARK: - Propertys

    private let indicator: NVActivityIndicatorView
    private let backgroundView: UIView
    private let overlayView: UIView

    var shouldShowOverlay: Bool = false
    
    // MARK: - Singleton
    static let shared = LoaderManager()
    
    private init() {
        self.backgroundView = UIView(frame: .init(x: 0, y: 0, width: 80, height: 80))
        self.indicator = NVActivityIndicatorView(frame: .init(x: 0, y: 0, width: 48, height: 48))
        self.overlayView = UIView(frame: UIScreen.main.bounds)
        setupBackgroundView()
        setupIndicator()
        setupOverlayView()
    }
    
    func startLoading() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }

        for subview in window.subviews {
            if let _ = subview as? NVActivityIndicatorView {
                subview.removeFromSuperview()
            } else if subview == backgroundView {
                subview.removeFromSuperview()
            }
        }

        if shouldShowOverlay {
            window.addSubview(overlayView)
        }

        window.addSubview(backgroundView)
        backgroundView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)

        backgroundView.addSubview(indicator)
        indicator.center = CGPoint(x: backgroundView.bounds.midX, y: backgroundView.bounds.midY)

        indicator.startAnimating()
    }

    
    func stopLoading() {
        DispatchQueue.main.async {
            self.overlayView.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
            self.indicator.stopAnimating()
        }
    }
}

// MARK: - Setup
private extension LoaderManager {
    func setupIndicator() {
        indicator.type = .circleStrokeSpin
        indicator.color = .red
    }
    
    func setupBackgroundView() {
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 12
        backgroundView.layer.masksToBounds = true
    }
    
    func setupOverlayView() {
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        overlayView.isUserInteractionEnabled = true
    }
}
