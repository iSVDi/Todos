import XCTest
@testable import Todos

final class TodoBunchDataTests: XCTestCase {
    
    func testTodoBunchDataDecoding() {
        // Given
        let jsonString = """
        {
            "todos": [
                {
                    "id": 1,
                    "todo": "First todo",
                    "completed": true
                },
                {
                    "id": 2,
                    "todo": "Second todo",
                    "completed": false
                }
            ]
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let todoBunchData = try? JSONDecoder().decode(TodoBunchData.self, from: jsonData)
        
        // Then
        XCTAssertNotNil(todoBunchData)
        XCTAssertEqual(todoBunchData?.todos.count, 2)
        XCTAssertEqual(todoBunchData?.todos[0].id, 1)
        XCTAssertEqual(todoBunchData?.todos[0].description, "First todo")
        XCTAssertEqual(todoBunchData?.todos[0].isCompleted, true)
        XCTAssertEqual(todoBunchData?.todos[1].id, 2)
        XCTAssertEqual(todoBunchData?.todos[1].description, "Second todo")
        XCTAssertEqual(todoBunchData?.todos[1].isCompleted, false)
    }
    
    func testTodoBunchDataDecodingWithEmptyArray() {
        // Given
        let jsonString = """
        {
            "todos": []
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let todoBunchData = try? JSONDecoder().decode(TodoBunchData.self, from: jsonData)
        
        // Then
        XCTAssertNotNil(todoBunchData)
        XCTAssertEqual(todoBunchData?.todos.count, 0)
    }
    
    func testTodoBunchDataDecodingWithSingleTodo() {
        // Given
        let jsonString = """
        {
            "todos": [
                {
                    "id": 1,
                    "todo": "Single todo",
                    "completed": false
                }
            ]
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let todoBunchData = try? JSONDecoder().decode(TodoBunchData.self, from: jsonData)
        
        // Then
        XCTAssertNotNil(todoBunchData)
        XCTAssertEqual(todoBunchData?.todos.count, 1)
        XCTAssertEqual(todoBunchData?.todos[0].id, 1)
        XCTAssertEqual(todoBunchData?.todos[0].description, "Single todo")
        XCTAssertEqual(todoBunchData?.todos[0].isCompleted, false)
    }
}
