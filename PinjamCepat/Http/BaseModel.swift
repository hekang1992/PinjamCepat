//
//  BaseModel.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

class BaseModel: Codable {
    var portent: String?
    var henceforward: String?
    var gloves: glovesModel?
    
    private enum CodingKeys: String, CodingKey {
        case portent, henceforward, gloves
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        henceforward = try? container.decode(String.self, forKey: .henceforward)
        
        gloves = try? container.decode(glovesModel.self, forKey: .gloves)
        
        if let intValue = try? container.decode(Int.self, forKey: .portent) {
            portent = String(intValue)
        } else {
            portent = try? container.decode(String.self, forKey: .portent)
        }
    }
}

class glovesModel: Codable {
    var handle: String?
    var steal: stealModel?
    var pure: String?
    var able: String?
    var ugly: String?
    var preached: [preachedModel]?
    var cherish: cherishModel?
    var record: recordModel?
    var contemplative: [recordModel]?
    var lines: linesModel?
    var yielded: yieldedModel?
    var intimacy: Int?
    var peculiar: [peculiarModel]?
}

class stealModel: Codable {
    var seems: String?
    var remembrance: String?
    var confused: String?
    var gravely: String?
}

class preachedModel: Codable {
    var vowed: String?
    var ugly: String?
    var bearded: String?
    var led: String?
    var yielded: [yieldedModel]?
}

class yieldedModel: Codable {
    var whimseys: Int?
    var brain: String?
    var trouble: String?
    var sabbath: String?
    var beseech: String?
    var poorly: String?
    var skill: String?
    var verily: String?
    var addressed: String?
    var discovers: String?
}

class cherishModel: Codable {
    var efficacy: String?
}

class recordModel: Codable {
    var mental: String?
    var vowed: String?
    var disordered: String?
    var morbidly: String?
    var against: Int?
}

class linesModel: Codable {
    var brain: String?
    var trouble: String?
    var solely: String?
    var disease: String?
    var sabbath: String?
    var whimseys: String?
}

class peculiarModel: Codable {
    var guardianship: String?
    var commonwealth: String?
    var portent: String?
}
