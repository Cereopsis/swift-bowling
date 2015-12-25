import org.scalatest._
import bowling._

class BowlingSpec extends FlatSpec with Matchers {
    "A game" should "have ten frames" in {
        val game = new Game()
        assert(!game.isComplete)
        for (i <- 1 to 10) game.add(Frame(7))
        assert(game.isComplete)
    }
    
    "A perfect game" should "consist of ten strikes plus two extra throws" in {
        val game = new Game()
        val strike = Frame(10)
        for (i <- 1 to 9) game.add(strike)
        game.add(new EndFrame(10,10,Some(10)))
        val scores = game.scores()
        val strings = scores.map(t => t._1).mkString(" ")
        strings should be ("X X X X X X X X X X")
        val frames = scores.map(t => t._2).mkString(" ")
        frames should be ("30 30 30 30 30 30 30 30 30 30")
        val accumulative = scores.map(t => t._3).mkString(" ")
        accumulative should be ("30 60 90 120 150 180 210 240 270 300")
    }
    
    "A not so perfect game" should "contain a variety of open frames, spares and strikes" in {
        val game = new Game()
        game.add(Frame(10))
        game.add(Frame(7,3))
        game.add(Frame(7,2))
        game.add(Frame(9,1))
        game.add(Frame(10))
        game.add(Frame(10))
        game.add(Frame(10))
        game.add(Frame(2,3))
        game.add(Frame(6,4))
        game.add(new EndFrame(7,3,Some(3)))
        val scores = game.scores()
        val strings = scores.map(t => t._1).mkString(" ")
        strings should be ("X 7/ 7 2 9/ X X X 2 3 6/ 7/3")
        val frames = scores.map(t => t._2).mkString(" ")
        frames should be ("20 17 9 20 30 22 15 5 17 13")
        val accumulative = scores.map(t => t._3).mkString(" ")
        accumulative should be ("20 37 46 66 96 118 133 138 155 168")
    }
}