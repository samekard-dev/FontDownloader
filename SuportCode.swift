

// MARK: - 開発用

//以下の処理を走らせるとインストールされているフォントがわかる
func printInstalledFonts() {
    for family in UIFont.familyNames {
        print("\(family)")
        for fontName in UIFont.fontNames(forFamilyName: family) {
            print("    \(fontName)")
        }
    }
}

//以下の処理を走らせるとダウンロード対応のフォントがわかる
func printDownloadableFonts() {
    let attributes: [CFString : CFBoolean] = [kCTFontDownloadableAttribute : kCFBooleanTrue]
    let fontDescriptor = CTFontDescriptorCreateWithAttributes(attributes as CFDictionary)
    let matchedFontDescriptors = CTFontDescriptorCreateMatchingFontDescriptors(fontDescriptor, nil) as! [UIFontDescriptor]
    
    //出てくるデータは順番がばらばらなので整理してから表示するために保存用の辞書
    var results: [String : [(String, String, String)]] = [ : ]
    
    let targetLang = "ja"
    var targetFontFamilies: Set<String> = []
    
    for fontDescriptor in matchedFontDescriptors {
        
        let familyName = fontDescriptor.fontAttributes[.family] as? String ?? "undefined family name"
        
        let postscriptName = fontDescriptor.fontAttributes[.name] as? String ?? "undefined postscript name"
        
        let displayName = fontDescriptor.fontAttributes[.visibleName] as? String ?? "undefined visible name"
        
        let languages = fontDescriptor.fontAttributes[UIFontDescriptor.AttributeName(rawValue: "NSCTFontDesignLanguagesAttribute")] as? [String] ?? []
        
        let langsStr = languages.reduce("", { $0 + "\($1) "})
        
        if langsStr.contains(targetLang) {
            targetFontFamilies.insert("\(familyName)")
        }
        
        var fonts = results[familyName, default: []]
        fonts.append((postscriptName, displayName, langsStr))
        results[familyName] = fonts
    }
    
    for key in results.keys.sorted(by: <) {
        print(key)
        for font in results[key]! {
            print("   ", font.0 , font.1)
            print("   ", font.2)
        }
    }
    
    if targetFontFamilies.isEmpty == false {
        print("TargetFontFamilies (TargetLang=\(targetLang))" )
        print(targetFontFamilies.sorted())
    }
}

