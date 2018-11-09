import Foundation

public struct SwiftMatrix {
    
    /// Flat map of Matrix's values.
    public let values: [Double]
    
    /// Dimensions of a Matrix describing it's actual shape.
    public let dimensions: MatrixDimensions
    
    /// Initialization of a matrix with array visually representing a matrix.
    ///
    /// - Parameter values: Array of values visually representing a matrix.
    public init (_ values: [[Double]]) {
        self.values = values.reduce([Double](), { (acc, val) -> [Double] in acc + val })
        self.dimensions = MatrixDimensions(rows: values.count, columns: values[0].count)
    }
    
    /// Initialization with flat array values and desired dimensions of a matrix.
    ///
    /// - Parameters:
    ///   - values: Flat array of all values.
    ///   - dimensions: Matrix dimensions.
    public init? (_ values: [Double], dimensions: MatrixDimensions) {
        
        if values.count != dimensions.elements {
            return nil
        }
        
        self.values = values
        self.dimensions = dimensions
    }
    
    /// Creates a matrix according to a provided dimensions and filled with zeros.
    ///
    /// - Parameter dimensions: Desired dimensions of a matrix.
    /// - Returns: Matrix filled with zeros.
    public static func zeros (dimensions: MatrixDimensions) -> SwiftMatrix {
        return SwiftMatrix(
            [Double](repeating: 0.0, count: dimensions.elements), // Creates array of 0.0
            dimensions: dimensions
        )!
    }
    
    /// Creates a matrix according to a privded dimension with random values.
    ///
    /// - Parameters:
    ///   - dimensions: Desired dimensions of a matrix.
    ///   - multiplier: Multiplier to multiply all the random values with, defaults to 1.0.
    /// - Returns: Matrix with random values.
    public static func random (dimensions: MatrixDimensions, multiplier: Double = 1.0) -> SwiftMatrix {
        
        var values = [Double]()
        
        for _ in 0..<dimensions.elements {
            values.append(Double.random(in: 0...1000) * multiplier)
        }
        
        return SwiftMatrix(values, dimensions: dimensions)!
    }
}


/// Private math functions
extension SwiftMatrix {
    
    /// Add scalar value to every element of a matrix.
    ///
    /// - Parameter scalar: scalar value to add to matrix.
    /// - Returns: new matrix.
    private func addScalar (_ scalar: Double) -> SwiftMatrix {
        let values = self.values.map { (value) -> Double in value + scalar }
        return SwiftMatrix(values, dimensions: self.dimensions)!
    }
    
    /// Multiplies every element of matrix by a scalar value.
    ///
    /// - Parameter _scalar: scalar value to multiply matrix by.
    /// - Returns: new matrix.
    private func multiplyByScalar (_ scalar: Double) -> SwiftMatrix {
        let values = self.values.map { (value) -> Double in value * scalar }
        return SwiftMatrix(values, dimensions: self.dimensions)!
    }
    
    private func addMatrix (_ matrix: SwiftMatrix) -> SwiftMatrix? {

        if self.dimensions != matrix.dimensions {
            return nil
        }
        
        let addition = matrix.values
        
        let values = self.values.enumerated().map { (arg0) -> Double in
            let (index, value) = arg0
            return value + addition[index]
        }
        
        return SwiftMatrix(values, dimensions: self.dimensions)!
    }
    
    private func multiplyMatrix (_ matrix: SwiftMatrix) -> SwiftMatrix? {
        
        if self.dimensions != matrix.dimensions {
            return nil
        }
        
        let multiplication = matrix.values
        
        let values = self.values.enumerated().map { (arg0) -> Double in
            let (index, value) = arg0
            return value * multiplication[index]
        }
        
        return SwiftMatrix(values, dimensions: self.dimensions)
    }
    
    private func divideMatrix (_ matrix: SwiftMatrix) -> SwiftMatrix? {
        
        if self.dimensions != matrix.dimensions {
            return nil
        }
        
        let division = matrix.values
        
        let values = self.values.enumerated().map { (arg0) -> Double in
            let (index, value) = arg0
            return value / division[index]
        }
        
        return SwiftMatrix(values, dimensions: self.dimensions)
    }
}


/// Public math extensions
extension SwiftMatrix {
    
    /// Enum describing sum happens in rows or colums direction
    public enum SumDirection {
        case rows
        case columns
    }
    
    /// Inverts sign of every element of the `Matrix`
    ///
    /// - returns:      `Matrix` with values of opposite sign
    public func invertSign() -> SwiftMatrix {
        return SwiftMatrix(self.values.map({ (value) -> Double in -value }), dimensions: self.dimensions)!
    }
    
    /// Matrix broadcasting operation.
    ///
    /// - Parameter dimensions: dimension to broadcast matrix to.
    /// - Returns: new matrix or nil.
    public func broadcast (to dimensions: MatrixDimensions) -> SwiftMatrix? {
        
        if dimensions.rows == self.dimensions.rows && (dimensions.columns % self.dimensions.columns) == 0 {
            
            var values = [Double]()
            let amount = dimensions.columns / self.dimensions.columns
            
            for value in self.values {
                for _ in 0..<amount {
                    values.append(value)
                }
            }
            
            return SwiftMatrix(values, dimensions: dimensions)
        }
        
        if dimensions.columns == self.dimensions.columns && (dimensions.rows % self.dimensions.rows) == 0 {
            
            var values = [Double]()
            let amount = dimensions.rows / self.dimensions.rows
            
            for _ in 0..<amount {
                values += self.values
            }
            
            return SwiftMatrix(values, dimensions: dimensions)
        }
        
        return nil
    }
    
    /// Sums all the elements of a matrix.
    ///
    /// - Returns: sum of all elements of a matrix.
    public func sum () -> Double {
        return self.values.reduce(0, { (acc, val) -> Double in
            return acc + val
        })
    }
    
    public func sum (to direction: SumDirection) -> SwiftMatrix? {
        
        // TODO: refactor (using new private method to get row and column)
        
        switch direction {
        case .rows:
            
            var results = [Double]()
            
            for i in 0..<self.dimensions.rows {
                let columns = self.dimensions.columns
                let row = Array<Double>(self.values[(i * columns)..<((i + 1) * columns)])
                results.append(row.reduce(0.0, { (acc, val) -> Double in
                    return acc + val
                }))
            }
            
            return SwiftMatrix(results, dimensions: MatrixDimensions(rows: results.count, columns: 1))
            
        case .columns:
            
            var results = [Double]()
            let rows = self.dimensions.rows
            
            func getFilterFunction (_ pos: Int) -> (_ index: Int) -> Bool {
                var next = pos
                let rows = self.dimensions.rows
                return { index in
                    if next == index {
                        next = next + rows
                        return true
                    }
                    return false
                }
            }
            
            for i in 0..<self.dimensions.columns {
                let filter = getFilterFunction(i)
                var index = -1
                let column = self.values.filter { (value) -> Bool in
                    index = index + 1
                    return filter(index)
                }
                results.append(column.reduce(0.0, { (acc, val) -> Double in
                    return acc + val
                }))
            }
            
            return SwiftMatrix(results, dimensions: MatrixDimensions(rows: 1, columns: results.count))
        }
    }
    
    public func log () -> SwiftMatrix? {
        return SwiftMatrix(self.values.map({ (value) -> Double in Darwin.log(value)}), dimensions: self.dimensions)
    }

    public func dotProduct (with matrix: SwiftMatrix) -> SwiftMatrix? {
        
        guard self.dimensions.columns == matrix.dimensions.rows else {
            return nil
        }
        
        var newValues = [Double]()
        let newDimensions = MatrixDimensions(rows: self.dimensions.rows, columns: matrix.dimensions.columns)
        
        for q in 0..<self.dimensions.rows {
            
            guard let row = self.getRow(at: q) else { return nil }
            var newRow = [Double]()
            
            for w in 0..<matrix.dimensions.columns {

                guard let column = matrix.getColumn(at: w) else { return nil }
                guard row.count == column.count else { return nil }
                
                var value = Double(0.0)
                
                for e in 0..<row.count {
                    value = value + (row[e] * column[e])
                }
                
                newRow.append(value)
            }

            newValues = newValues + newRow // Joins arrays
        }
        
        return SwiftMatrix(newValues, dimensions: newDimensions)
    }
}


/// Extensions for private helper functions
extension SwiftMatrix {
    
    private func getRow (at index: Int) -> [Double]? {
        
        guard index <= self.dimensions.rows else {
            return nil
        }
        
        let count = self.dimensions.columns * (index + 1)
        let offset = self.dimensions.columns * index
        
        return Array<Double>(self.values[offset..<count])
    }
    
    private func getColumn (at index: Int) -> [Double]? {
        
        guard index <= self.dimensions.columns else {
            return nil
        }
        
        var values = [Double]()
        let rows = self.dimensions.rows
        let columns = self.dimensions.columns
        
        for i in 0..<rows {
            values.append(self.values[index + (i * columns)])
        }

        return values
    }
}


/// Operator extensions for `Double`
extension SwiftMatrix {
    
    /// Addition operation.
    public static func +(lhs: SwiftMatrix, rhs: Double) -> SwiftMatrix {
        return lhs.addScalar(rhs)
    }
    
    /// Addition operation.
    public static func +(lhs: Double, rhs: SwiftMatrix) -> SwiftMatrix {
        return rhs.addScalar(lhs)
    }
    
    /// Subtraction operation.
    public static func -(lhs: SwiftMatrix, rhs: Double) -> SwiftMatrix {
        return lhs + (-rhs)
    }
    
    /// Subtraction operation.
    public static func -(lhs: Double, rhs: SwiftMatrix) -> SwiftMatrix {
        return lhs + rhs.invertSign()
    }
    
    /// Multiplication operation.
    public static func *(lhs: SwiftMatrix, rhs: Double) -> SwiftMatrix{
        return lhs.multiplyByScalar(rhs)
    }
    
    /// Multiplication operation.
    public static func *(lhs: Double, rhs: SwiftMatrix) -> SwiftMatrix {
        return rhs.multiplyByScalar(lhs)
    }
}


/// Operator extensions for `Matrix`
extension SwiftMatrix {
    
    public static func +(lhs: SwiftMatrix, rhs: SwiftMatrix) -> SwiftMatrix? {
        
        if lhs.dimensions == rhs.dimensions {
            return lhs.addMatrix(rhs)
        }
        
        if let broadcasted = lhs.broadcast(to: rhs.dimensions) {
            return broadcasted.addMatrix(rhs)
        }
        
        if let broadcasted = rhs.broadcast(to: lhs.dimensions) {
            return lhs.addMatrix(broadcasted)
        }
        
        return nil
    }
    
    public static func -(lhs: SwiftMatrix, rhs: SwiftMatrix) -> SwiftMatrix? {
        return lhs + rhs.invertSign()
    }
    
    public static func *(lhs: SwiftMatrix, rhs: SwiftMatrix) -> SwiftMatrix? {
        
        if lhs.dimensions == rhs.dimensions {
            return lhs.multiplyMatrix(rhs)
        }
        
        if let broadcasted = lhs.broadcast(to: rhs.dimensions) {
            return broadcasted.multiplyMatrix(rhs)
        }
        
        if let broadcasted = rhs.broadcast(to: lhs.dimensions) {
            return lhs.multiplyMatrix(broadcasted)
        }
        
        return nil
    }
    
    public static func /(lhs: SwiftMatrix, rhs: SwiftMatrix) -> SwiftMatrix? {
        
        if lhs.dimensions == rhs.dimensions {
            return lhs.divideMatrix(rhs)
        }
        
        if let broadcasted = lhs.broadcast(to: rhs.dimensions) {
            return broadcasted.divideMatrix(rhs)
        }
        
        if let broadcasted = rhs.broadcast(to: lhs.dimensions) {
            return lhs.divideMatrix(broadcasted)
        }
        
        return nil
    }
}


/// Equatable extension for `SwiftMatrix`
extension SwiftMatrix: Equatable {
    
    public static func ==(lhs: SwiftMatrix, rhs: SwiftMatrix) -> Bool {
        return lhs.values == rhs.values && lhs.dimensions == rhs.dimensions
    }
}
