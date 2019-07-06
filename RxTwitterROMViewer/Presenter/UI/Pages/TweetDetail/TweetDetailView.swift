//
//  TweetDetailView.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/26.
//  Copyright © 2019 murawaki. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

import PinLayout

extension Reactive where Base: TweetDetailView {
    // Binder
    var tweet: Binder<TweetEntity> {
        return Binder(self.base) { view, tweet in
            self.base.iconImageView.kf.setImage(with: tweet.user.profileImageURL)
            self.base.userNameLabel.text = tweet.user.name
            self.base.createdDateLabel.text = "1時間前" // tweet.createdAt.description
            self.base.contentLabel.text = tweet.text
            if let media = tweet.medias().first {
                self.base.mediaAspectRatio = CGFloat(media.aspectRatio)
                self.base.mediaImageView.kf.setImage(with: media.mediaUrl(size: .medium))
                self.base.mediaImageView.isHidden = false
            } else {
                self.base.mediaImageView.isHidden = true
            }
        }
    }
}

final class TweetDetailView: UIView {
    
    private enum Const {
        static let contentMargin = CGFloat(20)
        static let iconSize = CGSize(width: 50, height: 50)
        static let iconCornerRadius = CGFloat(10)
        static let userNameFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let dateFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        static let contentFont = UIFont.systemFont(ofSize: 18, weight: .light)
    }
    
    fileprivate let iconImageView = UIImageView()
    fileprivate let userNameLabel = UILabel()
    fileprivate let createdDateLabel = UILabel()
    fileprivate let contentLabel = UILabel()
    fileprivate let mediaImageView = UIImageView()
    
    fileprivate var mediaAspectRatio: CGFloat = 1.0
    
    init() {
        super.init(frame: .zero)
        
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = Const.iconCornerRadius
        
        userNameLabel.font = Const.userNameFont
        
        createdDateLabel.font = Const.dateFont
        createdDateLabel.textColor = Color.starDust
        
        contentLabel.font = Const.contentFont
        contentLabel.numberOfLines = 0
        
        mediaImageView.backgroundColor = Color.blakcHaze
        mediaImageView.layer.masksToBounds = true
        mediaImageView.layer.cornerRadius = 8
        
        backgroundColor = .white
        addSubview(iconImageView)
        addSubview(userNameLabel)
        addSubview(createdDateLabel)
        addSubview(contentLabel)
        addSubview(mediaImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.pin
            .topLeft(Const.contentMargin)
            .size(Const.iconSize)
        
        userNameLabel.pin
            .after(of: iconImageView, aligned: .center).marginHorizontal(Const.contentMargin/2)
            .sizeToFit()
        
        createdDateLabel.pin
            .vCenter(to: userNameLabel.edge.vCenter)
            .sizeToFit()
            .right(Const.contentMargin)
        
        contentLabel.pin
            .below(of: iconImageView).marginTop(Const.contentMargin/2)
            .left().right().marginHorizontal(Const.contentMargin)
            .sizeToFit(.width)
        
        mediaImageView.pin
            .top(to: contentLabel.edge.bottom).marginTop(Const.contentMargin/2)
            .left().right().marginHorizontal(Const.contentMargin)
            .aspectRatio(mediaAspectRatio)
    }
}
