# swift-bowling

I was reading something the other day, I can't exactly remember what but it used calculating ten-pin bowling scores as an example. I skimmed over it at the time but later thought that it could provide a simple exploration of various degrees of the functional style. Given that scoring a bowling game is fairly trivial, objects sometimes seem a bit heavyweight. My feeling is that there is probably a happy middle ground between OO and Functional and that languages like Swift (and Scala) encourage exploitation of this.

A quick precis of the rules. A game consists of 10 frames, a frame has one or two throws depending on the number of pins knocked down by the first throw. A strike takes down all pins with the first throw, a spare clears them up on the second. If any pins remain after two throws, this is known as an open frame. Scoring an open frame is easy, it's simply the number of pins taken down. Otherwise the score is calculated using three throws i.e by using one to two throws in subsequent frames. For a spare this will be the first throw of the next frame and a strike requires the next two throws which can mean the two following frames if they are also strikes. In this way we can conclude that the maximum score for a spare is 20 and 30 for a strike.


## functional_game.swift
Swift more-or-less pure functional implementation.

## OO-Functional Example
Something a bit more OO. It adds some bells and whistles like a bit of error checking. I've used a protocol extension to add some boilerplate stuff which is a bit like the Scala Trait or perhaps the nearest one can get to an abstract class in Swift. Caution is required here if you're overriding functions implemented this way and passing the Type around instead of the concrete implementation; you may find that the protocol provided version gets used because of the stripping that can occur.
```
  protocol P {
      func abstract() -> String
  }

  extension P {
      func abstract() -> String {
          return "Abstract: protocol-supplied implementation"
      }
  }

  class ConcreteP: P {
    // use protocol supplied definition 
  }

  class OverridingP: P {
      func abstract() -> String {
          return "Overriding: concrete implementation supplies new definition"
      }
  }

  class SubConcrete: ConcreteP {
      func abstract() -> String {
          return "Subclassed: Hello World!"
      }
  }

  func takeaP(p: P) {
      print(p.abstract())
  }
  
  func castaP(p: P) {
      switch p {
          case is SubConcrete: print("Cast -> " + (p as! SubConcrete).abstract())
          default: takeaP(p)
      }
  }

  takeaP(ConcreteP())
  takeaP(SubConcrete())
  takeaP(OverridingP())
  castaP(SubConcrete())
```

Output:
```
Abstract: protocol-supplied implementation
Abstract: protocol-supplied implementation
Overriding: concrete implementation supplies new definition
Cast -> Subclassed: Hello World!
```

## Scala
Scala provides many more ways to work with lists. For example, we can grab the top n items with `take(n)` and furthermore we don't need to worry about bounds checking, we'll get whatever is available:
```
// Given a structure like this: List(List(10),List(7,3),List(7,2))
// Take first three items, flatten into a single list, then take the first 3 Ints
xs.take(3).flatMap(x => x).take(3) 
// As we process the list, we'll eventually run out of items but take(3) will still work correctly
```
It's interesting jumping between languages and it can have the effect of encouraging you to try different things. I'd obviously not read the manual properly as far as Swift goes because I overlooked a few functions on collections that achieve the same thing as take(n) and friends - `prefix`, `prefixUpTo`, `prefixThrough` etc. Coupled with the idea of processing scores as an array-of-arrays / nested Lists, I feel like I managed to get rid of some awkwardness around trying to grab the appropriate number of throws to use when doing the calculation. Reworking `Scoreable` to make the list thing more explicit (OK, I'm perhaps using a Scala-specific term there) allowed me to process the end frame more naturally. The swift equivalent of above now looks like this:
```
xs.prefix(3).flatten().prefix(3).reduce(0, combine: +)
```
