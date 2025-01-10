//
//  WaterFallFlowLayout.swift
//  Test
//
//  Created by E35 PTW on 2025/1/2.
//

import Foundation
import UIKit

enum LayoutArrangeType {
    case def
    case shortToTall
}

protocol PinterestLayoutDelegate: AnyObject {
    func arrangeType(in collectionView: UICollectionView) -> LayoutArrangeType
    func cellInsetPadding(in collectionView: UICollectionView) -> CGFloat
    func numberOfColumns(in collectionView: UICollectionView) -> Int
    func collectionView(_ collectionView: UICollectionView, itemHeightAtIndexPath indexPath: IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewFlowLayout {
    
    weak var delegate: PinterestLayoutDelegate?
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override func prepare() {
        // Only calculate the layout attributes if cache is empty and the collection view exists
        guard cache.isEmpty, let collectionView = collectionView else {
            return
        }
        
        // 2
        let numberOfColumns = delegate?.numberOfColumns(in: collectionView) ?? 2
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        // 3
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // 4
            let itemHeight = delegate?.collectionView(collectionView, itemHeightAtIndexPath: indexPath) ?? 50
            let height = itemHeight
            
            let arrangeType = delegate?.arrangeType(in: collectionView) ?? .def
            var frame: CGRect!
            switch arrangeType {
            case .def:
                // 預設方式：依序放置
                frame = CGRect(x: xOffset[column], y: yOffset[column],
                                   width: columnWidth, height: height)
                column = column < (numberOfColumns - 1) ? (column + 1) : 0
            case .shortToTall:
                // 找出最短的列
                guard let minYOffset = yOffset.min() else { continue }
                guard let shortestColumn = yOffset.firstIndex(where: { $0 == minYOffset }) else { continue }
                frame = CGRect(x: xOffset[shortestColumn], y: yOffset[shortestColumn],
                               width: columnWidth, height: height)
                column = shortestColumn
            }
            let cellInsetPadding = delegate?.cellInsetPadding(in: collectionView) ?? 5
            let insetFrame = frame.insetBy(dx: cellInsetPadding, dy: cellInsetPadding)
            
            // 5
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // 6
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter({
            $0.frame.intersects(rect)
        })
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
