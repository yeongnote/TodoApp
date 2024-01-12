import UIKit
import Foundation

protocol TodoCellDelegate: AnyObject {
    func didToggleSwitch(_ cell: TodoCell)
    func updateTodoStatus(_ cell: TodoCell, _ isCompleted: Bool)
}



class TodoCell: UITableViewCell {
    let toggleSwitch: UISwitch = UISwitch()
    weak var delegate: TodoCellDelegate?

    // 스위치 추가 및 액션 설정
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        accessoryView = toggleSwitch
        toggleSwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func switchToggled(_ sender: UISwitch) {
        delegate?.didToggleSwitch(self)
        delegate?.updateTodoStatus(self, sender.isOn)
    }
}



