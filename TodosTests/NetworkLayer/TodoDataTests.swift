import XCTest
@testable import Todos

final class TodoDataTests: XCTestCase {
    
    func testTodoDataDecoding() {
        // Given
        let jsonString = """
        {
            "id": 1,
            "todo": "Test todo description",
            "completed": true
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let todoData = try? JSONDecoder().decode(TodoData.self, from: jsonData)
        
        // Then
        XCTAssertNotNil(todoData)
        XCTAssertEqual(todoData?.id, 1)
        XCTAssertEqual(todoData?.description, "Test todo description")
        XCTAssertEqual(todoData?.isCompleted, true)
    }
    
    func testTodoDataDecodingWithFalseCompleted() {
        // Given
        let jsonString = """
        {
            "id": 2,
            "todo": "Another todo",
            "completed": false
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let todoData = try? JSONDecoder().decode(TodoData.self, from: jsonData)
        
        // Then
        XCTAssertNotNil(todoData)
        XCTAssertEqual(todoData?.id, 2)
        XCTAssertEqual(todoData?.description, "Another todo")
        XCTAssertEqual(todoData?.isCompleted, false)
    }
    
    func testTodoDataDecodingWithZeroId() {
        // Given
        let jsonString = """
        {
            "id": 0,
            "todo": "Zero ID todo",
            "completed": false
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let todoData = try? JSONDecoder().decode(TodoData.self, from: jsonData)
        
        // Then
        XCTAssertNotNil(todoData)
        XCTAssertEqual(todoData?.id, 0)
        XCTAssertEqual(todoData?.description, "Zero ID todo")
        XCTAssertEqual(todoData?.isCompleted, false)
    }
    
    func testTodoDataDecodingWithEmptyDescription() {
        // Given
        let jsonString = """
        {
            "id": 3,
            "todo": "",
            "completed": true
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let todoData = try? JSONDecoder().decode(TodoData.self, from: jsonData)
        
        // Then
        XCTAssertNotNil(todoData)
        XCTAssertEqual(todoData?.id, 3)
        XCTAssertEqual(todoData?.description, "")
        XCTAssertEqual(todoData?.isCompleted, true)
    }
}


