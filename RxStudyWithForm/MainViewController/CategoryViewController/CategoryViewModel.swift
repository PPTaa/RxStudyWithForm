//
//  CategoryViewModel.swift
//  RxStudyWithForm
//
//  Created by leejungchul on 2022/12/13.
//

import RxCocoa
import RxSwift

struct CategoryViewModel {
    let disposeBag = DisposeBag()
    // 셀데이터 읽기
    // ViewModel -> View
    let cellData: Driver<[Category]>
    let pop: Signal<Void>
    
    // View -> ViewModel
    let itemSelected = PublishRelay<Int>()
    
    // View -> ParentView
    let selectedCategory = PublishSubject<Category>()
    
    init() {
        let categories = [
            Category(id: 1, name: "1번 카테고리"),
            Category(id: 2, name: "2번 카테고리"),
            Category(id: 3, name: "3번 카테고리"),
            Category(id: 4, name: "4번 카테고리"),
            Category(id: 5, name: "5번 카테고리"),
            Category(id: 6, name: "6번 카테고리"),
            Category(id: 7, name: "7번 카테고리"),
            Category(id: 8, name: "8번 카테고리"),
            Category(id: 9, name: "9번 카테고리"),
            Category(id: 10, name: "10번 카테고리"),
            Category(id: 11, name: "11번 카테고리"),
            Category(id: 12, name: "12번 카테고리"),
        ]
        
        self.cellData = Driver.just(categories)
        
        self.itemSelected
            .map { categories[$0] }
            .bind(to: selectedCategory)
            .disposed(by: disposeBag)
        
        self.pop = itemSelected.map { _ in Void()}
            .asSignal(onErrorSignalWith: .empty())
    }
    
    
}
