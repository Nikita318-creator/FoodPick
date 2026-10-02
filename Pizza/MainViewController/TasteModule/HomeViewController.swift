import UIKit

// MARK: - Models & Theme
struct Spot {
    let name: String
    let category: String
    let imageName: String
    let tag: String
    let description: String
    let topic: QuizTopic?
}

enum Theme {
    // MARK: - Main Palette
    static let background     = UIColor(red: 0.08, green: 0.07, blue: 0.07, alpha: 1.0)
    static let cardBackground = UIColor(red: 0.14, green: 0.13, blue: 0.13, alpha: 1.0)
    static let primaryOrange  = UIColor(red: 1.00, green: 0.35, blue: 0.22, alpha: 1.0)

    // MARK: - Text Colors
    static let textPrimary    = UIColor.white
    static let textSecondary  = UIColor(red: 0.70, green: 0.70, blue: 0.72, alpha: 1.0)
    static let tagYellow      = UIColor(red: 0.98, green: 0.80, blue: 0.20, alpha: 1.0)

    // MARK: - Quiz Theme Adjustments
    // ink теперь ярко-желтый/золотой.
    // 1. На темном фоне экрана (вопрос, фидбек) — ярко горит и идеально читается.
    // 2. На белых кнопках ответов — дает мощный контраст и четко виден.
    // 3. На кнопке Next (фон ink, текст белый) — дает яркую заметную кнопку с белым текстом.
    static let ink       = UIColor(red: 0.95, green: 0.60, blue: 0.00, alpha: 1.0)
    
    static let accent    = UIColor(red: 1.00, green: 0.35, blue: 0.22, alpha: 1.0)
    static let card      = UIColor(red: 0.14, green: 0.13, blue: 0.13, alpha: 1.0)
    static let border    = UIColor(red: 0.28, green: 0.26, blue: 0.26, alpha: 1.0)
    
    // Результаты ответов
    static let correct   = UIColor(red: 0.16, green: 0.65, blue: 0.35, alpha: 1.0)
    static let wrong     = UIColor(red: 0.85, green: 0.25, blue: 0.25, alpha: 1.0)

    static func applyCardStyle(to view: UIView, cornerRadius: CGFloat = 16) {
        view.backgroundColor = card
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = 1.0
        view.layer.borderColor = border.cgColor
    }
}

// MARK: - Banner Header View
final class TriviaInfoBannerView: UIView {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        backgroundColor = Theme.primaryOrange.withAlphaComponent(0.12)
        layer.cornerRadius = 14
        layer.borderWidth = 1
        layer.borderColor = Theme.primaryOrange.withAlphaComponent(0.3).cgColor
        
        iconImageView.image = UIImage(systemName: "gamecontroller.fill")
        iconImageView.tintColor = Theme.primaryOrange
        iconImageView.contentMode = .scaleAspectFit
        
        titleLabel.text = "Restaurant Lore & Trivia Quiz"
        titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        titleLabel.textColor = Theme.textPrimary
        
        subtitleLabel.text = "Pick your favorite spot below to unlock its trivia challenges and test your knowledge!"
        subtitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        subtitleLabel.textColor = Theme.textSecondary
        subtitleLabel.numberOfLines = 0
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        
        [iconImageView, textStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            
            textStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            textStack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            textStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}

// MARK: - HomeViewController
final class HomeViewController: UIViewController {

    private let bannerView = TriviaInfoBannerView()
    private var collectionView: UICollectionView!
    private let sections = TestCatalog.homeSections
    
    private var featuredSpots: [Spot] = []
    private var allSpots: [Spot] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.background
        setupData()
        setupNavigationBar()
        setupLayout()
    }

    private func setupData() {
        let defaultTopics = sections.flatMap { $0.topics }
        
        let spotData: [(String, String, String, String, String)] = [
            ("Marco's Pizza", "Pizza Trivia", "Marco's Pizza", "Classic Lore", "Classic Italian-style pies topped with Marco's three-cheese blend"),
            ("Dave's Hot Chicken", "Chicken Trivia", "Dave's Hot Chicken", "Hot Spice Challenge", "Nashville hot tenders and sliders, from no spice up to Reaper"),
            ("Jet's Pizza", "Pizza Trivia", "Jet's Pizza", "Detroit Style Lore", "Detroit-style squares with caramelized cheese edges, plus wings"),
            ("Giordano's", "Pizza Trivia", "Giordano's", "Deep Dish Quiz", "Famous Chicago stuffed deep dish, baked fresh to order"),
            ("Wing Snob", "Wings Trivia", "Wing Snob", "Flavor Quest", "Bone-in and boneless wings, tenders and seasoned fries"),
            ("Anthony's Coal Fired Pizza & Wings", "Pizza & Wings", "Anthony's Coal Fired Pizza & Wings", "Coal Oven History", "Well-done pizza from a 900° coal oven and big charred wings"),
            ("Dewey's Pizza", "Pizza Trivia", "Dewey's Pizza", "Craft Knowledge", "Craft pizzas, big salads and calzones built your way"),
            ("Dion's", "Pizza & Subs Trivia", "Dion's", "Regional Favorites", "New Mexico favorite for scratch-made pizza, subs and salads")
        ]
        
        allSpots = spotData.enumerated().map { index, item in
            let topic = index < defaultTopics.count ? defaultTopics[index] : defaultTopics.first
            return Spot(name: item.0, category: item.1, imageName: item.2, tag: item.3, description: item.4, topic: topic)
        }
        
        featuredSpots = Array(allSpots.prefix(3))
    }

    private func setupNavigationBar() {
        let titleLabel = UILabel()
        let attributedText = NSMutableAttributedString(
            string: "Hungry for Quiz? ",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 22), .foregroundColor: Theme.textPrimary]
        )
        let italicText = NSAttributedString(
            string: "Pick a spot.",
            attributes: [.font: UIFont.italicSystemFont(ofSize: 22), .foregroundColor: Theme.primaryOrange]
        )
        attributedText.append(italicText)
        titleLabel.attributedText = attributedText
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }

    private func setupLayout() {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(FeaturedCardCell.self, forCellWithReuseIdentifier: FeaturedCardCell.reuseID)
        collectionView.register(GridSpotCell.self, forCellWithReuseIdentifier: GridSpotCell.reuseID)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseID)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func makeLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            if sectionIndex == 0 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(240), heightDimension: .absolute(230)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.interGroupSpacing = 14
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 20, trailing: 16)
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36)),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]
                return section
            } else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(260)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(260)), subitems: [item, item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 10, bottom: 20, trailing: 10)
                return section
            }
        }
    }
}

// MARK: - DataSource & Delegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 2 }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? featuredSpots.count : allSpots.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCardCell.reuseID, for: indexPath) as! FeaturedCardCell
            cell.configure(with: featuredSpots[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridSpotCell.reuseID, for: indexPath) as! GridSpotCell
            cell.configure(with: allSpots[indexPath.item])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseID, for: indexPath) as! SectionHeaderView
        header.configure(title: "Featured Challenges")
        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let spot = indexPath.section == 0 ? featuredSpots[indexPath.item] : allSpots[indexPath.item]
        if let topic = spot.topic {
            let vc = QuizViewController(topic: topic)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - Custom Cells
final class FeaturedCardCell: UICollectionViewCell {
    static let reuseID = "FeaturedCardCell"
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let actionButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(red: 0.98, green: 0.88, blue: 0.82, alpha: 1.0)
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout() {
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        
        categoryLabel.font = .systemFont(ofSize: 12)
        categoryLabel.textColor = .darkGray
        categoryLabel.numberOfLines = 1
        
        actionButton.setTitle("Start Quiz", for: .normal)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        actionButton.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        actionButton.layer.cornerRadius = 18
        actionButton.isUserInteractionEnabled = false
        
        [imageView, titleLabel, categoryLabel, actionButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalToConstant: 95),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            actionButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    func configure(with spot: Spot) {
        imageView.image = UIImage(named: spot.imageName)
        titleLabel.text = spot.name
        categoryLabel.text = spot.category
    }
}

final class GridSpotCell: UICollectionViewCell {
    static let reuseID = "GridSpotCell"
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let tagLabel = UILabel()
    private let descLabel = UILabel()
    private let actionButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = Theme.cardBackground
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout() {
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.textColor = Theme.textPrimary
        titleLabel.numberOfLines = 2
        
        categoryLabel.font = .systemFont(ofSize: 11, weight: .medium)
        categoryLabel.textColor = Theme.primaryOrange
        
        tagLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        tagLabel.textColor = Theme.tagYellow
        tagLabel.numberOfLines = 1
        
        descLabel.font = .systemFont(ofSize: 11)
        descLabel.textColor = Theme.textSecondary
        descLabel.numberOfLines = 3

        actionButton.setTitle("Play Quiz →", for: .normal)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        actionButton.backgroundColor = Theme.primaryOrange
        actionButton.layer.cornerRadius = 10
        actionButton.isUserInteractionEnabled = false

        [imageView, titleLabel, categoryLabel, tagLabel, descLabel, actionButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 44),
            imageView.heightAnchor.constraint(equalToConstant: 44),

            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            tagLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            tagLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            tagLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            descLabel.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 4),
            descLabel.leadingAnchor.constraint(equalTo: tagLabel.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: tagLabel.trailingAnchor),

            actionButton.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 10),
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            actionButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    func configure(with spot: Spot) {
        imageView.image = UIImage(named: spot.imageName)
        titleLabel.text = spot.name
        categoryLabel.text = spot.category
        tagLabel.text = "🎯 \(spot.tag)"
        descLabel.text = spot.description
    }
}

final class SectionHeaderView: UICollectionReusableView {
    static let reuseID = "SectionHeaderView"
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = Theme.textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(title: String) {
        titleLabel.text = title
    }
}
