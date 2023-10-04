//
//  InfoTableViewCell.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 02.10.2023.
//

import SnapKit
import UIKit

final class InfoTableViewCell: UITableViewCell {
    //MARK: Properties
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.SFUITextMedium(ofSize: 18)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .white
        return descriptionLabel
    }()
    //MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    //MARK: Methods
    private func setupConstraints() {
        contentView.backgroundColor = .black
        // title
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView).inset(10)
        }
        // description
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.bottom.equalTo(contentView).offset(-10)
        }
    }
    // configure
    func configure(title: String, description: String, textColor: UIColor) {
        titleLabel.text = title
        descriptionLabel.text = description
        titleLabel.textColor = textColor
    }
} // end
