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
        var accum = 0
        return (0..<frames.endIndex).map{
            let score = frameScore(frames, i: $0)
            accum += score
            return (displayString(frames[$0]), score, accum)
        }
    }
    
    private func displayString(f: Frame) -> String {
        let result: String
        switch true {
            case isStrike(f): result = "X"
            case isSpare(f):  result = "\(f.t1)/" + (hasFillBall(f) ? "\(fillBall(f))" : "")
            default: result = "\(f.t1)\(f.t2)"
        }
        return result
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
    
    private func frameScore(array: [Frame], i: Int) -> Int {
        let xs = array[(i)..<(min(i + 3, array.endIndex))]
        let total = sum(xs[i])
        if isOpen(xs[i]) || xs.count == 1 { return total + fillBall(xs[i]) }
        if isSpare(xs[i]) { return total + xs[i + 1].t1 }
        if !isStrike(xs[i + 1]) || xs.count == 2 { return total + sum(xs[i + 1]) }
        return total + xs[i + 1].t1 + xs[i + 2].t1
    }
    
}
