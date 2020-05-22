//
//  GalleryLayout.swift
//  CatBooth
//
//  Created by cr3w on 21.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

protocol GalleryLayoutDelegate: class {
    func sizeForItem(in collectionView: UICollectionView,of indexPath: IndexPath) -> CGSize
}

class GalleryLayout: UICollectionViewLayout {
    
    weak var delegate: GalleryLayoutDelegate!
    
    private var numberOfColumns = 2
    private var cellPadding: CGFloat = 3
    
    // saved attributes
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentHeight: CGFloat = 0
    private lazy var contentWidth: CGFloat = self.collectionView != nil ?
        self.collectionView!.frame.width : 0
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }
        // column width & cell width
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        // x offsets for collums
        var xOffest = [CGFloat]()
        for column in 0..<numberOfColumns {
            xOffest.append(CGFloat(column) * columnWidth)
        }
        
        // Start column
        var column = 0
        // y offset for intem at index
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoSize = delegate.sizeForItem(in: collectionView, of: indexPath)
            
            let cellWidth = columnWidth
            // proportional height of cell
            let cellHeight = photoSize.height * cellWidth / photoSize.width
            
            let frame = CGRect(x: xOffest[column], y: yOffset[column], width: cellWidth, height: cellHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + cellHeight
            
            // select column
            column = yOffset[0] <= yOffset[1] ? 0 : 1
                
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
