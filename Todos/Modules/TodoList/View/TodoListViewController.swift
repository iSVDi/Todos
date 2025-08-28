import UIKit
import TinyConstraints

final class TodoListViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let toolBar = UIToolbar()
    private var toolbarLabel: UILabel?
    
    private let operationQueue = OperationQueue()
    var presenter: TodoListViewOutput?
    
    override func viewDidLoad() {
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.handleViewWillAppear()
    }
    
}

//MARK: - TodoListViewInput

extension TodoListViewController: TodoListViewInput {
    var navController: UINavigationController? {
        return self.navigationController
    }
    
    func reloadRow(at id: Int) {
        mainQueue { [weak self] in
            let indexPaths = [IndexPath(row: id, section: Constants.Table.sectionCount)]
            self?.tableView.reloadRows(at: indexPaths, with: .none)
        }
    }
    
    func reloadTableView() {
        mainQueue { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func setupToolBarTitle(_ title: String) {
        mainQueue { [weak self] in
            self?.toolbarLabel?.text = title
            self?.toolbarLabel?.sizeToFit()
        }
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Constants.Table.sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfRows ?? Constants.Table.defaultCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let todo = presenter?.getTodo(by: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier:  Constants.Table.reusableCell),
              let todoCell = cell as? TodoListTableViewCell else { return UITableViewCell() }
        todoCell.setupData(model: todo)
        return todoCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter,
              let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Table.reusableCell),
              let _ = cell as? TodoListTableViewCell else {
            return
        }
        presenter.didTapCell(cellId: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let actionProvider: UIContextMenuActionProvider = { _ in
            let editAction: UIMenuElement = UIAction(title: Constants.Strings.menuEdit) { [weak self] _ in
                self?.presenter?.editTodo(cellId: indexPath.row)
            }
            
            let deleteAction: UIMenuElement = UIAction(title: Constants.Strings.menuDelete) { [weak self] _ in
                self?.presenter?.deleteTodo(cellId: indexPath.row)
            }
            
            let menu = UIMenu(
                title: "",
                image: nil,
                identifier: nil,
                children: [editAction, deleteAction]
            )
            return menu
        }
        return UIContextMenuConfiguration(actionProvider: actionProvider)
    }
    
}

//MARK: - UISearchResultsUpdating

extension TodoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let presenter,
              let text = searchController.searchBar.text else { return }
        presenter.searchBy(text: text)
    }
    
}

//MARK: - Helpers

private extension TodoListViewController {
    func setupViews() {
        setupAppearance()
        setupTableView()
        setupSearchBar()
        setupToolbar()
    }
    
    func setupAppearance() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithTransparentBackground()
        standardAppearance.largeTitleTextAttributes = [.foregroundColor: Constants.Colors.textPrimary]
        standardAppearance.titleTextAttributes = [.foregroundColor: Constants.Colors.textPrimary]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = standardAppearance
        navigationItem.title = Constants.Strings.navigationBar
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = Constants.Layout.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(TodoListTableViewCell.self, forCellReuseIdentifier: Constants.Table.reusableCell)
        tableView.backgroundColor = Constants.Colors.tableBackground
        tableView.separatorColor = Constants.Colors.separator
    }
    
    func setupSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let searchTextField = navigationItem.searchController?.searchBar.searchTextField
        searchTextField?.textColor = Constants.Colors.textPrimary
        searchTextField?.attributedPlaceholder = NSAttributedString(
            string: Constants.Strings.searchPlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor: Constants.Colors.textSecondary]
        )
        searchTextField?.backgroundColor = Constants.Colors.searchBackground
        (searchTextField?.leftView as? UIImageView)?.tintColor = Constants.Colors.textSecondary
    }
    
    func setupToolbar() {
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let textLabel = UILabel()
        textLabel.textColor = Constants.Colors.textPrimary
        toolbarLabel = textLabel
        let textButton = UIBarButtonItem(customView: textLabel)
        
        let addButton = UIBarButtonItem(
            image: UIImage(systemName: Constants.Images.add),
            style: .plain,
            target: self,
            action: #selector(addButtonHandler)
        )
        addButton.tintColor = Constants.Colors.toolbarTint
        toolBar.barTintColor = Constants.Colors.toolbarBarTint
        toolBar.setItems([spaceButton, textButton, spaceButton, addButton], animated: false)
    }
    
    
    func setupConstraints() {
        view.addSubview(toolBar)
        toolBar.horizontalToSuperview()
        toolBar.bottomToSuperview(usingSafeArea: true)
        toolBar.height(Constants.Layout.toolbarHeight)
        
        view.addSubview(tableView)
        tableView.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        tableView.bottomToTop(of: toolBar)
    }
    
    func mainQueue(_ task: @escaping () -> Void) {
        OperationQueue.main.addOperation(task)
    }
    
    @objc
    func addButtonHandler() {
        presenter?.handleCreateTodoTap()
    }
}

//MARK: - Constants

fileprivate enum Constants {
    enum Strings {
        static let navigationBar = "Todos"
        static let searchPlaceholder = "Search"
        static let menuEdit = "Edit"
        static let menuDelete = "Delete"
    }
    
    enum Colors {
        static let textPrimary = UIColor.white
        static let textSecondary = UIColor.gray
        static let tableBackground = UIColor.black
        static let separator = UIColor.systemGray3
        static let searchBackground = UIColor(red: 39/255, green: 39/255, blue: 41/255, alpha: 1)
        static let toolbarTint = UIColor.yellow
        static let toolbarBarTint = UIColor.black
    }
    
    enum Images {
        static let add = "square.and.pencil"
    }
    
    enum Layout {
        static let estimatedRowHeight: CGFloat = 106
        static let toolbarHeight: CGFloat = 49
    }
    
    enum Table {
        static let sectionCount: Int = 1
        static let defaultCellCount: Int = 0
        static let reusableCell = "\(TodoListTableViewCell.self)"
    }
}
