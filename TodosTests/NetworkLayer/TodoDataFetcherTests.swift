import XCTest
import Moya
@testable import Todos

final class TodoDataFetcherTests: XCTestCase {
    
    func testGetAllTodosConfiguration() {
        // Given
        let endpoint = TodoDataFetcher.getAllTodos
        
        // When & Then
        XCTAssertEqual(endpoint.baseURL.absoluteString, "https://dummyjson.com/todos")
        XCTAssertEqual(endpoint.path, "")
        XCTAssertEqual(endpoint.method, .get)
        XCTAssertEqual(endpoint.headers, [:])
    }
    
    func testBaseURLIsValid() {
        // Given
        let endpoint = TodoDataFetcher.getAllTodos
        
        // When
        let url = endpoint.baseURL
        
        // Then
        XCTAssertNotNil(URL(string: url.absoluteString))
        XCTAssertTrue(url.absoluteString.hasPrefix("https://"))
    }
    
    func testMethodIsGet() {
        // Given
        let endpoint = TodoDataFetcher.getAllTodos
        
        // When
        let method = endpoint.method
        
        // Then
        XCTAssertEqual(method, .get)
    }
    
    func testHeadersAreEmpty() {
        // Given
        let endpoint = TodoDataFetcher.getAllTodos
        
        // When
        let headers = endpoint.headers
        
        // Then
        XCTAssertEqual(headers, [:])
    }
    
    func testPathIsEmpty() {
        // Given
        let endpoint = TodoDataFetcher.getAllTodos
        
        // When
        let path = endpoint.path
        
        // Then
        XCTAssertEqual(path, "")
    }
}
