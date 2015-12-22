# swift-bowling

I was reading something the other day, I can't exactly remember what but it used calculating bowling scores as an example. I skimmed over it at the time but later thought that it could provide a simple exploration of various degrees of the functional style. Given that scoring a bowling game is fairly trivial, objects sometimes seem a bit heavyweight. My feeling is that there is probably a happy middle ground between OO and Functional and that languages like Swift (and Scala) encourage exploitation of this.


## functional_game.swift
Swift more-or-less pure functional implementation.

## OO-Functional Example
Something a bit more OO. It adds some bells and whistles like a bit of error checking. I've used a protocol extension to add some boilerplate stuff which is a bit like the Scala companion Object or perhaps the nearest one can get to an abstract class in Swift. Caution is required here if you're overriding functions implemented this way and passing the Type around instead of the concrete implementation; you may find that the protocol provided version gets used because of the stripping that can occur.
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
Subclassed: Hello World!
```
