//
//  TweetCell.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/23.
//  Copyright © 2019 murawaki. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import ReactorKit

import Kingfisher
import PinLayout

final class TweetCell: UITableViewCell, ReactorKit.View {
    
    private enum Const {
        static let contentPadding = CGFloat(10)
        static let iconSize = CGSize(width: 30, height: 30)
        static let iconRadius = 6
    }
    
    var disposeBag = DisposeBag()
    
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let contentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = 6
        
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        contentLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        contentLabel.numberOfLines = 0
        
        separatorInset = .zero
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bind(reactor: TweetCellReactor) {
        // State
        reactor.state.map { $0.tweet }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (tweet) in
                self?.iconImageView.kf.setImage(with: tweet.user.profileImageURL)
                self?.nameLabel.text = tweet.user.name
                self?.contentLabel.text = tweet.text
            })
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func layout() {
        iconImageView.pin
            .topLeft(Const.contentPadding)
            .size(Const.iconSize)
        
        nameLabel.pin
            .after(of: iconImageView, aligned: .center)
            .right()
            .marginHorizontal(Const.contentPadding)
            .sizeToFit(.width)
        
        contentLabel.pin
            .below(of: iconImageView).marginTop(Const.contentPadding/2)
            .left().right().marginHorizontal(Const.contentPadding)
            .sizeToFit(.width)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        
//        setNeedsLayout()
        layoutIfNeeded()
        
        return CGSize(
            width: contentView.frame.width,
            height: contentLabel.frame.maxY + Const.contentPadding
        )
    }
}
