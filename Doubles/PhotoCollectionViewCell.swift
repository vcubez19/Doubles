//
//  CustomCell.swift
//  PracticePicker
//
//  Created by Vincent Cubit on 11/22/21.
//


import UIKit


class CustomCell: UICollectionViewCell {
    
    
    static let id = "CustomCell"
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.clipsToBounds = true
//        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.imageView)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.contentView.bounds
    }
    
    
    public func configure(image: UIImage) {
        self.imageView.image = image
    }
    
    
}

