//
//  InfoViewController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 09.09.2023.
//

import Foundation
import UIKit
import SnapKit

final class InfoViewController: UIViewController {
    private let scrollView: UIScrollView = {
        var view = UIScrollView()
        view.isScrollEnabled = true
        view.alwaysBounceVertical = true
        return view
    }()
    private let contentView = UIView()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
        titleLabel.text = "Описание каждой бури"
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupConstraints()
    }
    
    private func setupBackgroundView() {
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        view.addSubview(backgroundView)
    }
    
    private func setupConstraints() {
        // scroll view
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // content view
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView)
            make.top.bottom.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.bottom.equalTo(scrollView) // Добавьте это, чтобы растянуть contentView по вертикали
        }
        // добавляем заголовок
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.horizontalEdges.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
        }
    }
}
