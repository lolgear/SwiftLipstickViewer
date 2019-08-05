//
//  LipstickSamplersListViewController.swift
//  SwiftLipstickViewer
//
//  Created by Dmitry Lobanov on 28.07.2019.
//  Copyright © 2019 Dmitry Lobanov. All rights reserved.
//

import Foundation
import UIKit

class LipstickSamplersListViewController: BaseViewController {
    var model: Model?
    var collectionView: UICollectionView?
}

// MARK: Actions
extension LipstickSamplersListViewController {
    func selectCellAtSelectedIndexPath() {
        if let collectionView = self.collectionView, let indexPath = self.model?.selectedIndexPath {
            DispatchQueue.main.async {
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
}


// MARK: HasModelProtocol
extension LipstickSamplersListViewController: HasModelProtocol {
    func updateForNewModel() {
        self.model?.configured(listener: self)
    }
}

// MARK: UICollectionViewDelegate
extension LipstickSamplersListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // select item and tell model about it.
        // also update cell style?
        
        self.model?.selectIndexPath(indexPath: indexPath)
        self.selectCellAtSelectedIndexPath()
        // and calculate offset.
        // should be at the middle of screen.
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension LipstickSamplersListViewController: UICollectionViewDelegateFlowLayout {
    
    /*
     item.height == item.width,
     item.height <= view.height - sectionInset - 2 * minimum
     
     */    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.size.height
        let width = collectionView.bounds.size.width
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let remainsHeight = height - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom
//        let
        let interitemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
        let remainsWidth = (width - 4 * interitemSpacing) / 4
        // remainsWidth is a width between
        let size = min(remainsWidth, remainsHeight)

        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let height = collectionView.bounds.size.height
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        // we have 4 elements.
        // two small halves, one big and two small.
        return 20
        
//        return (width - (remainsHeight - 5) * 3 - remainsHeight) / 4
    }
    
}

// MARK: UICollectionViewDataSource
extension LipstickSamplersListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.model?.numberOfSections() ?? 1 // take from model
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model?.countOfElements(at: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let model = self.model?.element(at: indexPath), let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.cellReuseIdentifier(), for: indexPath) as? Cell {
            let cellModel = Cell.Model()
            cellModel.color = model.color
            cellModel.selected = model.selected
            cell.model = cellModel
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    // Model will handle updates.
}

// MARK: Layout also?
// Or we can simply add collection View controller and then set their delegates to something?

// MARK: View Lifecycle
extension LipstickSamplersListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            layout.minimumInteritemSpacing = 50
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
            let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
            view.isScrollEnabled = false
            view.delegate = self
            view.dataSource = self
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            return view
        }()
        
        self.collectionView = collectionView
        
        self.view.addSubview(collectionView)
        let constraints = NSLayoutConstraint.bounds(item: collectionView, toItem: self.view)
        NSLayoutConstraint.activate(constraints)
        
        // also set cell reuse identifier
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.cellReuseIdentifier())
        
//        UICollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
//        collectionView.backgroundColor = .orange
    }
}

// MARK: TableViewModelProtocol__Listener
extension LipstickSamplersListViewController: TableViewModelProtocol__Listener {
    func didAppend(at: Int) {
        // not used.
    }
    
    func didAppend(count: Int) {
        DispatchQueue.main.async {
            let indexPaths = Array(0..<count).map { IndexPath(row: $0, section: 0) }
            self.collectionView?.insertItems(at: indexPaths)
        }
    }
    
    func didRemoveAll(count: Int) {
        DispatchQueue.main.async {
            let indexPaths = Array(0..<count).map { IndexPath(row: $0, section: 0) }
            self.collectionView?.deleteItems(at: indexPaths)
        }
    }
    func didReset(before: Int, after: Int) {
        DispatchQueue.main.async {
            let beforeIndexPaths = Array(0..<before).map { IndexPath(row: $0, section: 0) }
            let afterIndexPaths = Array(0..<after).map { IndexPath(row: $0, section: 0) }
            self.collectionView?.performBatchUpdates({
                self.collectionView?.deleteItems(at: beforeIndexPaths)
                self.collectionView?.reloadItems(at: afterIndexPaths)
                self.selectCellAtSelectedIndexPath()
            }, completion: nil)
        }
    }
}
