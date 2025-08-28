import UIKit

final class TodoListTableViewCell: UITableViewCell {
    private let stateImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(model: TodoDomain) {
        let imageName = model.isCompleted ? Constants.completedImageName : Constants.uncompletedImageName
        stateImageView.image = UIImage(systemName: imageName)
        
        titleLabel.attributedText = getTitle(isCompleted: model.isCompleted, title: model.title)
        descriptionLabel.text = model.description
        dateLabel.text = model.creationDate.getFormattedDate()
        
        updateViewsBy(by: model.isCompleted)
    }
    
}

//MARK: - Helpers

private extension TodoListTableViewCell {
    func getTitle(isCompleted: Bool, title: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: title)
        if isCompleted {
            attributedString.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSRange(location: 0, length: attributedString.length)
            )
        }
        return attributedString
    }
    
    func updateViewsBy(by isCompleted : Bool) {
        stateImageView.tintColor = isCompleted ? Constants.Colors.stateCompleted : Constants.Colors.stateUncompleted
        titleLabel.textColor = isCompleted ? Constants.Colors.textSecondary : Constants.Colors.textPrimary
        descriptionLabel.textColor = isCompleted ? Constants.Colors.textSecondary : Constants.Colors.textPrimary
    }
    
    func setupViews() {
        self.backgroundColor = Constants.Colors.cellBackground
        
        stateImageView.size(Constants.Sizes.stateImage)
        stateImageView.contentMode = .scaleAspectFit
        
        titleLabel.font = .systemFont(ofSize: Constants.Fonts.title, weight: Constants.FontWeights.title)
        descriptionLabel.font = .systemFont(ofSize: Constants.Fonts.subtitle, weight: Constants.FontWeights.subtitle)
        descriptionLabel.numberOfLines = 2
        dateLabel.font = .systemFont(ofSize: Constants.Fonts.date, weight: Constants.FontWeights.date)

        dateLabel.textColor = Constants.Colors.textSecondary
        
        selectionStyle = .none
    }
    
    func setupLayout() {
        let mainView = UIView()
        self.contentView.addSubview(mainView)
        mainView.edgesToSuperview()
        
        let vStack = UIView()
        vStack.stack([titleLabel, descriptionLabel, dateLabel], axis: .vertical, spacing: Constants.Layout.verticalSpacing)
        [stateImageView, vStack].forEach { view in
            mainView.addSubview(view)
        }
        
        stateImageView.topToSuperview(offset: Constants.Layout.stateTop)
        stateImageView.leftToSuperview(offset: Constants.Layout.stateLeft)
        
        vStack.leftToRight(of: stateImageView, offset: Constants.Layout.stackLeftOffset)
        vStack.verticalToSuperview(insets: .vertical(Constants.Layout.stackVerticalInset))
        vStack.rightToSuperview()
    }
    
    func getDateLabelFrom(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.Date.format
        return dateFormatter.string(from: date)
    }
}

//MARK: - Constants

fileprivate enum Constants {
    enum Images {
        static let completed = "checkmark.circle"
        static let uncompleted = "circle"
    }
    
    enum Sizes {
        static let stateImage = CGSize(width: 24, height: 24)
    }
    
    enum Colors {
        static let stateCompleted = UIColor.yellow
        static let stateUncompleted = UIColor.gray
        static let textPrimary = UIColor.white
        static let textSecondary = UIColor.gray
        static let cellBackground = UIColor.black
    }
    
    enum Fonts {
        static let title: CGFloat = 16
        static let subtitle: CGFloat = 12
        static let date: CGFloat = 12
    }
    
    enum FontWeights {
        static let title: UIFont.Weight = .bold
        static let subtitle: UIFont.Weight = .regular
        static let date: UIFont.Weight = .regular
    }
    
    enum Layout {
        static let verticalSpacing: CGFloat = 6
        static let stateTop: CGFloat = 11
        static let stateLeft: CGFloat = 20
        static let stackLeftOffset: CGFloat = 8
        static let stackVerticalInset: CGFloat = 12
    }
    
    enum Date {
        static let format = "dd/MM/yyyy"
    }
    
    enum TableCell {
        static let reuseIdentifier = "\(TodoListTableViewCell.self)"
    }
    
    static let completedImageName = Images.completed
    static let uncompletedImageName = Images.uncompleted
    static let stateImageSize = Sizes.stateImage
}
