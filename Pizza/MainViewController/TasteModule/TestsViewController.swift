import UIKit

final class TestsViewController: UIViewController {

    private let allTopics = TestCatalog.all
    private var filtered: [QuizTopic] = TestCatalog.all
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.background
        navigationItem.title = "All Tests"
        setupSearch()
        setupCollectionView()
    }

    private func setupSearch() {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search..."
        search.searchResultsUpdater = self
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv in
            // Первая карточка на весь экран (Featured), остальные по 2 в ряд
            let isLarge = false // Можно сделать true для заглавной карточки
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(110) // Компактная горизонтальная карточка
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 1 // По 1 карточке в ряд для чистой горизонтальной верстки
            )

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 12
            section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 24, trailing: 16)
            return section
        }

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TestCell.self, forCellWithReuseIdentifier: TestCell.reuseID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Search
extension TestsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = (searchController.searchBar.text ?? "").trimmingCharacters(in: .whitespaces)
        filtered = query.isEmpty ? allTopics : allTopics.filter { $0.title.localizedCaseInsensitiveContains(query) }
        collectionView.reloadData()
    }
}

// MARK: - DataSource & Delegate
extension TestsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filtered.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCell.reuseID, for: indexPath) as! TestCell
        cell.configure(with: filtered[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = QuizViewController(topic: filtered[indexPath.item])
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Modern Horizontal Cell Layout
final class TestCell: UICollectionViewCell {

    static let reuseID = "TestCell"

    private let logoView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let badge = UILabel()
    private let textStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func build() {
        Theme.applyCardStyle(to: contentView)
        contentView.clipsToBounds = true

        // 1. Иконка / Логотип слева
        logoView.contentMode = .scaleAspectFit
        logoView.layer.cornerRadius = 12
        logoView.clipsToBounds = true
        logoView.backgroundColor = Theme.background

        // 2. Текстовый стек
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = Theme.ink
        titleLabel.numberOfLines = 2

        subtitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1

        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.alignment = .leading
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(subtitleLabel)

        // 3. Компактный бейдж
        badge.text = "START"
        badge.font = .systemFont(ofSize: 10, weight: .bold)
        badge.textColor = Theme.ink
        badge.backgroundColor = Theme.accent
        badge.textAlignment = .center
        badge.layer.cornerRadius = 8
        badge.clipsToBounds = true

        [logoView, textStack, badge].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            // Картинка слева квадратная
            logoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            logoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoView.widthAnchor.constraint(equalToConstant: 80),
            logoView.heightAnchor.constraint(equalToConstant: 80),

            // Бейдж справа вверху
            badge.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            badge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            badge.widthAnchor.constraint(equalToConstant: 54),
            badge.heightAnchor.constraint(equalToConstant: 20),

            // Текстовый блок по центру между лого и бейджем
            textStack.leadingAnchor.constraint(equalTo: logoView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: badge.leadingAnchor, constant: -8),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(with topic: QuizTopic) {
        logoView.image = UIImage(named: topic.imageAsset)
        titleLabel.text = topic.title
        subtitleLabel.text = topic.subtitle
    }
}
