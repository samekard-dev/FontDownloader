//
//  Preview.swift
//  FontDownloader
//
//  Created by MH on 2024/01/15.
//

import UIKit

class Preview: UIView {
    
    fileprivate var fontSize = 24.0
    
    let base = UIView()
    let main = UILabel()
    let fontNameLabel = UILabel()
    let stepper = UIStepper()
    
    init() {
        super.init(frame: .zero)
        
        main.text = 
                        """
                        あいうえお
                        カキクケコ
                        花鳥風月 温故知新
                        AaBbCcDdEeFfGg
                        """
        main.font = UIFont.systemFont(ofSize: fontSize)
        main.numberOfLines = 0
        
        base.backgroundColor = UIColor.secondarySystemBackground
        base.layer.cornerRadius = 10.0
        
        fontNameLabel.numberOfLines = 1
        fontNameLabel.lineBreakMode = .byTruncatingMiddle
        fontNameLabel.font = UIFont.systemFont(ofSize: 18.0)
        fontNameLabel.text = NSLocalizedString("SystemFont", comment: "")
        fontNameLabel.textColor = .secondaryLabel
        
        stepper.maximumValue = 42.0
        stepper.minimumValue = 18.0
        stepper.stepValue = 3.0
        stepper.value = fontSize
        stepper.addAction(
            UIAction { _ in
                self.fontSize = CGFloat(self.stepper.value)
                self.main.font = self.main.font.withSize(self.fontSize)
            },
            for: .valueChanged)
        
        addSubview(fontNameLabel)
        base.addSubview(main)
        base.addSubview(stepper)
        addSubview(base)
        
        fontNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fontNameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        fontNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        fontNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
        base.translatesAutoresizingMaskIntoConstraints = false
        base.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        base.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        base.topAnchor.constraint(equalTo: fontNameLabel.bottomAnchor, constant: 2).isActive = true
        base.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.topAnchor.constraint(equalTo: base.topAnchor, constant: 10).isActive = true
        stepper.trailingAnchor.constraint(equalTo: base.trailingAnchor, constant: -10).isActive = true
        
        main.translatesAutoresizingMaskIntoConstraints = false
        main.topAnchor.constraint(equalTo: base.topAnchor, constant: 16.0).isActive = true
        main.bottomAnchor.constraint(equalTo: base.bottomAnchor, constant: -16.0).isActive = true
        main.leadingAnchor.constraint(equalTo: base.leadingAnchor, constant: 20.0).isActive = true
        main.trailingAnchor.constraint(equalTo: base.trailingAnchor, constant: -20.0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeFont(name: String) {
        main.font = UIFont(name: name, size: fontSize)
        fontNameLabel.text = NSLocalizedString(name, comment: "")
    }
    
}

