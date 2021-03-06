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


public enum GameError: ErrorType {
    case TooManyFrames
    case GameCompleted
    case PrematureEndFrame
}

public struct Game {
    
    private (set) public var frames: [Scoreable] = []
    private (set) public var isComplete: Bool = false
    
    public init() {}
    
    private mutating func add(scoreable: Scoreable) throws {
        if isComplete { throw GameError.GameCompleted }
        frames.append(scoreable)
    }
    
    public mutating func addFrame(frame: Frame) throws {
        if frames.count == 9 { throw GameError.TooManyFrames }
        try add(frame)
    }
    
    public mutating func endGame(frame: EndFrame) throws {
        if frames.count < 9 { throw GameError.PrematureEndFrame }
        try add(frame)
        isComplete = true
    }

    
    public func scores() -> [(String, Int, Int)] {
        let scores = reduce(frames.map{ $0.toList })
        return zip(frames.map{ $0.displayString }, accumulate(scores)).flatMap{ ($0.0, $0.1.0, $0.1.1) }
    }
    
    private func accumulate(xs: [Int]) -> [(Int, Int)] {
        if xs.isEmpty { return [] }
        return xs.tail.reduce([(xs.head, xs.head)]){ b, a in
            return b + [(a, a + b.last!.1)]
        }
    }
    
    private func reduce(scores: [[Int]]) -> [Int] {
        func recurse(xs: ArraySlice<Array<Int>>, accumulator: [Int]) -> [Int] {
            if xs.isEmpty { return accumulator }
            let s = xs.head.reduce(0, combine: +)
            let score: Int = {
                if s < 10 || xs.tail.isEmpty { return s }                      // open or final frame
                return xs.prefix(3).flatten().prefix(3).reduce(0, combine: +)  // take 3 consecutive throws and sum them - accounts for 3 strikes
            }()
            return recurse(xs.tail, accumulator: accumulator + [score])
        }
        return recurse(scores[0..<scores.endIndex], accumulator: [])
    }
    
}
