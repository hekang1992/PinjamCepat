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
    var preached: [preachedModel]?
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
}
