//
//  ForecastTableViewCell.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 08.10.2023.
//

import Foundation
import UIKit
import SnapKit

final class ForecastTableViewCell: UITableViewCell {
    let timeLabel = UILabel()
    let todayValueLabel = UILabel()
    let tomorrowValueLabel = UILabel()
    let afterdayValueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        changeFontSize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func changeFontSize() {
        timeLabel.font = UIFont.SFUITextMedium(ofSize: 16)
        todayValueLabel.font = UIFont.SFUITextMedium(ofSize: 16)
        tomorrowValueLabel.font = UIFont.SFUITextMedium(ofSize: 16)
        afterdayValueLabel.font = UIFont.SFUITextMedium(ofSize: 16)
        
        timeLabel.textColor = UIColor.systemBlue
        todayValueLabel.textColor = UIColor.white
        tomorrowValueLabel.textColor = UIColor.white
        afterdayValueLabel.textColor = UIColor.white
    }

    private func setupConstraints() {
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(10)
            make.top.equalTo(contentView).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
        contentView.addSubview(todayValueLabel)
        todayValueLabel.snp.makeConstraints { make in
            make.left.equalTo(timeLabel.snp.right).offset(10)
            make.top.equalTo(contentView).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        contentView.addSubview(tomorrowValueLabel)
        tomorrowValueLabel.snp.makeConstraints { make in
            make.left.equalTo(todayValueLabel.snp.right).offset(10)
            make.top.equalTo(contentView).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        contentView.addSubview(afterdayValueLabel)
        afterdayValueLabel.snp.makeConstraints { make in
            make.left.equalTo(tomorrowValueLabel.snp.right).offset(10)
            make.top.equalTo(contentView).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
    }

}
