//
//  FontData.swift
//  FontDownloader
//
//  Created by MH on 2024/01/15.
//

/*
 デバイス内にもともとある iOS 16.5.1
 Hiragino Maru Gothic ProN
 - HiraMaruProN-W4
 Hiragino Mincho ProN
 - HiraMinProN-W3
 - HiraMinProN-W6
 Hiragino Sans
 - HiraginoSans-W3
 - HiraginoSans-W6
 - HiraginoSans-W7
 
 追加できる iOS 16.5.1
 "Hiragino Kaku Gothic Std", 
 "Hiragino Kaku Gothic StdN", 
 "Hiragino Sans", 
 "Klee", 
 "Osaka", 
 "Toppan Bunkyu Gothic", 
 "Toppan Bunkyu Midashi Gothic", 
 "Toppan Bunkyu Midashi Mincho", 
 "Toppan Bunkyu Mincho", 
 "Tsukushi A Round Gothic", 
 "Tsukushi B Round Gothic", 
 "YuGothic", 
 "YuKyokasho", 
 "YuKyokasho Yoko", 
 "YuMincho", 
 "YuMincho +36p Kana"
 */

let additionalFontNames = AdditionalFontNames (
    fonts: [
        
        ("HiraMaruProN", [
            ("W4", "HiraMaruProN-W4"),
            
        ]),
        
        ("HiraMinProN", [
            ("W3", "HiraMinProN-W3"),
            ("W6", "HiraMinProN-W6"),
        ]),   
        ("HiraginoSans", [
            ("W0", "HiraginoSans-W0"),
            ("W1", "HiraginoSans-W1"),
            ("W2", "HiraginoSans-W2"),
            ("W3", "HiraginoSans-W3"),
            ("W4", "HiraginoSans-W4"),
            ("W5", "HiraginoSans-W5"),
            ("W6", "HiraginoSans-W6"),
            ("W7", "HiraginoSans-W7"),
            ("W8", "HiraginoSans-W8"),
            ("W9", "HiraginoSans-W9"),
        ]),
        ("Osaka", [
            ("NoAttributeName", "Osaka"),
            ("Mono", "Osaka-Mono"),
        ]),
        ("Klee", [
            ("Medium", "Klee-Medium"),
            ("Demibold", "Klee-Demibold"),
        ]),
        ("ToppanBunkyuMidashiMinchoStdN", [
            ("ExtraBold", "ToppanBunkyuMidashiMinchoStdN-ExtraBold"),
        ]),
        ("ToppanBunkyuMidashiGothicStdN", [
            ("ExtraBold", "ToppanBunkyuMidashiGothicStdN-ExtraBold"),
        ]),
        ("ToppanBunkyuMinchoPr6N", [
            ("Regular", "ToppanBunkyuMinchoPr6N-Regular"),
        ]),
        ("ToppanBunkyuGothicPr6N", [
            ("Regular", "ToppanBunkyuGothicPr6N-Regular"),
            ("DB", "ToppanBunkyuGothicPr6N-DB"),
        ]),
        ("TsukuARdGothic", [
            ("Regular", "TsukuARdGothic-Regular"),
            ("Bold", "TsukuARdGothic-Bold"),
        ]),
        ("TsukuBRdGothic", [
            ("Regular", "TsukuBRdGothic-Regular"),
            ("Bold", "TsukuBRdGothic-Bold"),
        ]),
        ("YuGo", [
            ("Medium", "YuGo-Medium"),
            ("Bold", "YuGo-Bold"),
        ]),
        ("YuKyo", [
            ("Medium", "YuKyo-Medium"),
            ("Bold", "YuKyo-Bold"),
        ]),
        ("YuKyo_Yoko", [
            ("Medium", "YuKyo_Yoko-Medium"),
            ("Bold", "YuKyo_Yoko-Bold"),
        ]),
        ("YuMin", [
            ("Medium", "YuMin-Medium"),
            ("Demibold", "YuMin-Demibold"),
            ("Extrabold", "YuMin-Extrabold"),
        ]),
        ("YuMin_36pKn", [
            ("Medium", "YuMin_36pKn-Medium"),
            ("Demibold", "YuMin_36pKn-Demibold"),
            ("Extrabold", "YuMin_36pKn-Extrabold"),
        ]),
    ], 
    
    bunches: [
        ["Klee-Medium", "Klee-Demibold"],
        ["ToppanBunkyuGothicPr6N-Regular", "ToppanBunkyuGothicPr6N-DB"],
        ["TsukuARdGothic-Regular", "TsukuARdGothic-Bold"],
        ["TsukuBRdGothic-Regular", "TsukuBRdGothic-Bold"],
        ["YuKyo-Medium", "YuKyo-Bold", "YuKyo_Yoko-Medium", "YuKyo_Yoko-Bold"],
        ["YuMin-Medium", "YuMin-Demibold", "YuMin-Extrabold", "YuMin_36pKn-Medium", "YuMin_36pKn-Demibold", "YuMin_36pKn-Extrabold",],
    ]
)
