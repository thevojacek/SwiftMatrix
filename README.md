# SwiftMatrix

A small independent package for working with matrixes, written purely in Swift 4.
One of the goals of this package is to be buldable for Linux environment as well, thus the package does not depend on other frameworks like Accelerate and so on.

## Usage

```swift
import SwiftMatrix

// Init
let matrix = SwiftMatrix([[0, 0], [2, 3]])
let matrix2 = SwiftMatrix([[0.8, 1.2], [2.1, 3.3]], dimensions: MatrixDimensions(rows: 2, columns: 2))!

// Sum of values
let sum = matrix.sum()

// Directional sum
let dSum = matrix.sum(to: .rows)

// Logarithm
let log = matrix.log()

// Dot product
let dot = matrix.dotProduct(with: matrix2)

// Operators with numbers (Double)
let add = matrix + 2.2
let sub = matrix - 1.1
let mul = matrix * 1.5
let inverted = matrix.invertSign()

// Operators with matrixes
let addM = matrix + matrix2
let subM = matrix - matrix2
let mulM = matrix * matrix2
let divM = matrix / matrix2

// Equation
let equals = matrix == matrix2

// and so on ...

```

## License
MIT License

Copyright (c) 2018 Jan Vojáček

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
