import UIKit


class MainViewController: UIViewController {
    
    let TodoButton = UIButton(type: .system)
    let completedButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        TodoButton.addTarget(self, action: #selector(moveButton(_:)), for: .touchUpInside)
        TodoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(TodoButton)
        
        TodoButton.setTitle("할 일 리스트", for: .normal)
        TodoButton.setTitleColor(.systemBlue, for: .normal)
        TodoButton.titleLabel?.textColor = .blue
        
        NSLayoutConstraint.activate([
            TodoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            TodoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            TodoButton.widthAnchor.constraint(equalToConstant: 100),
            TodoButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func moveButton(_ sender: UIButton) {
        let viewController = ViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
       
    }
}



// MARK: -Pre View
import SwiftUI


struct PreView: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: MainViewController()).toPreview()
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
