
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
}


class ViewController: UIViewController {
    
    var todos = [Todo]()
    
    var tableView: UITableView!
    var addButton: UIBarButtonItem!
    var trashButton: UIBarButtonItem!
    var switchToggled: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView 인스턴스 생성 및 오토레이아웃 설정
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
        
        // 뷰가 로드되는 시점에 데이터 불러오기
        todos = TodoManager.shared.loadTodos()
        
        // 테이블 뷰에 등록할 셀 클래스 등록
        tableView.register(TodoCell.self, forCellReuseIdentifier: "TodoCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // 네비게이션바 오른쪽에 추가 버튼과 편집 버튼 추가
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapTrashButton))
        navigationItem.rightBarButtonItems = [addButton, trashButton]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 뷰가 나타나기 전에 데이터 불러오기
        todos = TodoManager.shared.loadTodos()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 뷰가 사라지는 시점에 데이터 저장
        TodoManager.shared.saveTodos(todos)
    }
    
    // Todo 생성
    func createTodo(category: String, list: [TodoList]) {
        let newTodo = Todo(category: category, list: list)
        todos.append(newTodo)
        TodoManager.shared.saveTodos(todos)
    }
    
    // Todo 수정
    func updateTodo(at index: Int, category: String, list: [TodoList]) {
        todos[index].category = category
        todos[index].list = list
        TodoManager.shared.saveTodos(todos)
    }
    
    // Todo 삭제
    func deleteTodo(at index: Int) {
        todos.remove(at: index)
        TodoManager.shared.saveTodos(todos)
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 섹션 수 반환
    func numberOfSections(in tableView: UITableView) -> Int {
        return todos.count
    }
    
    // 섹션별 행 수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos[section].list.count
    }
    
    // 셀 반환
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? TodoCell else {
            fatalError("Unable to dequeue a cell with identifier TodoCell")
        }
        
        let todoList = todos[indexPath.section].list[indexPath.row]
        
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: todoList.title)
        
        // 할 일이 완료되었을 경우 취소선 적용
        if todoList.isCompleted {
            // 할 일이 완료되었을 경우 취소선 적용
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        } else {
            // 할 일이 완료되지 않았을 경우 취소선 제거
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        }
        
        cell.toggleSwitch.isOn = todoList.isCompleted
        cell.delegate = self
        cell.textLabel?.attributedText = attributeString
        cell.accessoryType = todoList.isCompleted ? .checkmark : .none // 완료 여부에 따른 체크 표시
        //셀 태그에 섹션과 로우 인덱스 저장
        cell.tag = indexPath.section * 1000 + indexPath.row
        
        return cell
    }
    
    // 섹션 제목 반환
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return todos[section].category
    }
    
    // 섹션 헤더 반환
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SectionHeaderView()
        headerView.sectionIndex = section
        headerView.titleLabel.text = todos[section].category
        headerView.addButton.addTarget(self, action: #selector(didTapAddButtonInSection(_:)), for: .touchUpInside)
        
        return headerView
    }
    
    // 섹션 헤더 높이 반환
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    // 셀 편집 가능한지 결정
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 할 일 리스트가 하나 남았을 때 삭제를 진행하면 카테고리도 같이 사라지도록 구현
        if todos[indexPath.section].list.count == 1 {
            todos.remove(at: indexPath.section)
            tableView.deleteSections([indexPath.section], with: .fade)
        } else {
            todos[indexPath.section].list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}


extension ViewController {
    
    // 추가 버튼을 눌렀을 때 호출할 메서드
    @objc func didTapAddButton() {
        let alert = UIAlertController(title: "새 카테고리 추가", message: "새로운 카테고리의 이름을 입력해주세요.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "카테고리 이름"
        }
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            if let categoryName = alert.textFields?.first?.text, !categoryName.isEmpty {
                self.createTodo(category: categoryName, list: [])
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // 섹션별 '+' 버튼을 눌렀을 때 호출할 메서드
    @objc func didTapAddButtonInSection(_ sender: UIButton) {
        guard let headerView = sender.superview as? SectionHeaderView else { return }
        
        let alert = UIAlertController(title: "새 할 일 추가", message: "새로운 할 일의 이름을 입력해주세요.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "할 일 이름"
        }
        
         let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            if let todoName = alert.textFields?.first?.text, !todoName.isEmpty {
                let newTodo = TodoList(title: todoName, isCompleted: false)
                self.todos[headerView.sectionIndex].list.append(TodoList(title: todoName, isCompleted: false))
                self.tableView.reloadData()
                
                TodoManager.shared.saveTodos(self.todos)
                print("새로 추가된 할 일: \(newTodo.title)")
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // 휴지통 버튼을 눌렀을 때 호출할 메서드
    @objc func didTapTrashButton() {
        let isEditing = !tableView.isEditing
        tableView.setEditing(isEditing, animated: true)

    }
    
    @objc func switchToggled(_ sender: UISwitch) {
        // 스위치 태그로부터 섹션과 로우 인덱스 추출
        if let cell = sender.superview?.superview as? UITableViewCell {
            let section = cell.tag / 1000
            let row = cell.tag % 1000
            
            
            var todoList = todos[section].list[row]
            todoList.isCompleted = sender.isOn
            TodoManager.shared.saveTodos(todos)
            tableView.reloadData()
        }
        
    }
}

extension ViewController: TodoCellDelegate {
    func updateTodoStatus(_ cell: TodoCell, _ isCompleted: Bool) {
        if let indexPath = tableView.indexPath(for: cell) {
            todos[indexPath.section].list[indexPath.row].isCompleted = isCompleted
            tableView.reloadData()
        }
    }
    
    func didToggleSwitch(_ cell: TodoCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            var todoList = todos[indexPath.section].list[indexPath.row]
            todoList.isCompleted = cell.toggleSwitch.isOn
        }
    }
}

// MARK: -Pre View
import SwiftUI


struct PreView: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: ViewController()).toPreview()
    }
}


#if DEBUG
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
            let viewController: UIViewController

            func makeUIViewController(context: Context) -> UIViewController {
                return viewController
            }

            func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            }
        }

        func toPreview() -> some View {
            Preview(viewController: self)
        }
}
#endif
