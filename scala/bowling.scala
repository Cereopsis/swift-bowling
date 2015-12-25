package bowling {
	
    trait Scoreable {
    	val throw1: Int
    	val throw2: Int
    	def isStrike: Boolean = throw1 == 10
    	def isSpare: Boolean  = !isStrike && total == 10
    	def isOpen: Boolean   = total < 10
    	def total: Int        = throw1 + throw2
    	def toList: List[Int] = 
    		if (isStrike) List(throw1)
    		else List(throw1, throw2)
    }
	
    case class Frame(val throw1: Int, val throw2: Int = 0) extends Scoreable {
    	override def toString: String  = 
    		if (isStrike) "X"
    		else if (isSpare) s"${throw1}/"
    		else s"${throw1} ${throw2}"
    }
	
    class EndFrame(t1: Int, t2: Int, val filler: Option[Int]) extends Scoreable {
    	val frame: Frame = Frame(t1, t2)
    	override val throw1: Int = frame.throw1
    	override val throw2: Int = frame.throw2
    	override def toList: List[Int] = filler match {
    		case Some(i) => List(throw1, throw2, i)
    		case _ => frame.toList
    	}
	
    	override def toString: String = filler match {
    			case Some(i) => if (isStrike) "X" else s"${throw1}/${i}"
    			case _ => frame.toString
    		}
    }
	
    class Game {
        
      def isComplete: Boolean = frames.length == 10
    	var frames: List[Scoreable] = Nil
	
    	def add(frame: Scoreable) {
    		if (frames.length < 10)
    			frames = frame :: frames  // prepend, we'll reverse later
    	}
	
    	def scores(): List[(String, Int, Int)] = {
    	    val tup = frameScores().zip(frames.map(f => f.toString)).reverse  // zip with descriptions
    	    val accumulator = List((tup.head._2, tup.head._1, tup.head._1))  // List[(String,Int,Int)]
    	    tup.tail.foldLeft(accumulator)((b,a) => (a._2, a._1, b.head._3 + a._1) :: b).reverse	    
    	}


    	private def frameScores(): List[Int] = {
    	    def recurse(xs: List[List[Int]], accumulator: List[Int]): List[Int] = {
    	        if (xs.isEmpty) accumulator
    	        else {
    	            val score = xs.head.length match {
    		            case 1 | 2 => if (xs.head.reduceLeft(_+_) < 10) xs.head // It's an open frame, just return the top List
    		                          else xs.take(3).flatMap(x => x).take(3)   // Take 3 because we need to account for consecutive strikes
    		            case _ => xs.head                                       // This should account for the end frame
    		        }
    		        val total = score.reduceLeft(_+_)                           // sum the 2/3 Int's
    		        recurse(xs.tail, total :: accumulator)
              }
    	    }
    	    val frameList = frames.reverse.map(f => f.toList) // convert to a List[List[Int]]
          recurse(frameList, Nil)
    	}
    }
    
}
