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
        let scores = reduce(mapFrames(frames))
        var accum = 0
        return (0..<frames.endIndex).map{
            let score = scores[$0]
            accum += score
            return (displayString(frames[$0]), score, accum)
        }
    }
    
    private func displayString(f: Frame) -> String {
        let result: String
        switch true {
            case isStrike(f): result = "X"
            case isSpare(f):  result = "\(f.t1)/" + (hasFillBall(f) ? "\(fillBall(f))" : "")
            default: result = "\(f.t1) \(f.t2)"
        }
        return result
    }
    
    /// Sum the Ints in an array using slices equal to startIndex..<(startIndex + n)
    /// where n in 1...2 and startIndex in 0..<10
    private func reduce(scores: [Int]) -> [Int] {
        var c = 0
        return (0..<10).map{ _ -> Int in
            let i = scores[c] + scores[c+1] < 10 ? 1 : 2
            let sum = scores[(c)...(c+i)].reduce(0, combine: +)
            c += scores[c] < 10 ? 2 : 1
            return sum
        }
    }
    
    /// Produce an array that removes the 'noise' of a Frame
    private func mapFrames(xs: [Frame]) -> [Int] {
        func mapf(f: Frame) -> [Int] {
            if f.t1 == 10 { return [f.t1] }
            return [f.t1, f.t2]
        }
        func endf(f: Frame) -> [Int] {
            return [f.t1, f.t2, fillBall(f)]
        }
        return xs.dropLast().flatMap({ mapf($0)}) + endf(xs.last!)
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
    
    private func sum(f: Frame) -> Int {
        return f.t1 + f.t2
    }
    
}
