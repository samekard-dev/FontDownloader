//
//  ViewController.swift
//  FontDownloader
//
//  Created by MH on 2024/01/15.
//

import UIKit

class ViewController: UIViewController {
    
    var fontStateManager: FontStateManager!
    
    var preview = Preview()
    var list = List()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fontStateManager = FontStateManager(delegate: self, afn: additionalFontNames)
        
        list.selectedDelegate = self
        list.downloadDelegate = self
        
        view.addSubview(preview)
        view.addSubview(list)
        
        layout()
        
        setup()
    }
    
    func layout() {
        preview.translatesAutoresizingMaskIntoConstraints = false
        preview.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).isActive = true
        preview.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).isActive = true
        preview.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor, constant: 10.0).isActive = true
        
        list.translatesAutoresizingMaskIntoConstraints = false
        list.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        list.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        list.topAnchor.constraint(equalTo: preview.bottomAnchor, constant: 10.0).isActive = true
        list.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        list.heightAnchor.constraint(equalTo: preview.heightAnchor, multiplier: 3.0).isActive = true
    }
    
    func setup() {
        fontStateManager.checkAllFonts()
    }
}

extension ViewController: ListSelectedDelegate {
    func selected(fontName: String) {
        list.selectedFont = fontName
        list.reloadData()
        preview.changeFont(name: fontName)
    }
}

extension ViewController: ListDownloadDelegate {
    func download(fontName: String) {
        fontStateManager.download(fontName: fontName)
    }
}

extension ViewController: FontStateManagerDelegate {
    func stateHasChanged() {
        DispatchQueue.main.async {
            self.list.reloadData()
        }
    }
    
    func didFailWithError(fontName: String, command: FontDownloaderCommand, error: NSError) {
        
        /*
         Errorの例
         Domain=com.apple.CoreText.CTFontManagerErrorDomain 
         Code=302 "フォントをダウンロードできませんでした。" 
         UserInfo={
         NSLocalizedDescription=フォントをダウンロードできませんでした。, 
         NSLocalizedFailureReason=Wi-Fi接続を確認して、あとでやり直してください。
         }
         print(error.domain)
         print(error.code)
         print(error.userInfo) 
         print(error.localizedDescription)
         print(error.localizedFailureReason as Any)
         */
        
        DispatchQueue.main.async {
            var message = ""
            if let reason = error.localizedFailureReason {
                message = reason + "\n\n"
            }
            message += NSLocalizedString("FontName", comment: "") + NSLocalizedString(fontName, comment: "")
            
            let alert = UIAlertController(title: error.localizedDescription, message: message, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

