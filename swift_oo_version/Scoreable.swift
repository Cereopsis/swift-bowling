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

public protocol Scoreable {
    var firstThrow: Int  { get }
    var secondThrow: Int { get }
    var total: Int { get }
    var isStrike: Bool { get }
    var isSpare: Bool { get }
    var isOpen: Bool { get }
    var toList: [Int] { get }
    var displayString: String { get }
}

public extension Scoreable {
    var firstThrow: Int  { return toList.first! }
    var secondThrow: Int { return toList.count > 1 ? toList[1] : 0 }
    var isStrike: Bool { return firstThrow == 10 }
    var isSpare:  Bool { return !isStrike && firstThrow + secondThrow == 10 }
    var isOpen:   Bool { return total < 10 }
    var total:    Int  { return toList.reduce(0, combine: +) }
    var displayString: String {
        if isOpen { return "\(firstThrow) \(secondThrow)" }
        if isSpare { return "\(firstThrow)/" }
        return "X"
    }
}
