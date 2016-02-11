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

typealias Frame = (t1: Int, t2: Int, filler: Int?)

struct Game {
    
    var frames: [Frame] = []
    
    /// 'true' when 10 frames have been added.
    var isComplete: Bool {
        return frames.count == 10
    }
    
    /// Add this frame.
    /// - important: Silently ignored when isComplete returns true.
    /// - parameter: frame: the Frame to add.
    mutating func add(frame: Frame) {
        if !isComplete {
            frames.append(frame)
        }
    }
    
    /// Score this game.
    /// - important: Can be run at any time but frames dependent on missing frames will be incorrect.
    /// TODO: FIX omit incomplete frames, perhaps?
    /// - returns: A tuple score for each frame of the game containing the frame details, score and accumulative score.
    func scores() -> [(String,Int,Int)] {
        let scores = reduce(frames.map{ toList($0) })
        let z = zip(frames.map{ toString($0) }, scores).flatMap{ $0 }
        return z.tail.reduce([(z.head.0, z.head.1, z.head.1)]){ acc, tup in
            let num = acc.last!.2
            return acc + [(tup.0, tup.1, tup.1 + num)]
        }
    }
    
    private func toString(f: Frame) -> String {
        switch true {
        case isStrike(f):
            return "X"
        case isSpare(f):
            return "\(f.t1)/" + (hasFillBall(f) ? "\(fillBall(f))" : "")
        default:
            return "\(f.t1) \(f.t2)"
        }
    }
    
    /// Take the two dimensional array and calculate the score for each frame by using consecutive frames where necessary
    private func reduce(scores: [[Int]]) -> [Int] {
        func recurse(xs: ArraySlice<Array<Int>>, accumulator: [Int]) -> [Int] {
            if xs.isEmpty { return accumulator }
            let s = xs.head.reduce(0, combine: +)
            let score: Int = {
                if s < 10 || xs.tail.isEmpty { return s }                      // open or final frame - use the sum directly
                return xs.prefix(3).flatten().prefix(3).reduce(0, combine: +)  // take 3 consecutive throws and sum them - accounts for 3 strikes
            }()
            return recurse(xs.tail, accumulator: accumulator + [score])
        }
        return recurse(scores[0..<scores.endIndex], accumulator: [])
    }
    
    private func toList(f: Frame) -> [Int] {
        switch true {
        case hasFillBall(f):
            return [f.t1, f.t2, f.filler!]
        case isStrike(f):
            return [10]
        default:
            return [f.t1, f.t2]
        }
    }
    
    private func isSpare(f: Frame) -> Bool {
        return !isStrike(f) && f.t1 + f.t2 == 10
    }
    
    private func isStrike(f: Frame) -> Bool {
        return f.t1 == 10
    }
    
    private func isOpen(f: Frame) -> Bool {
        return f.t1 + f.t2 < 10
    }
    
    private func hasFillBall(f: Frame) -> Bool {
        return f.filler != .None
    }
    
    private func fillBall(f: Frame) -> Int {
        return f.filler ?? 0
    }
    
}
