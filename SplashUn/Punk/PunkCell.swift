//
//  PunkCell.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/21.
//

import UIKit
import SnapKit
class PunkCell: UICollectionViewCell{
    let imageView = UIImageView()
    let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    let descriptionLabel = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 21, weight: .medium)
        textView.showsVerticalScrollIndicator = false
        textView.backgroundColor = .clear
        return textView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierachy()
        configureLayout()
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("Should not access to storyboard")
    }
    func configureHierachy(){
        [imageView,titleLabel,descriptionLabel].forEach { contentView.addSubview($0) }
    }
    func configureLayout(){
        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(imageView.snp.width)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        descriptionLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    func configureView(){
        descriptionLabel.text = "Hello world"
        titleLabel.text = "Wow World"
        imageView.image = UIImage(systemName: "heart" )
        imageView.contentMode = .scaleAspectFit
        
    }
}
