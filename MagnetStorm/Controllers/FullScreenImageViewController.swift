//
//  FullScreenImageViewController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 11.10.2023.
//

import Foundation
import UIKit
import SnapKit

final class FullScreenImageViewController: UIViewController {
    private let subtractImageView = UIImageView(image: UIImage(named: "subtract"))
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.7)
        return view
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.bounces = true
        scrollView.bouncesZoom = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    //MARK: Lifecycle
    init(image: UIImage?) {
        super.init(nibName: nil, bundle: nil)
        self.imageView.image = image
        setupConstraint()
    }
    private func setupConstraint() {
        // gray background
        view.addSubview(backgroundView)
        backgroundView.layer.zPosition = 100 // z-index
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(50)
        }
        // subtract
        backgroundView.addSubview(subtractImageView)
        subtractImageView.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundView)
            make.top.equalTo(backgroundView.snp.top).offset(-24)
        }
        view.backgroundColor = .black
        
        // Add the scrollView to the view
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.contentMode = .scaleAspectFit

        // Add the imageView to the scrollView
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1)
            make.height.equalToSuperview().multipliedBy(1)
        }
        // Set the delegate of the scrollView
        scrollView.delegate = self
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension FullScreenImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
