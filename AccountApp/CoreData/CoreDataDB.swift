import CoreData
import UIKit

private struct Keys {
    static let entityKey = "Account"
    static let loginKey = "login"
}

final public class DataBase {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    var arrayOfLogins: [String] = []
    
    func openDatabse(login: String) {
      context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: Keys.entityKey, in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        saveData(accountObj: newUser, login: login)
    }
    
    func saveData(accountObj: NSManagedObject, login: String) {
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
        do {
            context = appDelegate.persistentContainer.viewContext
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                guard let login = data.value(forKey: Keys.loginKey) as? String else { return }
                arrayOfLogins.append(login)
            }
        } catch {
            print("Fetching data Failed")
        }
    }
}
