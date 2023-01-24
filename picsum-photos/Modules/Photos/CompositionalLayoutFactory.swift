//
//  CompositionalLayoutFactory.swift
//  picsum-photos
//
//  Created by Andrii Ponomarov on 09.12.2022.
//

import Foundation
import UIKit

struct CompositionalLayoutFactory {
    
    enum LayoutType {
        case photos
    }
    
    static func layout(_ type: LayoutType) -> UICollectionViewCompositionalLayout {
        let pairGroup =
        NSCollectionLayoutGroup.vertical(layoutSize: Group.pair.layoutSize,
                                         subitems: [Item.halfHeight.layoutItem,
                                                    Item.halfHeight.layoutItem])
        let pairWithMainGroup =
        NSCollectionLayoutGroup.horizontal(layoutSize: Group.pairWithMainReversed.layoutSize,
                                           subitems: [pairGroup, Item.twoThirdWidth.layoutItem])
        let pairWithMainReversedGroup =
        NSCollectionLayoutGroup.horizontal(layoutSize: Group.pairWithMain.layoutSize,
                                           subitems: [Item.twoThirdWidth.layoutItem, pairGroup])
        let tripleGroup =
        NSCollectionLayoutGroup.horizontal(layoutSize: Group.triple.layoutSize,
                                           subitems: [Item.thirdWidth.layoutItem,
                                                      Item.thirdWidth.layoutItem,
                                                      Item.thirdWidth.layoutItem])
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: Group.section.layoutSize,
                                                     subitems: [pairWithMainGroup,
                                                                tripleGroup,
                                                                tripleGroup,
                                                                pairWithMainReversedGroup])
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .absolute(Constants.footerHeight))
        let footer =
        NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                    elementKind: UICollectionView.elementKindSectionFooter,
                                                    alignment: .bottom)

        let section = NSCollectionLayoutSection(group: group)
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.boundarySupplementaryItems = [footer]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = configuration
        
        return layout
    }
    
    private enum Item {
        case twoThirdWidth, halfHeight, thirdWidth
        
        var layoutItem: NSCollectionLayoutItem {
            let insets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
            let layoutItem = NSCollectionLayoutItem(layoutSize: layoutSize)
            layoutItem.contentInsets = insets
            return layoutItem
        }
        
        var layoutSize: NSCollectionLayoutSize {
            switch self {
            case .twoThirdWidth:
                return NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3),
                                              heightDimension: .fractionalHeight(1))
            case .halfHeight:
                return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1/2))
            case .thirdWidth:
                return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                              heightDimension: .fractionalHeight(1))
            }
        }
        
    }
    
    private enum Group {
        case pair, pairWithMain, triple, pairWithMainReversed, section
        
        var layoutSize: NSCollectionLayoutSize {
            switch self {
            case .pair:
                return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                              heightDimension: .fractionalHeight(1))
            case .pairWithMain, .pairWithMainReversed:
                return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1/3))
            case .triple:
                return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1/6))
            case .section:
                return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
            }
        }

    }
    
    private enum Constants {
        static let footerHeight: CGFloat = 50
    }
    
}
