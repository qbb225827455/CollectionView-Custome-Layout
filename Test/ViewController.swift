import UIKit

class ViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var colors: [[UIColor]] = [
        [.systemRed,
         .systemBlue,
         .systemGreen,
         .systemOrange,
         .systemYellow,
         .systemPink,
         .systemPurple,
         .systemRed,
         .systemBlue,
         .systemGreen,
         .systemOrange,
         .systemYellow,
         .systemPink,
         .systemPurple,
         .systemRed,
         .systemBlue,
         .systemGreen,
         .systemOrange,
         .systemYellow,
         .systemPink,
         .systemPurple],
        
        [.brown,
         .systemTeal,
         .systemIndigo,
         .brown,
         .systemTeal,
         .systemIndigo,
         .brown,
         .systemTeal,
         .systemIndigo,
         .brown,
         .systemTeal,
         .systemIndigo]
    ]
    var titles: [String] = ["區段1", "區段2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // 創建CollectionView
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            return self.createGridLayout(index: sectionIndex)
        }
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "header")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard let collectionView = collectionView else { return }
        switch gesture.state {
        case .began:
            guard let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
            collectionView.beginInteractiveMovementForItem(at: indexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
            collectionView.reloadData()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func createGridLayout(index: Int) -> NSCollectionLayoutSection {
        switch index {
        case 0:
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(100))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 0)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(300), heightDimension: .absolute(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems : [item])
            
            let section = NSCollectionLayoutSection(group: group)
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
            section.boundarySupplementaryItems = [headerElement]
            section.orthogonalScrollingBehavior = .continuous
            
            return section
            
        default:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalWidth(1/3))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/3))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems : [item])
            
            let section = NSCollectionLayoutSection(group: group)
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
            section.boundarySupplementaryItems = [headerElement]
            
            return section
        }
    }
    
    func animateCell(_ cell: UICollectionViewCell, isShaking: Bool) {
        if isShaking {
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.duration = 0.1
            animation.repeatCount = .infinity
            animation.autoreverses = true
            animation.fromValue = -0.05
            animation.toValue = 0.05
            cell.layer.add(animation, forKey: "shake")
        } else {
            cell.layer.removeAnimation(forKey: "shake")
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = colors[section].count
        return count == 0 ? 1 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: "header", for: indexPath) as! SectionHeaderView
        headerView.titleLabel.text = self.titles[indexPath.section]
        headerView.titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if colors[indexPath.section].count == 0 {
            cell.backgroundColor = .darkGray
        } else {
            cell.backgroundColor = colors[indexPath.section][indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else {
            if colors[indexPath.section].count == 0 {
                return false
            } else {
                return true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section != 0 && destinationIndexPath.section != 0 {
            let item = colors[sourceIndexPath.section].remove(at: sourceIndexPath.row)
            if colors[destinationIndexPath.section].count == 0 {
                colors[destinationIndexPath.section].insert(item, at: 0)
            } else {
                colors[destinationIndexPath.section].insert(item, at: destinationIndexPath.row)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveOfItemFromOriginalIndexPath originalIndexPath: IndexPath, atCurrentIndexPath currentIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if originalIndexPath.section == 0 || proposedIndexPath.section == 0 {
            return originalIndexPath
        }
        
        return proposedIndexPath
    }
}

#Preview {
    let vc = ViewController()
    return vc
}
