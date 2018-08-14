//
//  ZYYJsonParse.swift
//  TyreProject
//
//  Created by ZYY on 2017/7/12.
//  Copyright © 2017年 ZYY. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONParsable {
    static func parse(_ json: JSON) -> Self?
}

protocol Pageble {
    var currentPageIndex: Int { get set }
    var totalPageIndex: Int { get set }
}

extension JSON: JSONParsable {
    static func parse(_ json: JSON) -> JSON? {
        return json
    }
}

extension String: JSONParsable {
    static func parse(_ json: JSON) -> String? {
        return json.string
    }
}

extension CustomDebugStringConvertible {
    var description: String {
        var string: String = "<\(NSStringFromClass(object_getClass(self)!) )"
        let objMirror = Mirror(reflecting: self)
        objMirror.children.forEach {
            (children) in string.append("\(String(describing: children.label)) = \(children.value)")
        }
        let nsstring = string as NSString
        nsstring.replacingCharacters(in: NSMakeRange(nsstring.length - 1, 1), with: ">")
        return nsstring as String
    }
}

struct ObjectModelArray<J: JSONParsable>: JSONParsable {
    var objectModels: [J] = []
    init?(json: JSON) {
        guard json.type == .array, let array = json.array else {
            return nil
        }
        self.objectModels = array.map{ (eachJson) -> J in
            return J.parse(eachJson)!
        }
    }
    
    static func parse(_ json: JSON) -> ObjectModelArray<J>? {
        return ObjectModelArray<J>(json: json)
    }
}

struct ObjectModelPagedArray<J: JSONParsable>: JSONParsable, Pageble {
    let objectModels: [J]
    
    var currentPageIndex: Int = 0
    var totalPageIndex: Int = 0
    
    init?(json: JSON, currentPageIndex: Int, totalPageIndex: Int) {
        guard json.type == .array, let array = json.array else {
            return nil
        }
        self.objectModels = array.map{ (eachJson) -> J in
            return J.parse(eachJson)!
        }
        self.currentPageIndex = currentPageIndex
        self.totalPageIndex = totalPageIndex
    }
    
    static func parse(_ json: JSON) -> ObjectModelPagedArray<J>? {
        return ObjectModelPagedArray<J>(json: json["data"], currentPageIndex: json["currentPage"].intValue, totalPageIndex: json["totalPage"].intValue)
    }
}
