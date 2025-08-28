import Foundation
import UIKit

final class TodoDetailsViewController: UIViewController {
    private let titleField = UITextField()
    private let dateLabel = UILabel()
    private let datePicker = UIDatePicker()
    private let textView = UITextView()
    
    var presenter: TodoDetailsViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
        presenter?.handleViewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let title = titleField.text, let description = textView.text else { return }
        let todoDetailsModel = TodoDetails(title: title, description: description)
        presenter?.handleViewWillDissapepar(todoDetailsModel)
    }
    
}

//MARK: - TodoDetailsViewInput

extension TodoDetailsViewController: TodoDetailsViewInput {
    func setupData(todo: TodoDomain) {
        OperationQueue.main.addOperation { [weak self] in
            guard let self else { return }
            titleField.text = todo.title
            dateLabel.text = todo.creationDate.getFormattedDate()
            textView.text = todo.description
        }
    }
    
}

//MARK: - TodoDetailsViewController

private extension TodoDetailsViewController {
    func setupViews() {
        navigationController?.navigationBar.tintColor = Constants.Colors.navigationTint
        self.navigationItem.largeTitleDisplayMode = Constants.Navigation.largeTitleDisplayMode
        
        view.backgroundColor = Constants.Colors.viewBackground
        titleField.textColor = Constants.Colors.textPrimary
        titleField.font = UIFont.systemFont(ofSize: Constants.Font.titleSize, weight: Constants.Font.titleWeight)

        dateLabel.textColor = Constants.Colors.textSecondary
        dateLabel.font = UIFont.systemFont(ofSize: Constants.Font.dateSize)
        
        textView.textColor = Constants.Colors.textPrimary
        textView.backgroundColor = Constants.Colors.textViewBackground
        textView.font = UIFont.systemFont(ofSize: Constants.Font.bodySize)
        ///This ensures the UITextView resizes itself based on its content.
        textView.isScrollEnabled = false
    }
    
    func setupLayout() {
        [titleField, dateLabel, textView].forEach {
            view.addSubview($0)
            $0.horizontalToSuperview(insets: .horizontal(Constants.Layout.horizontalInset))
        }
        
        titleField.topToSuperview(offset: Constants.Layout.smallSpacing, usingSafeArea: true)
        dateLabel.topToBottom(of: titleField, offset: Constants.Layout.smallSpacing)
        textView.topToBottom(of: dateLabel, offset: Constants.Layout.mediumSpacing)
    }
    
}

//MARK: - Constants

fileprivate enum Constants {
    enum Colors {
        static let navigationTint = UIColor.yellow
        static let viewBackground = UIColor.black
        static let textPrimary = UIColor.white
        static let textSecondary = UIColor.gray
        static let textViewBackground = UIColor.clear
    }
    
    enum Font {
        static let titleSize: CGFloat = 34
        static let titleWeight: UIFont.Weight = .bold
        static let dateSize: CGFloat = 12
        static let bodySize: CGFloat = 16
    }
    
    enum Layout {
        static let horizontalInset: CGFloat = 16
        static let smallSpacing: CGFloat = 8
        static let mediumSpacing: CGFloat = 16
    }
    
    enum Navigation {
        static let largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode = .never
    }
}
