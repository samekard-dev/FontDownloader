//
//  FontDownloader.swift
//  FontDownloader
//
//  Created by MH on 2024/01/15.
//

import UIKit

enum FontDownloaderCommand {
    case check
    case download
}

protocol FontDownloaderDelegate: AnyObject {
    //FontDownloaderからAに情報を伝えるときにAが実装するもの
    func didBegin(fontName: String, command: FontDownloaderCommand)
    func willBeginDownloading(fontName: String, command: FontDownloaderCommand)
    func downloading(fontName: String, progress: Int)
    func didMatch(fontName: String, command: FontDownloaderCommand)
    func didFinish(fontName: String, command: FontDownloaderCommand)
    func didFailWithError(fontName: String, command: FontDownloaderCommand, error: NSError)
}

class FontDownloader {
    
    weak var delegate: FontDownloaderDelegate?
    
    func process(fontName: String, command: FontDownloaderCommand) {
        
        let desc: CTFontDescriptor = CTFontDescriptorCreateWithAttributes([kCTFontNameAttribute : fontName] as CFDictionary)
        
        let descArray: CFArray = [desc] as CFArray
        
        CTFontDescriptorMatchFontDescriptorsWithProgressHandler(descArray, nil) { [weak self] state, progressParameter in
            
            let para = progressParameter as Dictionary
            let progressValue = para[kCTFontDescriptorMatchingPercentage]
            
            switch state {
                    
                case .didBegin:
                    //0 called once at the beginning.
                    self?.delegate?.didBegin(fontName: fontName, command: command)
                    
                case .willBeginQuerying:
                    //2 called once before talking to the server.  Skipped if not necessary.
                    break
                    
                case .willBeginDownloading: 
                    //4 Downloading part may be skipped if all the assets are already downloaded
                    self?.delegate?.willBeginDownloading(fontName: fontName, command: command)
                    switch command {
                        case  .check:
                            return false
                        case .download:
                            return true
                    }
                    
                case .stalled:
                    //3 called when stalled. (e.g. while waiting for server response.)
                    break
                    
                case .downloading:
                    //5
                    var pv3 = 0
                    if let pv2 = progressValue as? NSNumber  {
                        pv3 = Int(truncating: pv2)
                    }
                    self?.delegate?.downloading(fontName: fontName, progress: pv3)
                    
                case .didFinishDownloading:
                    //6
                    break
                    
                case .didMatch:
                    //7 called when font descriptor is matched.
                    self?.delegate?.didMatch(fontName: fontName, command: command)
                    
                case .didFinish:
                    //1 called once at the end.
                    self?.delegate?.didFinish(fontName: fontName, command: command)
                    
                case .didFailWithError:
                    //8 called when an error occurred.  (may be called multiple times.)
                    if let error = para[kCTFontDescriptorMatchingError] as? NSError {
                        self?.delegate?.didFailWithError(fontName: fontName, command: command, error: error)
                    }
                    return false //trueを返すとずっとやり続ける
                    
                default:
                    break
            }
            return true
        }
    }
}

/*
 【ある】
 買ったときからある
 071
 
 追加ダウンロードしてすでにある
 0671
 
 【ない】
 ダウンロードはキャンセルするとき
 0461
 ダウンロード完了の6は発行する。
 
 ダウンロードを実行するとき
 0435353535(35の繰り返し)671
 
 【失敗】
 間違ったフォントなど
 01
 */
