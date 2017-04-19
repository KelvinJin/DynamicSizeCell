//
//  SimpleCell.swift
//  DynamicSizeCell
//
//  Created by Jin Wang on 19/4/17.
//  Copyright © 2017 Jin Wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SimpleCellViewModel {
    let title = PublishSubject<String>()
    
    private let text = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    
    init() {
        let textObservable = text.asObservable()
        
        textObservable
            .bind(to: title)
            .disposed(by: disposeBag)
    }
    
    func configureWith(text: String) {
        self.text.onNext(text)
    }
}

protocol SimpleCellDelegate: class {
    func requestSizeRecalculate(cell: SimpleCell)
}

class SimpleCell: UITableViewCell {
    
    @IBOutlet var label: UILabel!
    
    weak var delegate: SimpleCellDelegate?
    
    private let viewModel = SimpleCellViewModel()
    private let disposeBag = DisposeBag()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewModel.title
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] title in
                guard let cell = self else { return }
                
                cell.label.text = title
                cell.delegate?.requestSizeRecalculate(cell: cell)
            })
            .disposed(by: disposeBag)
    }
    
    func configureWith(text: String) {
        viewModel.configureWith(text: text)
    }
}
