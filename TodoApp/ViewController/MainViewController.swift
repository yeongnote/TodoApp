import UIKit


class MainViewController: UIViewController {
    
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "image")
        return imageView
    }()
    
    let todoButton: UIButton = {
        let button = UIButton()
        button.setTitle("할 일 리스트", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    let completButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료된 할 일's", for: .normal)
        button.setTitleColor(.systemCyan, for: .normal)
        return button
    }()
    
    let catButton: UIButton = {
        let button = UIButton()
        button.setTitle("🐾", for: .normal)
        button.setTitleColor(.black , for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubViews()
        makeAutoLayout()
        setUpInteraction()
        
        mainImageView.getImageFromURL(url: "https://spartacodingclub.kr/css/images/scc-og.jpg")
        
    }
    
    private func setUpInteraction() {
        todoButton.addTarget(self, action: #selector(todoMoveTapped(_:)), for: .touchUpInside)
        completButton.addTarget(self, action: #selector(completMoveTapped(_:)), for: .touchUpInside)
        catButton.addTarget(self, action: #selector(catMoveTapped(_:)), for: .touchUpInside)
    }
    
    @objc func todoMoveTapped(_ sender: UIButton) {
        let viewController = TodoViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
       
    }
    
    @objc func completMoveTapped(_ sender: UIButton) {
        let completedTasksController = CompletedTasksController()
        self.navigationController?.pushViewController(completedTasksController, animated: true)
    }
    
    @objc func catMoveTapped(_ sender: UIButton) {
        let catViewController = CatViewController()
        self.navigationController?.pushViewController(catViewController, animated: true)
    }
    
    private func addSubViews() {
        view.addSubview(todoButton)
        view.addSubview(completButton)
        view.addSubview(mainImageView)
        view.addSubview(catButton)
    }
    
    private func makeAutoLayout() {
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
            mainImageView.widthAnchor.constraint(equalToConstant: 300),
            mainImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        todoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            todoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            todoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            todoButton.widthAnchor.constraint(equalToConstant: 100),
            todoButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        completButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            completButton.widthAnchor.constraint(equalToConstant: 150),
            completButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        catButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            catButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            catButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            catButton.widthAnchor.constraint(equalToConstant: 200),
            catButton.heightAnchor.constraint(equalToConstant: 100)
        ])
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
