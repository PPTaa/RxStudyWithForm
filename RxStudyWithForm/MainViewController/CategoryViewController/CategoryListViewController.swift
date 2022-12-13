//
//  CategoryListViewController.swift
//  RxStudyWithForm
//
//  Created by leejungchul on 2022/12/13.
//
import RxSwift
import RxCocoa
import UIKit

class CategoryListViewController: UIViewController {
    let disposeBag = DisposeBag()
    let tableview = UITableView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: CategoryViewModel) {
        // viewmodel 에서 가져온 셀데이터로 테이블 뷰 데이터 구성
        viewModel.cellData
            .drive(tableview.rx.items) { tv, row, data in
                let cell = tv.dequeueReusableCell(withIdentifier: "CategoryListCell", for: IndexPath(row: row, section: 0))
                cell.textLabel?.text = data.name
                return cell
            }
            .disposed(by: disposeBag)
        // pop 누를 경우 현재 뷰에서 pop 되도록
        viewModel.pop
            .emit { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        tableview.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
            
    }
    
    private func attribute() {
        view.backgroundColor = .cyan
        tableview.backgroundColor = .systemBackground
        tableview.separatorStyle = .singleLine
        tableview.tableFooterView = UIView()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryListCell")
        
    }
    
    private func layout() {
        view.addSubview(tableview)
        tableview.snp.makeConstraints {
            $0.edges.equalToSuperview() // snapkit에서 전체를 지칭 edges
        }
    }
}
