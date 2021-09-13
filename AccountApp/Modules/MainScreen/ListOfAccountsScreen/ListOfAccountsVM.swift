import Foundation
import RxSwift
import RxCocoa

struct ListOfAccountsOutput {
    let arrayOfLogins: Observable<[String]>
}

class ListOfAccountsViewModel {
    
    private let dataBase = DataBase()
    private let disposeBag = DisposeBag()
    
    func bind() -> ListOfAccountsOutput {
        dataBase.fetchData()
        Observable<[String]>.just(dataBase.array.value).subscribe { _ in
        }.disposed(by: disposeBag)
        return ListOfAccountsOutput(arrayOfLogins: dataBase.array.asObservable())
    }
}
