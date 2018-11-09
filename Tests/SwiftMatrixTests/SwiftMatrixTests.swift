import XCTest
@testable import SwiftMatrix

final class SwiftMatrixTests: XCTestCase {
    
    func testInitialization () {
        
        // TODO: test all init options

        let matrix = SwiftMatrix([[0, 0], [2, 3]])
        XCTAssertEqual(matrix.values.count, 4)
    }
    
    func testPublicFunctions () {
        
        // Should work
        let matrix = SwiftMatrix([[0.0, 0.0], [2.1, 3.3]])
        let dimension = MatrixDimensions(rows: 2, columns: 4)
        let broadcasted = matrix.broadcast(to: dimension)
        XCTAssertNotNil(broadcasted)
        
        // Should work as well
        let dimension2 = MatrixDimensions(rows: 4, columns: 2)
        let broadcasted2 = matrix.broadcast(to: dimension2)
        XCTAssertNotNil(broadcasted2)
        
        // Should not work
        let dimension3 = MatrixDimensions(rows: 2, columns: 3)
        let broadcasted3 = matrix.broadcast(to: dimension3)
        XCTAssertNil(broadcasted3)
        
        // Should not work either
        let dimension4 = MatrixDimensions(rows: 3, columns: 3)
        let broadcasted4 = matrix.broadcast(to: dimension4)
        XCTAssertNil(broadcasted4)
        
        let sum = matrix.sum()
        XCTAssertEqual(sum, 5.4)
        
        let matrix2 = SwiftMatrix([[0.8, 1.2], [2.1, 3.3]])
        
        let directionalSumRowsValues = matrix2.sum(to: .rows)!.values
        let directionalSumColumnsValues = matrix2.sum(to: .columns)!.values
        XCTAssertEqual(directionalSumRowsValues[1], 5.4)
        XCTAssertEqual(directionalSumColumnsValues[1], 4.5)
        
        // Logarithm function
        let logMatrixValues = matrix2.log()!.values
        XCTAssertEqual(logMatrixValues[2], 0.7419373447293773)
        
        let m = SwiftMatrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
        let m2 = SwiftMatrix([[1.0, 2.0], [3.0, 4.0]])
        
        // Dot product
        let dottedMatrixValues = m.dotProduct(with: m2)!.values
        let expectedDottedValues: [Double] = [7, 10, 15, 22, 23, 34]
        XCTAssertEqual(dottedMatrixValues, expectedDottedValues)
    }

    func testDoubleOperators () {
        
        let matrix = SwiftMatrix([[10.0, 12.3, 0.34], [0.1, 0.2, 1.2]])
        
        let addValues = (matrix + 2.0).values
        XCTAssertEqual(addValues[0], 12.0)
        
        let subtractValues = (matrix - 2.0).values
        XCTAssertEqual(subtractValues[0], 8.0)
        
        let multiplyValues = (matrix * 2.0).values
        XCTAssertEqual(multiplyValues[0], 20.0)
        
        let invertedValues = (matrix.invertSign()).values
        XCTAssertEqual(invertedValues[0], -10.0)
    }
    
    func testMatrixOperators () {
        
        let matrix  = SwiftMatrix([[8.0, 5.3], [2.5, 1.2]])
        let matrix2 = SwiftMatrix([[13.1, 1.98], [2.2, 0.87]])
        
        let matrix3 = SwiftMatrix([[13.1, 1.98, 2.2, 0.87], [2.2, 0.87, 1.2, 3.76]])
        
        let addedValues = (matrix + matrix2)!.values
        XCTAssertEqual(addedValues[0], 21.1)
        
        let addedValues2 = (matrix + matrix3)!.values
        XCTAssertEqual(addedValues2.count, 8)
        XCTAssertEqual(addedValues2[0], 21.1)
        
        let subtractedValues = (matrix - matrix2)!.values
        XCTAssertEqual(subtractedValues[0], -5.1)
        
        let multipliedValues = (matrix * matrix2)!.values
        XCTAssertEqual(multipliedValues[0], 104.8)

        let multipliedValues2 = (matrix * matrix3)!.values
        XCTAssertEqual(multipliedValues2.count, 8)
        XCTAssertEqual(multipliedValues2[0], 104.8)
        
        let dividedValues = (matrix2 / matrix)!.values
        XCTAssertEqual(dividedValues[0], 1.6375)
    }
    
    func testEquatable () {
        
        let matrix  = SwiftMatrix([[1.0, 2.3], [2.5, 1.2]])
        let matrix2 = SwiftMatrix([[1.0, 2.3], [2.5, 1.2]])
        let matrix3 = SwiftMatrix([[1.0, 2.3], [2.5, 1.2], [0.0, 1.2]])
        
        XCTAssertTrue(matrix == matrix2)
        XCTAssertFalse(matrix == matrix3)
    }

    static var allTests = [
        ("testInitialization", testInitialization),
        ("testDoubleOperators", testDoubleOperators),
        ("testMatrixOperators", testMatrixOperators),
        ("testPublicFunctions", testPublicFunctions),
        ("testEquatable", testEquatable)
    ]
}
