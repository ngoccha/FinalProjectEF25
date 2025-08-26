//
//  ReminderRealmManager.swift
//  ReminderFinalProjectEF25
//
//  Created by Ngoc Ha on 26/8/25.
//


import Foundation
import RealmSwift

final class ReminderRealmManager {
    static let shared = ReminderRealmManager()
    
    private let realm: Realm
    
    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to open Realm: \(error)")
        }
    }
    
    func add(_ reminder: Reminder) {
        do {
            try realm.write {
                realm.add(reminder)
            }
        } catch {
            print("Error adding reminder: \(error)")
        }
    }
    
    func getAll() -> Results<Reminder> {
        return realm.objects(Reminder.self).sorted(byKeyPath: "createdAt", ascending: true)
    }
    
    func update(_ block: () -> Void) {
        do {
            try realm.write {
                block()
            }
        } catch {
            print("Error updating reminder: \(error)")
        }
    }
    
    func delete(_ reminder: Reminder) {
        if let objRealm = reminder.realm, !reminder.isInvalidated {
            do {
                try objRealm.write {
                    objRealm.delete(reminder)
                }
            } catch {
                print("Error deleting reminder: \(error)")
            }
        }
    }

}
