import UIKit

struct Todo: Codable {
    var category: String
    var list: [TodoList]
}

struct TodoList: Codable {
    var title: String
    var isCompleted: Bool
}
