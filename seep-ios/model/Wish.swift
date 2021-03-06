import Foundation
import RealmSwift

class Wish: Object {
  
  @objc dynamic var _id: ObjectId = ObjectId.generate()
  @objc dynamic var emoji: String = ""
  @objc dynamic var category: String = ""
  @objc dynamic var title: String = ""
  @objc dynamic var date: Date = Date()
  @objc dynamic var finishDate: Date?
  @objc dynamic var isPushEnable: Bool = false
  @objc dynamic var memo: String = ""
  @objc dynamic var hashtag: String = ""
  @objc dynamic var isSuccess: Bool = false
  @objc dynamic var createdAt: Date = Date()
  
  
  static func deadlineOrder(wish1: Wish, wish2: Wish) -> Bool {
    return wish1.date < wish2.date
  }
  
  static func finishOrder(wish1: Wish, wish2: Wish) -> Bool {
    return wish1.finishDate! > wish2.finishDate!
  }
}
