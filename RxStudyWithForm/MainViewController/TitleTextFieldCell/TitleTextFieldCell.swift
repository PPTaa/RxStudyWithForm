//
//  TitleTextFieldCell.swift
//  RxStudyWithForm
//
//  Created by leejungchul on 2022/12/13.
//

import RxSwift
import RxCocoa
import SnapKit
import UIKit

class TitleTextFieldCell: UITableViewCell {
    let disposeBag = DisposeBag()
    
    let titleInputField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: TitleTextFieldCellViewModel) {
        titleInputField.rx.text
            .bind(to: viewModel.titleText)
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        contentView.addSubview(titleInputField)
        titleInputField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
    }
    
    private func attribute() {
        titleInputField.font = .systemFont(ofSize: 17)
        
    }
}
