/*
The MIT License (MIT)
Copyright (c) 2015 Cereopsis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
import Foundation

public struct EndFrame: Scoreable {
    
    private let fillBall: Int?
    private let frame: Frame
    
    public init?(throw1: Int, throw2: Int = 0, throw3: Int? = .None) {
        let list = [throw1] + (throw2 == 0 ? [] : [throw2])
        frame = Frame(list: list)
        fillBall  = throw3
        if throw1 > 10 || throw2 > 10 {
            // we must validate on behalf of Frame
            return nil
        } else if let f = fillBall where f > 10 || frame.isOpen {
            // the last frame must be at least a spare to need a fill ball
            return nil
        }
    }
    
    public var displayString: String {
        let str = frame.displayString
        if let f = fillBall where !isStrike {
            return "\(str)\(f)"
        }
        return str
    }
    
    public var toList: [Int] {
        return frame.toList + (fillBall == nil ? [] : [fillBall!])
    }
}

public struct Frame: Scoreable {
    
    private let array: [Int]
    
    private init(list: [Int]) {
        array = list
    }
    
    public init?(throw1: Int, throw2: Int = 0) {
        array = throw2 == 0 ? [throw1] : [throw1, throw2]
        if total > 10 {
            return nil
        }
    }
    
    public var toList: [Int] { return array }
    
}