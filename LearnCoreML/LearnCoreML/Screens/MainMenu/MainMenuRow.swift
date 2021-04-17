//
//  MainMenuRow.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 17.04.2021.
//

import UIKit

class MainMenuRow: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.embed(to: contentView, inset: UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 16))
        return label
    }()
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
