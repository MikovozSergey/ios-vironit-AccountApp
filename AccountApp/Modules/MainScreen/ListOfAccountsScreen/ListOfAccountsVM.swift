import Foundation
import RxSwift
import RxCocoa

struct ListOfAccountsOutput {
    let arrayOfLogins: Observable<[String]>
}

class ListOfAccountsViewModel {
    
    private let dataBase = DataBase()
    
//    func bind() -> ListOfAccountsOutput {
//        dataBase.fetchData()
//        Observable<[String]>.just(dataBase.array.value).subscribe { value in
//            print(value)
//        }
//        return ListOfAccountsOutput(arrayOfLogins: dataBase.array.asObservable())
//    }
}
