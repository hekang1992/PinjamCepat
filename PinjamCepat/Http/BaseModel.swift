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
    var favourite: [favouriteModel]?
    var nations: [nationsModel]?
    
    enum CodingKeys: String, CodingKey {
        case handle, steal, pure, able, ugly, preached, cherish, record,
             contemplative, lines, yielded, intimacy, peculiar, favourite,
             nations
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        handle = try container.decodeIfPresent(String.self, forKey: .handle)
        steal = try container.decodeIfPresent(stealModel.self, forKey: .steal)
        pure = try container.decodeIfPresent(String.self, forKey: .pure)
        able = try container.decodeIfPresent(String.self, forKey: .able)
        ugly = try container.decodeIfPresent(String.self, forKey: .ugly)
        preached = try container.decodeIfPresent([preachedModel].self, forKey: .preached)
        cherish = try container.decodeIfPresent(cherishModel.self, forKey: .cherish)
        contemplative = try container.decodeIfPresent([recordModel].self, forKey: .contemplative)
        lines = try container.decodeIfPresent(linesModel.self, forKey: .lines)
        yielded = try container.decodeIfPresent(yieldedModel.self, forKey: .yielded)
        intimacy = try container.decodeIfPresent(Int.self, forKey: .intimacy)
        peculiar = try container.decodeIfPresent([peculiarModel].self, forKey: .peculiar)
        favourite = try container.decodeIfPresent([favouriteModel].self, forKey: .favourite)
        nations = try container.decodeIfPresent([nationsModel].self, forKey: .nations)
        
        if let recordObject = try? container.decode(recordModel.self, forKey: .record) {
            record = recordObject
        } else if let recordArray = try? container.decode([String].self, forKey: .record), recordArray.isEmpty {
            record = nil
        } else {
            record = nil
        }
    }
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
    var vowed: String?
    var rendered: String?
    var disordered: String?
    var mental: String?
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
    var fitting: String?
}

class peculiarModel: Codable {
    var guardianship: String?
    var commonwealth: String?
    var portent: String?
}

class favouriteModel: Codable {
    var vowed: String?
    var belief: String?
    var rendered: String?
    var aware: String?
    var led: String?
    var scroll: Int?
    var portent: String?
    var write: [writeModel]?
    
    private enum CodingKeys: String, CodingKey {
        case vowed, belief, rendered, aware, led, scroll, portent, write
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        vowed = try container.decodeIfPresent(String.self, forKey: .vowed)
        belief = try container.decodeIfPresent(String.self, forKey: .belief)
        rendered = try container.decodeIfPresent(String.self, forKey: .rendered)
        aware = try container.decodeIfPresent(String.self, forKey: .aware)
        scroll = try container.decodeIfPresent(Int.self, forKey: .scroll)
        portent = try container.decodeIfPresent(String.self, forKey: .portent)
        write = try container.decodeIfPresent([writeModel].self, forKey: .write)
        
        if let stringValue = try? container.decodeIfPresent(String.self, forKey: .led) {
            led = stringValue
        } else if let intValue = try? container.decodeIfPresent(Int.self, forKey: .led) {
            led = String(intValue)
        } else {
            led = nil
        }
    }
    
}

class writeModel: Codable {
    var jest: String?
    var led: String?
    
    private enum CodingKeys: String, CodingKey {
        case jest, led
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        jest = try? container.decode(String.self, forKey: .jest)
        
        if let intValue = try? container.decode(Int.self, forKey: .led) {
            led = String(intValue)
        } else {
            led = try? container.decode(String.self, forKey: .led)
        }
    }
}

class nationsModel: Codable {
    var destiny: String?
    var jest: String?
    var afterthought: String?
    var vowed: String?
    var distinctly: String?
    var shaped: String?
    var distorting: String?
    var magnifying: String?
    var write: [writeModel]?
}
