import UIKit

class ViewController: UIViewController {
    enum LayoutType {
        case def
        case pinterest
    }
    
    var layoutType: LayoutType = .def
    var collectionView: UICollectionView!
    var colors: [[UIColor]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.initData()
        self.initView()
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
    
    func initData() {
        var tempColors1: [UIColor] = []
        var tempColors2: [UIColor] = []
        var tempColors3: [UIColor] = []
        var tempColors4: [UIColor] = []
        var tempColors5: [UIColor] = []
        for _ in 1...5 {
            tempColors1.append(UIColor.random)
        }
        for _ in 1...10 {
            tempColors2.append(UIColor.random)
        }
        for _ in 1...10 {
            let t = Array(repeating: UIColor.random, count: 3)
            tempColors3.append(contentsOf: t)
        }
        for _ in 1...10 {
            let t = Array(repeating: UIColor.random, count: 1)
            let t2 = Array(repeating: UIColor.random, count: 2)
            tempColors4.append(contentsOf: t)
            tempColors4.append(contentsOf: t2)
        }
        for _ in 1...20 {
            tempColors5.append(UIColor.random)
        }
        colors.append(tempColors1)
        colors.append(tempColors2)
        colors.append(tempColors3)
        colors.append(tempColors4)
        colors.append(tempColors5)
    }
    
    func initView() {
        // 創建CollectionView
        self.layoutType = .def
        switch self.layoutType {
        case .def:
            let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
                return self.createGridLayout(index: sectionIndex)
            }
            collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        case .pinterest:
            let pinterestLayout = PinterestLayout()
            pinterestLayout.delegate = self
            collectionView = UICollectionView(frame: view.frame, collectionViewLayout: pinterestLayout)
        }
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "header")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        view.addSubview(collectionView)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        collectionView.addGestureRecognizer(gesture)
    }
    
    func createGridLayout(index: Int) -> NSCollectionLayoutSection {
        var sectionBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none
        var group: NSCollectionLayoutGroup!
        switch index {
        case 0:
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(100))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 0)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(300), heightDimension: .absolute(100))
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems : [item])
            sectionBehavior = .continuous
            
        case 1:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/5), heightDimension: .fractionalWidth(1/5))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/5))
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems : [item])
            sectionBehavior = .none
            
        case 2:
            let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let layoutSize2 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
            let item2 = NSCollectionLayoutItem(layoutSize: layoutSize2)
            item2.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let layoutSize3 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
            let item3 = NSCollectionLayoutItem(layoutSize: layoutSize3)
            item3.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/5), heightDimension: .absolute(120))
            group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems : [item, item2, item3])
            sectionBehavior = .continuous
            
        case 3:
            // Group1
            let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let group1Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1))
            let group1 = NSCollectionLayoutGroup.horizontal(layoutSize: group1Size, subitems: [item])
            
            // Group2
            let layoutSize2 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3))
            let item2 = NSCollectionLayoutItem(layoutSize: layoutSize2)
            item2.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let layoutSize3 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(2/3))
            let item3 = NSCollectionLayoutItem(layoutSize: layoutSize3)
            item3.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let group2Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1))
            let group2 = NSCollectionLayoutGroup.vertical(layoutSize: group2Size, subitems: [item2, item3])

            let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .absolute(120))
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayoutSize, subitems: [group1, group2])
            sectionBehavior = .continuous
            
        default:
            // Group1
            let fullItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
            let fullItem = NSCollectionLayoutItem(layoutSize:
                                                    fullItemSize)
            fullItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let group1Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(2/7))
            let group1 = NSCollectionLayoutGroup.horizontal(layoutSize: group1Size, subitems: [fullItem])
            
            // Group2
            // Group2-Left
            let group2LeftItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let group2LeftItem = NSCollectionLayoutItem(layoutSize: group2LeftItemSize)
            group2LeftItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let group2LeftSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1))
            let group2Left = NSCollectionLayoutGroup.horizontal(layoutSize: group2LeftSize, subitems: [group2LeftItem])
            // Group2-Right
            let group2RightItem1Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2))
            let group2RightItem1 = NSCollectionLayoutItem(layoutSize: group2RightItem1Size)
            group2RightItem1.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let group2RightItem2Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2))
            let group2RightItem2 = NSCollectionLayoutItem(layoutSize: group2RightItem2Size)
            group2RightItem2.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let group2RightSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
            let group2Right = NSCollectionLayoutGroup.vertical(layoutSize: group2RightSize, subitems: [group2RightItem1, group2RightItem2])
            // Group2組合
            let group2Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(2/7))
            let group2 = NSCollectionLayoutGroup.horizontal(layoutSize: group2Size, subitems: [group2Left, group2Right])
            
            // Group3
            let group3ItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1))
            let group3Item = NSCollectionLayoutItem(layoutSize:
                                                        group3ItemSize)
            group3Item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let group3Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/7))
            let group3 = NSCollectionLayoutGroup.horizontal(layoutSize: group3Size, subitems: [group3Item])
            
            // Group4
            // Group4-Left
            let group4LeftItem1Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2))
            let group4LeftItem1 = NSCollectionLayoutItem(layoutSize: group4LeftItem1Size)
            group4LeftItem1.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let group4LeftItem2Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2))
            let group4LeftItem2 = NSCollectionLayoutItem(layoutSize: group4LeftItem2Size)
            group4LeftItem2.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let group4LeftSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
            let group4Left = NSCollectionLayoutGroup.vertical(layoutSize: group4LeftSize, subitems: [group4LeftItem1, group4LeftItem2])
            // Group4-Right
            let group4RightItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let group4RightItem = NSCollectionLayoutItem(layoutSize: group4RightItemSize)
            group4RightItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let group4RightSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1))
            let group4Right = NSCollectionLayoutGroup.horizontal(layoutSize: group4RightSize, subitems: [group4RightItem])
            // Group4組合
            let group4Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(2/7))
            let group4 = NSCollectionLayoutGroup.horizontal(layoutSize: group4Size, subitems: [group4Left, group4Right])

            let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            group = NSCollectionLayoutGroup.vertical(layoutSize: groupLayoutSize, subitems: [group1, group2, group3, group4])
            sectionBehavior = .none
        }
        
        let section = NSCollectionLayoutSection(group: group)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [headerElement]
        section.orthogonalScrollingBehavior = sectionBehavior
        
        return section
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
        if section == 0 {
            return count
        }
        
        return count == 0 ? 1 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: "header", for: indexPath) as! SectionHeaderView
        headerView.titleLabel.text = "區段\(indexPath.section+1)"
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
            return self.layoutType == .def ? false : true
        } else {
            if colors[indexPath.section].count == 0 {
                return false
            } else {
                return true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if self.layoutType == .def {
            if sourceIndexPath.section != 0
                && destinationIndexPath.section != 0 {
                let item = colors[sourceIndexPath.section].remove(at: sourceIndexPath.row)
                if colors[destinationIndexPath.section].count == 0 {
                    colors[destinationIndexPath.section].insert(item, at: 0)
                } else {
                    colors[destinationIndexPath.section].insert(item, at: destinationIndexPath.row)
                }
            }
            
        } else {
            let item = colors[sourceIndexPath.section].remove(at: sourceIndexPath.row)
            if colors[destinationIndexPath.section].count == 0 {
                colors[destinationIndexPath.section].insert(item, at: 0)
            } else {
                colors[destinationIndexPath.section].insert(item, at: destinationIndexPath.row)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveOfItemFromOriginalIndexPath originalIndexPath: IndexPath, atCurrentIndexPath currentIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if self.layoutType == .def
            && (originalIndexPath.section == 0 || proposedIndexPath.section == 0) {
            return originalIndexPath
        }
        
        return proposedIndexPath
    }
}

// MARK: - WaterFallLayoutDelegate
extension ViewController: PinterestLayoutDelegate {
    func arrangeType(in collectionView: UICollectionView) -> LayoutArrangeType {
        return .shortToTall
    }
    
    func itemPadding(in collectionView: UICollectionView) -> CGFloat {
        return 5
    }
    
    func numberOfColumns(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, itemHeightAtIndexPath indexPath: IndexPath) -> CGFloat {
        return CGFloat.random(in: 50...100) + 50
    }
}

#Preview {
    let vc = ViewController()
    return vc
}
