import UIKit


class CompletedTasksController: UIViewController {
    
    var tableView: UITableView!
    
    var completedTodos: [TodoList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView = UITableView()
        
        tableView.register(TodoCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        loadCompletedTodos()
    }
    
    func loadCompletedTodos() {
        completedTodos = TodoManager.shared.loadCompletedTodos()
        
        tableView.reloadData()
    }
    
}

extension CompletedTasksController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TodoCell else {
            fatalError("Unable to dequeue a TodoCell.")
        }
        let todo = completedTodos[indexPath.row]
        
        cell.configure(with: todo.title, isCompleted: todo.isCompleted)
        
        return cell
    }
    
    
    
}



