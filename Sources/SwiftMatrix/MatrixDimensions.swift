import Foundation


/// Type used to describe dimensions of a Matrix
public struct MatrixDimensions {
    
    /// Transpose operation
    public var T: MatrixDimensions {
        return MatrixDimensions(rows: columns, columns: rows)
    }
    
    public let rows   : Int
    public let columns: Int
    
    public init (rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
    }
    
    /// Count of all elements in Matrix
    public var elements: Int {
        get {
            return rows * columns
        }
    }
}


extension MatrixDimensions: Equatable {
    
    /// Enables MatrixDimensions to be compared using `==` operator
    public static func ==(lhs: MatrixDimensions, rhs: MatrixDimensions) -> Bool {
        return lhs.rows == rhs.rows && lhs.columns == rhs.columns
    }
}
