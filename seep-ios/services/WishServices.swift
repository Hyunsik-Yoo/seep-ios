import RealmSwift

protocol WishServiceProtocol {
  
  func addWish(wish: Wish)
  func deleteWish(id: ObjectId)
  func searchWish(id: ObjectId) -> Wish?
  func updateWish(id: ObjectId, newWish: Wish)
  func finishWish(wish: Wish)
  func fetchAllWishes(category: Category) -> [Wish]
  func getFinishCount(category: Category) -> Int
  func fetchFinishedWishes(category: Category) -> [Wish]
  func getWishCount() -> Int
  func getWishCount(category: Category) -> Int
}


struct WishService: WishServiceProtocol {
  
  func addWish(wish: Wish) {
    let realm = try! Realm()
    
    try! realm.write {
      realm.add(wish)
    }
  }
  
  func deleteWish(id: ObjectId) {
    guard let realm = try? Realm() else { return }
    let searchTask = realm.objects(Wish.self).filter { $0._id == id }
    guard let targetObject = searchTask.first else { return }
    
    try! realm.write{
      realm.delete(targetObject)
    }
  }
  
  func searchWish(id: ObjectId) -> Wish? {
    guard let realm = try? Realm() else { return nil }
    let searchTask = realm.objects(Wish.self).filter { $0._id == id }
    guard let targetObject = searchTask.first else { return nil }
    
    return targetObject
  }
  
  func updateWish(id: ObjectId, newWish: Wish) {
    guard let realm = try? Realm() else { return }
    let item = self.searchWish(id: id)
    
    try! realm.write {
      item?.emoji = newWish.emoji
      item?.category = newWish.category
      item?.title = newWish.title
      item?.date = newWish.date
      item?.isPushEnable = newWish.isPushEnable
      item?.memo = newWish.memo
      item?.hashtag = newWish.hashtag
    }
  }
  
  func finishWish(wish: Wish) {
    guard let realm = try? Realm() else { return }
    
    realm.beginWrite()
    wish.isSuccess = true
    wish.finishDate = DateUtils.now()
    try! realm.commitWrite()
  }
  
  func fetchAllWishes(category: Category) -> [Wish] {
    guard let realm = try? Realm() else { return [] }
    let searchTask = realm.objects(Wish.self).filter { ($0.isSuccess == false) && ($0.category == category.rawValue) }
    
    return searchTask.map { $0 }.sorted(by: Wish.deadlineOrder)
  }
  
  func getFinishCount(category: Category) -> Int {
    let realm = try! Realm()
    let searchTask = realm.objects(Wish.self).filter { ($0.isSuccess == true) && ($0.category == category.rawValue) }
    
    return searchTask.count
  }
  
  func fetchFinishedWishes(category: Category) -> [Wish] {
    guard let realm = try? Realm() else { return [] }
    let searchTask = realm.objects(Wish.self).filter { ($0.isSuccess == true) && ($0.category == category.rawValue) }
    
    return searchTask.map { $0 }.sorted(by: Wish.finishOrder)
  }
  
  func getWishCount() -> Int {
    let realm = try! Realm()
    let searchTask = realm.objects(Wish.self).filter { $0.isSuccess == false }
    
    return searchTask.count
  }
  
  func getWishCount(category: Category) -> Int {
    let realm = try! Realm()
    let searchTask = realm.objects(Wish.self).filter { ($0.isSuccess == false) && ($0.category == category.rawValue) }
    
    return searchTask.count
  }
}
