//
//  List.swift
//  FontDownloader
//
//  Created by MH on 2024/01/15.
//

import UIKit

protocol ListSelectedDelegate: AnyObject {
    func selected(fontName: String)
}

protocol ListDownloadDelegate: AnyObject {
    func download(fontName: String)
}

fileprivate extension FontState {
    func description() -> String {
        switch self {
            case .undefined:
                return "-"//行の高さを確保するために設定する
            case .preparing:
                return NSLocalizedString("Preparing", comment: "")
            case .undownloaded:
                return NSLocalizedString("Undownloaded", comment: "")
            case .downloading(let value):
                return NSLocalizedString("Downloading", comment: "") + " \(value)%"
            case .downloaded:
                return NSLocalizedString("Downloaded", comment: "")
            case .unresponsive:
                return NSLocalizedString("Unresponsive", comment: "")
        }
    }
}

class List: UICollectionView {
    
    let cellId = "Cell"
    
    //このViewのセルの選択操作がされたことを伝える
    weak var selectedDelegate: ListSelectedDelegate?
    
    //このViewのセルのダウンロードボタンが押されたことを伝える
    weak var downloadDelegate: ListDownloadDelegate?
    
    var selectedFont: String = ""
    
    init() {
        
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.headerMode = .firstItemInSection 
        listConfiguration.backgroundColor = .clear
        let simpleLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
        super.init(frame: .zero, collectionViewLayout: simpleLayout)
        
        register(UICollectionViewListCell.self, forCellWithReuseIdentifier: cellId)
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension List: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        additionalFontNames.fonts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        additionalFontNames.fonts[section].fonts.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UICollectionViewListCell
        //cell.backgroundColor = .clear
        var accessories: [UICellAccessory] = []
        
        var cellConfiguration = cell.defaultContentConfiguration()
        
        if indexPath.row == 0 {
            let formerName = additionalFontNames.fonts[indexPath.section].formerName
            cellConfiguration.text = NSLocalizedString(formerName, comment: "")
            cellConfiguration.secondaryText = ""
        } else {
            let index = indexPath.row - 1
            let latterName = additionalFontNames.fonts[indexPath.section].fonts[index].latterName
            let fullName = additionalFontNames.fonts[indexPath.section].fonts[index].fullName
            let fontState = FontStateStore.state(of: fullName)
            
            cellConfiguration.text = NSLocalizedString(latterName, comment: "")
            
            cellConfiguration.secondaryText = fontState?.description()
            
            if fontState == .undownloaded {
                let button = UICellAccessory.CustomViewConfiguration(
                    customView: 
                        {
                            let b = UIButton(type: .system)
                            b.setTitle(NSLocalizedString("Download", comment: ""), for: .normal)
                            b.addAction(
                                UIAction { [weak self] _ in
                                    self?.downloadDelegate?.download(fontName: fullName)
                                },
                                for: .touchUpInside
                            )
                            return b
                        }(),
                    placement: .trailing(displayed: .always))
                accessories.append(.customView(configuration: button))
            }
            
            if fullName == selectedFont {
                accessories.append(.checkmark())
            }
        }
        cell.contentConfiguration = cellConfiguration
        cell.accessories = accessories
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row != 0 {
            let fullName = additionalFontNames.fonts[indexPath.section].fonts[indexPath.row - 1].fullName
            if FontStateStore.state(of: fullName) == .downloaded {
                selectedDelegate?.selected(fontName: fullName)
            }
        }
        
        //選択状態は意味を持たないので解除する
        deselectItem(at: indexPath, animated: true)
    }
}

