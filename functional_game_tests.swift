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

class FunctionalGameTests: XCTestCase {

    func testFrameTuple() {
        let frame: Frame = (10, 0, nil)
        XCTAssertEqual(frame.t1, 10)
        XCTAssertEqual(frame.t2, 0)
        XCTAssertNil(frame.filler)
    }
    
    /**
        example score taken from
        http://bowling.about.com/od/rulesofthegame/a/bowlingscoring.htm
    
        Frame:	1	2	3	4	5	6	7	8	9	10
        Result:	X	7/	7 2	9/	X	X	X	2 3	6/	7/3
        Frame Score:	20	17	9	20	30	22	15	5	17	13
        Running Total:	20	37	46	66	96	118	133	138	155	168
    */
    func testImperfectGameScore() {
        var game = Game()
        game.add((10, 0, nil))
        game.add((7,3,nil))
        game.add((7,2,nil))
        game.add((9,1,nil))
        game.add((10,0,nil))
        game.add((10,0,nil))
        game.add((10,0,nil))
        game.add((2,3,nil))
        game.add((6,4,nil))
        game.add((7,3,3))
        XCTAssertTrue(game.isComplete)
        let scores = game.scores()
        XCTAssertEqual(scores.count, 10)
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
    
    func testPerfectGameScore() {
        var game = Game()
        for _ in 0..<9 {
            game.add((10,0,nil))
        }
        game.add((10,10,10))
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
