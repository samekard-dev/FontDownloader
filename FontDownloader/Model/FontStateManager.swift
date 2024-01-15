//
//  FontStateManager.swift
//  FontDownloader
//
//  Created by MH on 2024/01/15.
//

import Foundation

struct AdditionalFontNames {
    let fonts: [(formerName: String, fonts: [(latterName: String, fullName: String)])]
    
    //同じ会社のフォントはまとめてダウンロードされることがある仕様なので、ダウンロード完了時に他のものもチェックするためのグループ
    let bunches: [[String]]
}

enum FontState: Equatable {
    case undefined
    case preparing
    case undownloaded
    case downloading(Int)
    case downloaded
    case unresponsive
}

class FontStateStore {
    
    private static var fontStates: [String : FontState] = [:]
    
    static func state(of fontName: String) -> FontState? {
        return fontStates[fontName]
    }
    
    fileprivate static func write(state: FontState, in fontName: String) {
        fontStates[fontName] = state
    }
}

protocol FontStateManagerDelegate: AnyObject {
    //FontStateManagerからAに情報を伝えるときにAが実装するもの
    func stateHasChanged()
    func didFailWithError(fontName: String, command: FontDownloaderCommand, error: NSError)
}

class FontStateManager {
    
    private let fontDownloader: FontDownloader
    private let additionalFontNames: AdditionalFontNames
    
    weak var delegate: FontStateManagerDelegate?
    
    init(delegate: FontStateManagerDelegate, afn: AdditionalFontNames) {
        self.additionalFontNames = afn
        self.delegate = delegate
        fontDownloader = FontDownloader()
        fontDownloader.delegate = self
    }
    
    func checkAllFonts() {
        for family in additionalFontNames.fonts {
            for font in family.fonts {
                fontDownloader.process(fontName: font.fullName, command: .check)
            }
        }
    }
    
    func download(fontName: String) {
        fontDownloader.process(fontName: fontName, command: .download)
    }
}

extension FontStateManager: FontDownloaderDelegate {
    
    func didBegin(fontName: String, command: FontDownloaderCommand) {
        switch command {
            case .check:
                FontStateStore.write(state: .undefined, in: fontName)
            case .download:
                FontStateStore.write(state: .preparing, in: fontName)
        }
        delegate?.stateHasChanged()
    }
    
    func willBeginDownloading(fontName: String, command: FontDownloaderCommand) {
        switch command {
            case .check:
                FontStateStore.write(state: .undownloaded, in: fontName)
            case .download:
                FontStateStore.write(state: .downloading(0), in: fontName)
        }
        delegate?.stateHasChanged()
    }
    
    func downloading(fontName: String, progress: Int) {
        FontStateStore.write(state: .downloading(progress), in: fontName)
        delegate?.stateHasChanged()
    }
    
    func didMatch(fontName: String, command: FontDownloaderCommand) {
        FontStateStore.write(state: .downloaded, in: fontName)
        
        if command == .download {
            //フォントによっては複数のフォントをまとめてダウンロードする仕様
            for bunch in additionalFontNames.bunches where bunch.contains(fontName) {
                for f2 in bunch where FontStateStore.state(of: f2) != .downloaded{
                    fontDownloader.process(fontName: f2, command: .check)
                }
            }
        }
        
        delegate?.stateHasChanged()
    }
    
    func didFinish(fontName: String, command: FontDownloaderCommand) {
        switch command {
            case .check:
                if FontStateStore.state(of: fontName) == .undefined {
                    //Appleがこのフォントの配布をやめたときなど
                    FontStateStore.write(state: .unresponsive, in: fontName)
                    delegate?.stateHasChanged()
                }
            case .download:
                break
        }
    }
    
    func didFailWithError(fontName: String, command: FontDownloaderCommand, error: NSError) {
        switch command {
            case .check:
                FontStateStore.write(state: .undefined, in: fontName)
            case .download:
                FontStateStore.write(state: .undownloaded, in: fontName)
        }
        delegate?.stateHasChanged()
        delegate?.didFailWithError(fontName: fontName, command: command, error: error)
    }
}

