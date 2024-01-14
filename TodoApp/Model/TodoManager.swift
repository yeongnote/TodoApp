import UIKit


class TodoManager {
    static let shared = TodoManager()
    private let userDefaults = UserDefaults.standard
    private let todoKey = "TodoData"
    
    private init() {}
    
    func saveTodos(_ todos: [Todo]) {
        if let encoded = try? JSONEncoder().encode(todos) {
            userDefaults.set(encoded, forKey: todoKey)
        }
    }
    
    func loadTodos() -> [Todo] {
        guard let savedTodos = userDefaults.object(forKey: todoKey) as? Data,
              let loadedTodos = try? JSONDecoder().decode([Todo].self, from: savedTodos) else {
            return []
        }
        return loadedTodos
    }
    
    // 할 일 리스트 중 완료된 항목만 추가하기.
    func loadCompletedTodos() -> [TodoList] {
        let allTodos = loadTodos()
        var completedTodos: [TodoList] = []
        
        for todo in allTodos {
            let completed = todo.list.filter({ $0.isCompleted })
            completedTodos.append(contentsOf: completed)
        }
        
        return completedTodos
    }
}
