
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
    
    var todos = [
        Todo(category: "개인 일정", list: [
                TodoList(title: "아침 운동", isCompleted: false),
                TodoList(title: "점심 약속", isCompleted: false)
            ]),
        Todo(category: "업무 일정", list: [
                TodoList(title: "보고서 작성", isCompleted: false),
                TodoList(title: "회의 참석", isCompleted: false)
            ])
        ]
    
    var tableView: UITableView!
    var addButton: UIBarButtonItem!
    var trashButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView 인스턴스 생성 및 오토레이아웃 설정
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
        
        // 뷰가 로드되는 시점에 데이터 불러오기
        todos = TodoManager.shared.loadTodos()
        
        // 테이블 뷰에 등록할 셀 클래스 등록
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // 네비게이션바 오른쪽에 추가 버튼과 편집 버튼 추가
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapTrashButton))
        navigationItem.rightBarButtonItems = [addButton, trashButton]
        
    }
    
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
    
    // 편집 버튼을 눌렀을 때 호출할 메서드
    @objc func didTapTrashButton() {
        let isEditing = !tableView.isEditing
        tableView.setEditing(isEditing, animated: true)

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        let todoList = todos[indexPath.section].list[indexPath.row]
        cell.textLabel?.text = todoList.title
        cell.accessoryType = todoList.isCompleted ? .checkmark : .none // 완료 여부에 따른 체크 표시
        
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
        if editingStyle == .delete {
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
}


extension ViewController {
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
                self.todos[headerView.sectionIndex].list.append(TodoList(title: todoName, isCompleted: false))
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
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
