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
    
    public let firstThrow: Int
    public let secondThrow: Int
    public let fillBall: Int?
    
    public init?(throw1: Int, throw2: Int, throw3: Int?) {
        firstThrow = throw1
        secondThrow = throw2
        fillBall  = throw3
        if firstThrow > 10 || secondThrow > 10 { return nil }
        if let n = fillBall where n > 10 { return nil }
    }
    
    public func score(frames: [Scoreable]) -> Int {
        let filler = fillBall ?? 0
        return firstThrow + secondThrow + filler
    }
    
    public var displayString: String {
        if isOpen { return "\(firstThrow) \(secondThrow)" }
        if isSpare {
            var result = "\(firstThrow)/"
            if let filler = fillBall {
                result += "\(filler)"
            }
            return result
        }
        return "X"
    }
}

public struct Frame: Scoreable {
    
    public let firstThrow: Int
    public let secondThrow: Int
    public init?(throw1: Int, throw2: Int = 0) {
        firstThrow = throw1
        secondThrow = throw2
        if total > 10 {
            return nil
        }
    }
    
    public func score(frames: [Scoreable]) -> Int {
        func scoreAcc(f: ArraySlice<Scoreable>, take: Int, result: Int) -> Int {
            if f.isEmpty || take == 0 { return result }
            if take == 1 { return result + f.head.firstThrow }
            return scoreAcc(f.tail, take: f.head.isStrike ? 1 : 0 , result: result + f.head.total)
        }
        if frames.isEmpty || isOpen { return total }
        return scoreAcc(frames.suffixFrom(0), take: isSpare ? 1 : 2, result: total)
    }
    
}