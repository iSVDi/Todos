import XCTest
import CoreData
@testable import Todos

final class DataManagerTests: XCTestCase {
    
    var dataManager: DataManager!
    var container: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
        
        container = NSPersistentContainer(name: "TodoModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            XCTAssertNil(error, "Failed to load persistent stores")
        }
        
        dataManager = DataManager()
    }
    
    override func tearDown() {
        dataManager = nil
        container = nil
        super.tearDown()
    }
    
    func testCreateTodoModel() {
        // When
        let todoModel = dataManager.createTodoModel()
        
        // Then
        XCTAssertNotNil(todoModel)
        XCTAssertEqual(todoModel.id, 1)
    }
    
    func testCreateMultipleTodoModels() {
        container.viewContext.reset()
        // When
        let todo1 = dataManager.createTodoModel()
        let todo2 = dataManager.createTodoModel()
        let todo3 = dataManager.createTodoModel()
        
        // Then
        XCTAssertEqual(todo1.id, 1)
        XCTAssertEqual(todo2.id, 2)
        XCTAssertEqual(todo3.id, 3)
    }
    
    func testFetchAllTodoModels() {
        // Given
        let todo1 = dataManager.createTodoModel()
        todo1.title = "First Todo"
        todo1.details = "First Description"
        todo1.isCompleted = false
        todo1.creationDate = Date()
        
        let todo2 = dataManager.createTodoModel()
        todo2.title = "Second Todo"
        todo2.details = "Second Description"
        todo2.isCompleted = true
        todo2.creationDate = Date()
        
        dataManager.save()
        
        // When
        let fetchedTodos = dataManager.fetchAllTodoModel()
        
        // Then
        XCTAssertEqual(fetchedTodos.count, 2)
        XCTAssertEqual(fetchedTodos[0].id, 2)
        XCTAssertEqual(fetchedTodos[1].id, 1)
    }
    
    func testFetchTodoModelById() {
        // Given
        let todo = dataManager.createTodoModel()
        todo.title = "Test Todo"
        todo.details = "Test Description"
        todo.isCompleted = false
        todo.creationDate = Date()
        
        dataManager.save()
        
        // When
        let fetchedTodo = dataManager.fetchTodoModel(by: todo.id)
        
        // Then
        XCTAssertNotNil(fetchedTodo)
        XCTAssertEqual(fetchedTodo?.id, todo.id)
        XCTAssertEqual(fetchedTodo?.title, "Test Todo")
        XCTAssertEqual(fetchedTodo?.details, "Test Description")
        XCTAssertEqual(fetchedTodo?.isCompleted, false)
    }
    
    func testFetchTodoModelByNonExistentId() {
        // When
        let fetchedTodo = dataManager.fetchTodoModel(by: 999)
        
        // Then
        XCTAssertNil(fetchedTodo)
    }
    
    func testFetchLastCreatedTodo() {
        // Given
        let todo1 = dataManager.createTodoModel()
        todo1.title = "First Todo"
        todo1.creationDate = Date().addingTimeInterval(-3600)
        
        let todo2 = dataManager.createTodoModel()
        todo2.title = "Second Todo"
        todo2.creationDate = Date()
        
        dataManager.save()
        
        // When
        let lastTodo = dataManager.fetchLastCreatedTodo()
        
        // Then
        XCTAssertNotNil(lastTodo)
        XCTAssertEqual(lastTodo?.id, 4)
        XCTAssertEqual(lastTodo?.title, "Second Todo")
    }
    
    func testDeleteTodo() {
        // Given
        let todo = dataManager.createTodoModel()
        todo.title = "To Delete"
        dataManager.save()
        
        let initialCount = dataManager.fetchAllTodoModel().count
        XCTAssertEqual(initialCount, 1)
        
        // When
        dataManager.deleteTodo(id: todo.id)
        
        // Then
        let finalCount = dataManager.fetchAllTodoModel().count
        XCTAssertEqual(finalCount, 0)
        
        let deletedTodo = dataManager.fetchTodoModel(by: todo.id)
        XCTAssertNil(deletedTodo)
    }
    
    func testDeleteNonExistentTodo() {
        // Given
        let initialCount = dataManager.fetchAllTodoModel().count
        
        // When
        dataManager.deleteTodo(id: 999)
        
        // Then
        let finalCount = dataManager.fetchAllTodoModel().count
        XCTAssertEqual(finalCount, initialCount)
    }
    
    func testSaveContext() {
        // Given
        let todo = dataManager.createTodoModel()
        todo.title = "Test Todo"
        
        // When
        dataManager.save()
        
        // Then
        let fetchedTodo = dataManager.fetchTodoModel(by: todo.id)
        XCTAssertNotNil(fetchedTodo)
        XCTAssertEqual(fetchedTodo?.title, "Test Todo")
    }
}
