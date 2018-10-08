//
//  ViewController.swift
//  Example
//
//  Created by Krunoslav Zaher on 1/1/16.
//  Copyright © 2016 kzaher. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import CoreLocation

class NumberCell : UICollectionViewCell {
    @IBOutlet var value: UILabel?
}

class NumberSectionView : UICollectionReusableView {
    @IBOutlet weak var value: UILabel?
}

class PartialUpdatesViewController: UIViewController {
    
    @IBOutlet weak var animatedTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animatedCollectionView: UICollectionView!
    @IBOutlet weak var refreshButton: UIButton!
    
    
    let disposeBag = DisposeBag()
    
    let data:Variable<[NumberSection]> = Variable([NumberSection(header: "section 1", numbers: `$`([1, 2, 3]), updated: Date()),
                                                   NumberSection(header: "section 2", numbers: `$`([4, 5, 6]), updated: Date()),
                                                   NumberSection(header: "section 3", numbers: `$`([7, 8, 9]), updated: Date()),
                                                   NumberSection(header: "section 4", numbers: `$`([10, 11, 12]), updated: Date()),
                                                   NumberSection(header: "section 5", numbers: `$`([13, 14, 15]), updated: Date()),
                                                   NumberSection(header: "section 6", numbers: `$`([16, 17, 18]), updated: Date()),
                                                   NumberSection(header: "section 7", numbers: `$`([19, 20, 21]), updated: Date()),
                                                   NumberSection(header: "section 8", numbers: `$`([22, 23, 24]), updated: Date()),
                                                   NumberSection(header: "section 9", numbers: `$`([25, 26, 27]), updated: Date()),
                                                   NumberSection(header: "section 10", numbers: `$`([28, 29, 30]), updated: Date())])
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animatedTableView.estimatedRowHeight = 500
        animatedTableView.rowHeight = UITableViewAutomaticDimension
        
        animatedTableView.register(TestCell.self, forCellReuseIdentifier: "TestCell")
        data.asObservable().subscribe { (event) in
            print("Data Changed")
            }.disposed(by: disposeBag)
        let tvAnimatedDataSource = RxTableViewSectionedAnimatedDataSource<NumberSection>(
            configureCell:  { (_, tv, ip, i) in
                let cell = tv.dequeueReusableCell(withIdentifier: "TestCell") as? TestCell
                cell?.childView.labelTest.text = "\(i)"
                cell?.childView.stackViewExpand.isHidden = (i.number%2) == 0
                return cell!
        },
            titleForHeaderInSection: { (ds, section) -> String? in
                return ds[section].header
        }
        )
        
        
        data.asObservable()
            .bind(to: self.animatedTableView.rx.items(dataSource: tvAnimatedDataSource))
            .disposed(by: disposeBag)
        
        
        // touches
        refreshButton.rx.tap.bind{
//            self.data.value[0].numbers.append(IntItem(number: 1000, date: Date()))
            let lower : UInt32 = 1000
            let upper : UInt32 = 1020
            let randomNumber = arc4random_uniform(upper - lower) + lower
            self.data.value[1].numbers[0]=IntItem(number: Int(randomNumber), date: Date())
            }.disposed(by: disposeBag)
        Observable.of(
           
            animatedTableView.rx.modelSelected(IntItem.self)
           
            )
            .merge()
            .subscribe(onNext: { item in
                  self.data.value[1].numbers[0]=IntItem(number: 101, date: Date())
                print("Let me guess, it's .... It's \(item), isn't it? Yeah, I've got it.")
            })
            .disposed(by: disposeBag)
    }
}



func `$`(_ numbers: [Int]) -> [IntItem] {
    return numbers.map { IntItem(number: $0, date: Date()) }
}

