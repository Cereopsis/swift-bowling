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
import XCTest

class OOFunctionalGameTests: XCTestCase {
    
    func testCantCreateThrowGreaterThan10() {
        var frame = Frame(throw1: 11)
        XCTAssertNil(frame)
        frame = Frame(throw1: 0, throw2: 11)
        XCTAssertNil(frame)
    }
    
    func testCantCreateFrameScoreGreaterThan10() {
        var frame = Frame(throw1: 10, throw2: 1)
        XCTAssertNil(frame)
        frame = Frame(throw1: 1, throw2: 10)
        XCTAssertNil(frame)
    }
    
    func testCreateOpenFrame() {
        var frame = Frame(throw1: 5)!
        XCTAssertTrue(frame.isOpen)
        frame = Frame(throw1: 6, throw2: 2)!
        XCTAssertTrue(frame.isOpen)
    }
    
    func testCreateStrike() {
        let frame = Frame(throw1: 10)!
        XCTAssertTrue(frame.isStrike)
    }
    
    func testCreateSpare() {
        let frame = Frame(throw1: 7, throw2: 3)!
        XCTAssertTrue(frame.isSpare)
    }
    
    func testFrameTotal() {
        var frame = Frame(throw1: 10)!
        XCTAssertEqual(frame.total, 10)
        frame = Frame(throw1: 1, throw2: 9)!
        XCTAssertEqual(frame.total, 10)
    }
    
    func testOpenFrameDisplayString() {
        let frame = Frame(throw1: 2, throw2: 6)!
        XCTAssertEqual(frame.displayString, "2 6")
    }
    
    func testSpareDisplayString() {
        let frame = Frame(throw1: 6, throw2: 4)!
        XCTAssertEqual(frame.displayString, "6/")
    }
    
    func testStrikeDisplayString() {
        let frame = Frame(throw1: 10)!
        XCTAssertEqual(frame.displayString, "X")
    }
    
    func testCantCreateBadEndFrame() {
        var frame = EndFrame(throw1: 11, throw2: 0, throw3: .None)
        XCTAssertNil(frame)
        frame = EndFrame(throw1: 0, throw2: 11, throw3: .None)
        XCTAssertNil(frame)
        frame = EndFrame(throw1: 0, throw2: 0, throw3: 11)
        XCTAssertNil(frame)
    }
    
    func testCanCreatePerfectEndFrame() {
        let frame = EndFrame(throw1: 10, throw2: 10, throw3: 10)
        XCTAssertNotNil(frame)
    }
    
    func testEndFrameDisplayStrings() {
        var frame = EndFrame(throw1: 10, throw2: 0, throw3: .None)!
        XCTAssertEqual(frame.displayString, "X")
        frame = EndFrame(throw1: 2, throw2: 5, throw3: .None)!
        XCTAssertEqual(frame.displayString, "2 5")
        frame = EndFrame(throw1: 7, throw2: 3, throw3: 3)!
        XCTAssertEqual(frame.displayString, "7/3")
    }
    
    func testCantHaveTooManyFrames() {
        var game = Game()
        let frame = Frame(throw1: 1, throw2: 1)!
        do {
            for _ in 0..<10 {
                try game.addFrame(frame)
            }
            XCTFail("expected error thrown")
        } catch GameError.TooManyFrames {
            ()
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testCantPrematurelyEndGame() {
        var game = Game()
        let frame = EndFrame(throw1: 1, throw2: 1, throw3: nil)!
        do {
            try game.endGame(frame)
            XCTFail("expected error thrown")
        } catch GameError.PrematureEndFrame {
            ()
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    /**
     example score taken from
     http://bowling.about.com/od/rulesofthegame/a/bowlingscoring.htm
     
     Frame:	1	2	3	4	5	6	7	8	9	10
     Result:	X	7/	7 2	9/	X	X	X	2 3	6/	7/3
     Frame Score:	20	17	9	20	30	22	15	5	17	13
     Running Total:	20	37	46	66	96	118	133	138	155	168
     */
    func testImperfectGame() {
        var game = Game()
        do {
            try game.addFrame(Frame(throw1: 10, throw2: 0)!)
            try game.addFrame(Frame(throw1: 7, throw2: 3)!)
            try game.addFrame(Frame(throw1: 7, throw2: 2)!)
            try game.addFrame(Frame(throw1: 9, throw2: 1)!)
            try game.addFrame(Frame(throw1: 10, throw2: 0)!)
            try game.addFrame(Frame(throw1: 10, throw2: 0)!)
            try game.addFrame(Frame(throw1: 10, throw2: 0)!)
            try game.addFrame(Frame(throw1: 2, throw2: 3)!)
            try game.addFrame(Frame(throw1: 6, throw2: 4)!)
            try game.endGame(EndFrame(throw1: 7, throw2: 3, throw3: 3)!)
        } catch {
            XCTFail("\(error)")
            return
        }
        XCTAssertTrue(game.isComplete)
        XCTAssertEqual(game.frames.count, 10)
        let scores = game.scores()
        var result = scores.map{ $0.0 }.joinWithSeparator(" ")
        var expected = "X 7/ 7 2 9/ X X X 2 3 6/ 7/3"
        XCTAssertEqual(result, expected)
        result = scores.map{ "\($0.1)" }.joinWithSeparator(" ")
        expected = "20 17 9 20 30 22 15 5 17 13"
        XCTAssertEqual(result, expected)
        result = scores.map{ "\($0.2)" }.joinWithSeparator(" ")
        expected = "20 37 46 66 96 118 133 138 155 168"
        XCTAssertEqual(result, expected)
    }
    
    func testPerfectGame() {
        var game = Game()
        let strike = Frame(throw1: 10, throw2: 0)!
        do {
            for _ in 0..<9 {
                try game.addFrame(strike)
            }
            try game.endGame(EndFrame(throw1: 10, throw2: 10, throw3: 10)!)
        } catch {
            XCTFail("\(error)")
            return
        }
        XCTAssertTrue(game.isComplete)
        let scores = game.scores()
        XCTAssertEqual(scores.count, 10)
        var result = scores.map{ $0.0 }.joinWithSeparator(" ")
        var expected = "X X X X X X X X X X"
        XCTAssertEqual(result, expected)
        result = scores.map{ "\($0.1)" }.joinWithSeparator(" ")
        expected = "30 30 30 30 30 30 30 30 30 30"
        XCTAssertEqual(result, expected)
        result = scores.map{ "\($0.2)" }.joinWithSeparator(" ")
        expected = "30 60 90 120 150 180 210 240 270 300"
        XCTAssertEqual(result, expected)
    }
    
}
