import Foundation
import CoreData

final class DataManager {
    private let modelName = "TodoModel"
    private let logService = LogService()
    
    private var persistanceContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoModel")
        container.loadPersistentStores { _, error in
            guard let error else { return }
            fatalError("Failed to load persistance stores: \(error.localizedDescription)")
        }
        return container
    }()
    
    func save() {
        do {
            guard context.hasChanges else { return }
            try context.save()
        } catch {
            print("Error while save context: \(error)")
        }
    }
    
    //MARK: TodoModel
    @discardableResult
    func createTodoModel() -> TodoModel {
        guard let entity = NSEntityDescription.entity(forEntityName: modelName, in: context),
              let managedObject = NSManagedObject(entity: entity, insertInto: context) as? TodoModel else { return .init() }
        managedObject.id = maxId + 1
        return managedObject
    }
    
    func fetchAllTodoModel() -> [TodoModel] {
        let fetchRequest = todoModelFetchRequest
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let todoModels = try? context.fetch(fetchRequest)
        return todoModels ?? []
    }
    
    func fetchTodoModel(by id: Int32) -> TodoModel? {
        let fetchRequest = todoModelFetchRequest
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            let todoModel = try context.fetch(fetchRequest).first
            return todoModel
        } catch {
            logService.displayError("Error while fetchTodoModel Todo: \(error)")
        }
        return nil
    }
    
    func fetchLastCreatedTodo() -> TodoModel? {
        let fetchRequest = todoModelFetchRequest
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        fetchRequest.fetchLimit = 1
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            logService.displayError("Error while fetchLastCreatedTodo: \(error)")
        }
        return nil
    }
    
    func deleteTodo(id: Int32) {
        let fetchRequest = todoModelFetchRequest
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            guard let todoModel = try context.fetch(fetchRequest).first else {
                return
            }
            context.delete(todoModel)
            save()
        } catch {
            logService.displayError("Error while deleteTodo: \(error)")
        }
    }
}

//MARK: - Helpers

private extension DataManager {
    
    var context : NSManagedObjectContext {
        let context = persistanceContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    var todoModelFetchRequest: NSFetchRequest<TodoModel> {
        return NSFetchRequest<TodoModel>(entityName: modelName)
    }
    
    var maxId: Int32 {
        let fetchRequest = todoModelFetchRequest
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        fetchRequest.fetchLimit = 1
        do {
            return try context.fetch(fetchRequest).first?.id ?? 0
        } catch {
            logService.displayError("Error while getMaxId: \(error)")
        }
        return -1
    }
    
}
