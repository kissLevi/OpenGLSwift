//
//  Vector.swift
//  Raptor
//
//  Created by Kiss Levente on 2018. 02. 20..
//  Copyright © 2018. Kiss Levente. All rights reserved.
//

import Foundation

class Vector {
    var x: Float = 0.0
    var y: Float = 0.0
    
    convenience init() {
        self.init(0,0)
    }
    
    init(_ px: Float,_ py: Float) {
        x = px
        y = py
    }
}
func add(v1: Vector, v2: Vector)-> Vector {
    return Vector(v1.x + v2.x, v1.y + v2.y )
}

func scalarMultiply(v: Vector,s: Float) -> Vector {
    return Vector(v.x * s, v.y * s)
}

