import CoreData
import RxSwift
import RxCocoa
import UIKit

private struct Keys {
    static let entityKey = "Account"
    static let loginKey = "login"
}

final public class DataBase {
    
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var context: NSManagedObjectContext!
    var arrayOfLogins: [String] {
        return array.value
    }
    var array = BehaviorRelay<[String]>(value: [])
    
    func openDatabse(login: String) {
        guard let appDelegate = self.appDelegate else {
            print("\n LOG can’t get appDelegate")
            return
        }
        context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: Keys.entityKey, in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        saveData(accountObj: newUser, login: login)
    }
    
    func saveData(accountObj: NSManagedObject, login: String) {
        guard let appDelegate = self.appDelegate else {
            print("\n LOG can’t get appDelegate")
            return
        }
        context = appDelegate.persistentContainer.viewContext
        accountObj.setValue(login, forKey: Keys.loginKey)
        print("Storing Data..")
        do {
            try context.save()
        } catch {
            print("Storing data Failed")
        }

        fetchData()
    }

    func fetchData() {
        print("Fetching Data..")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Keys.entityKey)
        request.returnsObjectsAsFaults = false
        var tempArray: [String] = []
        do {
            guard let appDelegate = self.appDelegate else {
                print("\n LOG can’t get appDelegate")
                return
            }
            context = appDelegate.persistentContainer.viewContext
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                guard let login = data.value(forKey: Keys.loginKey) as? String else {
                    print("\n LOG can’t get value from NSManagedObject")
                    return
                }
                tempArray.append(login)
            }
            array.accept(tempArray)
        } catch {
            print("Fetching data Failed")
        }
    }
    
    func deleteObject(logIn: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Keys.entityKey)
        request.returnsObjectsAsFaults = false
        if let result = try? context.fetch(request) {
            for object in result as! [NSManagedObject] {
                guard let login = object.value(forKey: Keys.loginKey) as? String else {
                    print("\n LOG can’t get value from NSManagedObject")
                    return
                }
                if login == logIn {
                    context.delete(object)
                    print("Delete object \(login) from DB")
                }
            }
        }
    }
}
