//
//  MainViewController.swift
//  RxStudyWithForm
//
//  Created by leejungchul on 2022/12/13.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MainViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let tableview = UITableView()
    
    let submitButton = UIBarButtonItem()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MainViewModel) {
        viewModel.cellData
            .drive(tableview.rx.items) { tv, row, data in
                switch row {
                case 0:
                    let cell = tv.dequeueReusableCell(withIdentifier: "TitleTextFieldCell", for: IndexPath(row: row, section: 0)) as! TitleTextFieldCell
                    cell.selectionStyle = .none
                    cell.titleInputField.placeholder = data
                    cell.bind(viewModel.titleTextFieldCellViewModel)
                    return cell
                case 1:
                    let cell = tv.dequeueReusableCell(withIdentifier: "CategorySelectCell", for: IndexPath(row: row, section: 0)) as! UITableViewCell
                    cell.selectionStyle = .none
                    cell.textLabel?.text = data
                    cell.accessoryType = .disclosureIndicator
                    return cell
                case 2:
                    let cell = tv.dequeueReusableCell(withIdentifier: "PriceTextFieldCell", for: IndexPath(row: row, section: 0)) as! PriceTextFieldCell
                    cell.selectionStyle = .none
                    cell.priceInputField.placeholder = data
                    cell.bind(viewModel.priceTextFieldCellViewModel)
                    return cell
                case 3:
                    let cell = tv.dequeueReusableCell(withIdentifier: "DetailWriteFormCell", for: IndexPath(row: row, section: 0)) as! DetailWriteFormCell
                    cell.selectionStyle = .none
                    print(data)
                    cell.contentInputView.text = data
                    cell.bind(viewModel.detailWriteFormCellViewModel)
                    return cell
                default:
                    fatalError()
                }
                
            }
            .disposed(by: disposeBag)
        
        
        viewModel.presentAlert
            .emit(to: self.rx.setAlert)
            .disposed(by: disposeBag)
        
        viewModel.push
            .drive(onNext: { viewModel in
                let viewController = CategoryListViewController()
                viewController.bind(viewModel)
                self.show(viewController, sender: nil)
            })
        
        tableview.rx.itemSelected
            .map{ $0.row }
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .bind(to: viewModel.submitButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        title = "글작성하기"
        view.backgroundColor = .green
        submitButton.title = "작성"
        submitButton.style = .done
        
        navigationItem.setRightBarButton(submitButton, animated: true)
        
        tableview.backgroundColor = .brown
        tableview.separatorColor = .red
        tableview.tableFooterView = UIView() // 마지막에 푸터뷰를 주면 마지막 세퍼레이터가 보이지 않음
        
        tableview.register(TitleTextFieldCell.self, forCellReuseIdentifier: "TitleTextFieldCell") // index 0
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "CategorySelectCell") // index 1
        tableview.register(PriceTextFieldCell.self, forCellReuseIdentifier: "PriceTextFieldCell") // index 2
        tableview.register(DetailWriteFormCell.self, forCellReuseIdentifier: "DetailWriteFormCell") // index 3
        
    }
    
    private func layout() {
        view.addSubview(tableview)
        tableview.snp.makeConstraints {
            $0.edges.equalToSuperview() // snapkit에서 전체를 지칭 edges
        }
    }
}

// AlertController 가짐
typealias Alert = (title: String, message: String?)
//???
extension Reactive where Base: MainViewController {
    var setAlert: Binder<Alert> {
        return Binder(base) { base, data in
            let alertController = UIAlertController(title: data.title, message: data.message, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertController.addAction(action)
            base.present(alertController, animated: true)   
        }
    }
}

