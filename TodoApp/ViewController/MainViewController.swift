import UIKit


class MainViewController: UIViewController {
    
    let todoButton = UIButton(type: .system)
    let completButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        todoButton.addTarget(self, action: #selector(todoMoveTapped(_:)), for: .touchUpInside)
        completButton.addTarget(self, action: #selector(completMoveTapped(_:)), for: .touchUpInside)
        
        todoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(todoButton)
        
        completButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(completButton)
        
        todoButton.setTitle("할 일 리스트", for: .normal)
        completButton.setTitle("완료된 할 일", for: .normal)
        
        
        NSLayoutConstraint.activate([
            todoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            todoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            todoButton.widthAnchor.constraint(equalToConstant: 100),
            todoButton.heightAnchor.constraint(equalToConstant: 50),
            
            completButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            completButton.widthAnchor.constraint(equalToConstant: 100),
            completButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func todoMoveTapped(_ sender: UIButton) {
        let viewController = ViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
       
    }
    
    @objc func completMoveTapped(_ sender: UIButton) {
        let completedTasksController = CompletedTasksController()
        self.navigationController?.pushViewController(completedTasksController, animated: true)
    }
}




