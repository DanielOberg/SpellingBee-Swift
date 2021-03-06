//
//  JapaneseWord.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-10-06.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import Foundation

struct JapaneseWord: Codable {
    let english: String
    let kana: String
    let kanji: String
    let example_sentence_jp: String
    let example_sentence_en: String
    let uuid: String
    let tags: [String]
    let romaji: String
    
    func listRomaji() -> [String] {
        let all = (JapaneseWord.listAllHiragana()+JapaneseWord.listAllKatakana()).sorted { (a, b) -> Bool in a.count > b.count }
        let kanaMutable = NSMutableString(string: kana)
        var result = [String]()
        while (kanaMutable.length > 0) {
            for r in all {
                if (kanaMutable.hasPrefix(r)) {
                    var str = r.applyingTransform(StringTransform.latinToKatakana, reverse: true)?.applyingTransform(StringTransform.latinToHiragana, reverse: true)
                    str = str?.replacingOccurrences(of: "~", with: "x")
                    result.append(str!);
                    kanaMutable.deleteCharacters(in: NSRange(location: 0, length: r.count))
                    break;
                }
            }
        }
        return result
    }
    
    func listKana() -> [String] {
        let all = (JapaneseWord.listAllHiragana()+JapaneseWord.listAllKatakana()).sorted { (a, b) -> Bool in a.count > b.count }
        let kanaMutable = NSMutableString(string: kana)
        var result = [String]()
        while (kanaMutable.length > 0) {
            for r in all {
                if (kanaMutable.hasPrefix(r)) {
                    result.append(r);
                    kanaMutable.deleteCharacters(in: NSRange(location: 0, length: r.count))
                    break;
                }
            }
        }
        return result
    }
    
    static func listAllRomaji() -> [String] {
        let tuples: [(String, String)] = [
            ("a","ア"),
            ("ka","カ"),
            ("sa","サ"),
            ("ta","タ"),
            ("na","ナ"),
            ("i","イ"),
            ("ki","キ"),
            ("shi","シ"),
            ("chi","チ"),
            ("ni","ニ"),
            ("u","ウ"),
            ("ku","ク"),
            ("su","ス"),
            ("tsu","ツ"),
            ("nu","ヌ"),
            ("e","エ"),
            ("ke","ケ"),
            ("se","セ"),
            ("te","テ"),
            ("ne","ネ"),
            ("o","オ"),
            ("ko","コ"),
            ("so","ソ"),
            ("to","ト"),
            ("no","ノ"),
            ("ha","ハ"),
            ("ma","マ"),
            ("ya","ヤ"),
            ("ra","ラ"),
            ("wa","ワ"),
            ("hi","ヒ"),
            ("mi","ミ"),
            ("ri","リ"),
            ("fu","フ"),
            ("mu","ム"),
            ("yu","ユ"),
            ("ru","ル"),
            ("n","ン"),
            ("he","ヘ"),
            ("me","メ"),
            ("re","レ"),
            ("ho","ホ"),
            ("mo","モ"),
            ("yo","ヨ"),
            ("ro","ロ"),
            ("ga","ガ"),
            ("za","ザ"),
            ("da","ダ"),
            ("ba","バ"),
            ("pa","パ"),
            ("gi","ギ"),
            ("ji","ジ"),
            ("ji","ヂ"),
            ("bi","ビ"),
            ("pi","ピ"),
            ("gu","グ"),
            ("zu","ズ"),
            ("zu","ヅ"),
            ("bu","ブ"),
            ("pu","プ"),
            ("ge","ゲ"),
            ("ze","ゼ"),
            ("de","デ"),
            ("be","ベ"),
            ("pe","ペ"),
            ("go","ゴ"),
            ("zo","ゾ"),
            ("do","ド"),
            ("bo","ボ"),
            ("po","ポ"),
            ("kya","キャ"),
            ("sha","シャ"),
            ("cha","チャ"),
            ("hya","ヒャ"),
            ("pya","ピャ"),
            ("kyu","キュ"),
            ("shu","シュ"),
            ("chu","チュ"),
            ("hyu","ヒュ"),
            ("pyu","ピュ"),
            ("kyo","キョ"),
            ("sho","ショ"),
            ("cho","チョ"),
            ("hyo","ヒョ"),
            ("pyo","ピョ"),
            ("gya","ギャ"),
            ("ja","ジャ"),
            ("nya","ニャ"),
            ("bya","ビャ"),
            ("mya","ミャ"),
            ("gyu","ギュ"),
            ("ju","ジュ"),
            ("nyu","ニュ"),
            ("byu","ビュ"),
            ("my","ミュ"),
            ("gyo","ギョ"),
            ("jo","ジョ"),
            ("nyo","ニョ"),
            ("byo","ビョ"),
            ("myo","ミョ"),
            ("rya","リャ"),
            ("ryu","リュ"),
            ("ryo","リョ"),
            ("ye","イェ"),
            ("va","(ヷ)"),
            ("va","ヴァ"),
            ("she","シェ"),
            ("wi","ウィ"),
            ("vi","ヴィ"),
            ("je","ジェ"),
            ("we","ウェ"),
            ("vu","ヴ"),
            ("ve","ヴェ"),
            ("che","チェ"),
            ("wo","ウォ"),
            ("vo","ヴォ"),
            ("vya","ヴャ"),
            ("ti","ティ"),
            ("tsa","ツァ"),
            ("fa","ファ"),
            ("tu","トゥ"),
            ("tsi","ツィ"),
            ("fi","フィ"),
            ("tyu","テュ"),
            ("tse","ツェ"),
            ("fe","フェ"),
            ("di","ディ"),
            ("tso","ツォ"),
            ("fo","フォ"),
            ("du","ドゥ"),
            ("fyu","フュ"),
            ("dyu","デュ")];
        
        return tuples.map{$0.0}
    }
    
    static func listAllHiragana() -> [String] {
        let tuples: [(String, String)] = [
            ("a","あ"),
            ("ka","か"),
            ("sa","さ"),
            ("ta","た"),
            ("na","な"),
            ("i","い"),
            ("ki","き"),
            ("shi","し"),
            ("chi","ち"),
            ("ni","に"),
            ("u","う"),
            ("ku","く"),
            ("su","す"),
            ("tsu","つ"),
            ("nu","ぬ"),
            ("e","え"),
            ("ke","け"),
            ("se","せ"),
            ("te","て"),
            ("ne","ね"),
            ("o","お"),
            ("ko","こ"),
            ("so","そ"),
            ("to","と"),
            ("no","の"),
            ("ha","は"),
            ("ma","ま"),
            ("ya","や"),
            ("ra","ら"),
            ("wa","わ"),
            ("hi","ひ"),
            ("mi","み"),
            ("ri","り"),
            ("wi","ゐ"),
            ("fu","ふ"),
            ("mu","む"),
            ("yu","ゆ"),
            ("ru","る"),
            ("n","ん"),
            ("he","へ"),
            ("me","め"),
            ("re","れ"),
            ("we","ゑ"),
            ("ho","ほ"),
            ("mo","も"),
            ("yo","よ"),
            ("ro","ろ"),
            ("wo","を"),
            ("ga","が"),
            ("za","ざ"),
            ("da","だ"),
            ("ba","ば"),
            ("pa","ぱ"),
            ("gi","ぎ"),
            ("ji","じ"),
            ("ji","ぢ"),
            ("bi","び"),
            ("pi","ぴ"),
            ("gu","ぐ"),
            ("zu","ず"),
            ("zu","づ"),
            ("bu","ぶ"),
            ("pu","ぷ"),
            ("ge","げ"),
            ("ze","ぜ"),
            ("de","で"),
            ("be","べ"),
            ("pe","ぺ"),
            ("go","ご"),
            ("zo","ぞ"),
            ("do","ど"),
            ("bo","ぼ"),
            ("po","ぽ"),
            ("kya","きゃ"),
            ("sha","しゃ"),
            ("cha","ちゃ"),
            ("hya","ひゃ"),
            ("pya","ぴゃ"),
            ("kyu","きゅ"),
            ("shu","しゅ"),
            ("chu","ちゅ"),
            ("hyu","ひゅ"),
            ("pyu","ぴゅ"),
            ("kyo","きょ"),
            ("sho","しょ"),
            ("cho","ちょ"),
            ("hyo","ひょ"),
            ("pyo","ぴょ"),
            ("gya","ぎゃ"),
            ("ja","じゃ"),
            ("nya","にゃ"),
            ("bya","びゃ"),
            ("mya","みゃ"),
            ("ju","じゅ"),
            ("nyu","にゅ"),
            ("byu","びゅ"),
            ("myu","みゅ"),
            ("gyu","ぎゅ"),
            ("gyo","ぎょ"),
            ("jo","じょ"),
            ("nyo","にょ"),
            ("byo","びょ"),
            ("myo","みょ"),
            ("rya","りゃ"),
            ("ryu","りゅ"),
            ("ryo","りょ"),
            ("xtsu","っ")];
        
        return tuples.map{$0.1}
    }
    
    static func listAllKatakana() -> [String] {
        let tuples: [(String, String)] = [
            ("a","ア"),
            ("ka","カ"),
            ("sa","サ"),
            ("ta","タ"),
            ("na","ナ"),
            ("i","イ"),
            ("ki","キ"),
            ("shi","シ"),
            ("chi","チ"),
            ("ni","ニ"),
            ("u","ウ"),
            ("ku","ク"),
            ("su","ス"),
            ("tsu","ツ"),
            ("nu","ヌ"),
            ("e","エ"),
            ("ke","ケ"),
            ("se","セ"),
            ("te","テ"),
            ("ne","ネ"),
            ("o","オ"),
            ("ko","コ"),
            ("so","ソ"),
            ("to","ト"),
            ("no","ノ"),
            ("ha","ハ"),
            ("ma","マ"),
            ("ya","ヤ"),
            ("ra","ラ"),
            ("wa","ワ"),
            ("hi","ヒ"),
            ("mi","ミ"),
            ("ri","リ"),
            ("fu","フ"),
            ("mu","ム"),
            ("yu","ユ"),
            ("ru","ル"),
            ("n","ン"),
            ("he","ヘ"),
            ("me","メ"),
            ("re","レ"),
            ("ho","ホ"),
            ("mo","モ"),
            ("yo","ヨ"),
            ("ro","ロ"),
            ("ga","ガ"),
            ("za","ザ"),
            ("da","ダ"),
            ("ba","バ"),
            ("pa","パ"),
            ("gi","ギ"),
            ("ji","ジ"),
            ("ji","ヂ"),
            ("bi","ビ"),
            ("pi","ピ"),
            ("gu","グ"),
            ("zu","ズ"),
            ("zu","ヅ"),
            ("bu","ブ"),
            ("pu","プ"),
            ("ge","ゲ"),
            ("ze","ゼ"),
            ("de","デ"),
            ("be","ベ"),
            ("pe","ペ"),
            ("go","ゴ"),
            ("zo","ゾ"),
            ("do","ド"),
            ("bo","ボ"),
            ("po","ポ"),
            ("kya","キャ"),
            ("sha","シャ"),
            ("cha","チャ"),
            ("hya","ヒャ"),
            ("pya","ピャ"),
            ("kyu","キュ"),
            ("shu","シュ"),
            ("chu","チュ"),
            ("hyu","ヒュ"),
            ("pyu","ピュ"),
            ("kyo","キョ"),
            ("sho","ショ"),
            ("cho","チョ"),
            ("hyo","ヒョ"),
            ("pyo","ピョ"),
            ("gya","ギャ"),
            ("ja","ジャ"),
            ("nya","ニャ"),
            ("bya","ビャ"),
            ("mya","ミャ"),
            ("gyu","ギュ"),
            ("ju","ジュ"),
            ("nyu","ニュ"),
            ("byu","ビュ"),
            ("my","ミュ"),
            ("gyo","ギョ"),
            ("jo","ジョ"),
            ("nyo","ニョ"),
            ("byo","ビョ"),
            ("myo","ミョ"),
            ("rya","リャ"),
            ("ryu","リュ"),
            ("ryo","リョ"),
            ("ye","イェ"),
            ("va","(ヷ)"),
            ("va","ヴァ"),
            ("she","シェ"),
            ("wi","ウィ"),
            ("vi","ヴィ"),
            ("je","ジェ"),
            ("we","ウェ"),
            ("vu","ヴ"),
            ("ve","ヴェ"),
            ("che","チェ"),
            ("wo","ウォ"),
            ("vo","ヴォ"),
            ("vya","ヴャ"),
            ("ti","ティ"),
            ("tsa","ツァ"),
            ("fa","ファ"),
            ("tu","トゥ"),
            ("tsi","ツィ"),
            ("fi","フィ"),
            ("tyu","テュ"),
            ("tse","ツェ"),
            ("fe","フェ"),
            ("di","ディ"),
            ("tso","ツォ"),
            ("fo","フォ"),
            ("du","ドゥ"),
            ("fyu","フュ"),
            ("dyu","デュ"),
            ("xtsu","ッ"),
            ("dash","ー")
        ];
        
        return tuples.map{$0.1}
    }
}
