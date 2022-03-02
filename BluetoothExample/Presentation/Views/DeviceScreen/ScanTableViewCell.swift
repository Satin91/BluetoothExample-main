//
//  ScanTableViewCell.swift
//  BluetoothExample
//
//  Created by Артур on 24.02.22.
//

import UIKit

class ScanTableViewCell: UITableViewCell {

    let label: UILabel = {
       let label = UILabel()
        label.textColor = .text
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabel()
    }
 
    
    override var isSelected: Bool {
        didSet {
            switch isSelected {
            case true :
                backgroundColor = .systemCyan
            case false:
                backgroundColor = .white
            }
        }
    }
    
    func setupLabel() {
        addSubview(label)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func layoutSubviews() {
        label.addConstraints(leftPadding: 15, to: self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
