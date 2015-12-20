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


extension CollectionType {
    
    /**
       Get the first element of a CollectionType using the Scala-style 'head' property.

       The explicit unwrapping allows slighly improved reading.
       - important: Intended for use in recursive functions 
                    where the first statement generally uses emptiness
                    as the terminal clause. Failure to check may cause
                    a runtime error.
    */
    var head: Generator.Element {
        return first!
    }
    
    /**
       Read-only property style access to all elements after the first in a Collection. Effectively an alias for `dropFirst()`
     
       Unlike `head` it is safe to call `tail` on an empty CollectionType
    */
    var tail: SubSequence {
        return dropFirst(1)
    }
}
