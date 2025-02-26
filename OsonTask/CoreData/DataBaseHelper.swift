//
//  DataBaseHelper.swift
//  OsonTask
//
//  Created by Abdulloh Murodilloyev on 26/02/25.
//

import Foundation
import CoreData

class DataBaseHelper {
    static let shared = DataBaseHelper()
    
    private init() {}
    
    private let context = CoreDataManager.shared.context
    
    // MARK: - Save Methods
    
    /// Todosni CoreData-ga saqlaydi (eski ma'lumotlarni o‘chirib bo‘lgach).
    func saveTodosToCoreData(todos: [TodosModel]) {
        clearTodosFromCoreData()
        context.processPendingChanges() // Eski obyektlar butunlay o‘chib bo‘lishi uchun
        
        let sortedTodos = todos.sorted { $0.id < $1.id }
        
        sortedTodos.forEach { todo in
            let entity = TodosEntity(context: context)
            entity.id = Int16(todo.id)
            entity.userId = Int16(todo.userId)
            entity.title = todo.title
            entity.completed = todo.completed
        }
        
        saveContext()
    }
    
    /// Userlarni CoreData-ga saqlaydi (eski ma'lumotlarni o‘chirib bo‘lgach).
    func saveUsersToCoreData(users: [UserModel]) {
        clearUsersFromCoreData()
        context.processPendingChanges()
        
        users.forEach { user in
            let entity = UserEntity(context: context)
            entity.id = Int16(user.id)
            entity.name = user.name
            entity.username = user.username
            entity.email = user.email
            entity.phone = user.phone
            entity.website = user.website
            
            // Addressni saqlash
            let addressEntity = AddressEntity(context: context)
            addressEntity.street = user.address.street
            addressEntity.suite = user.address.suite
            addressEntity.city = user.address.city
            addressEntity.zipcode = user.address.zipcode
            entity.address = addressEntity
        }
        
        saveContext()
    }
    
    // MARK: - Fetch Methods
    
    /// Todosni CoreData-dan oladi, ID bo‘yicha tartiblangan holda qaytaradi.
    func fetchTodosFromCoreData() -> Result<[TodosModel], Error> {
        let fetchRequest: NSFetchRequest<TodosEntity> = TodosEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
            let entities = try context.fetch(fetchRequest)
            let todos = entities.map { entity in
                TodosModel(
                    userId: Int(entity.userId),
                    id: Int(entity.id),
                    title: entity.title ?? "",
                    completed: entity.completed
                )
            }
            return .success(todos)
        } catch {
            print("❌ Todos fetch qilishda xatolik:", error.localizedDescription)
            return .failure(error)
        }
    }
    
    /// Userlarni CoreData-dan oladi, ID bo‘yicha tartiblangan holda qaytaradi.
    func fetchUsersFromCoreData() -> Result<[UserModel], Error> {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
            let entities = try context.fetch(fetchRequest)
            let users = entities.map { entity in
                UserModel(
                    id: Int(entity.id),
                    name: entity.name ?? "",
                    username: entity.username ?? "",
                    email: entity.email ?? "",
                    address: Address(
                        street: entity.address?.street ?? "",
                        suite: entity.address?.suite ?? "",
                        city: entity.address?.city ?? "",
                        zipcode: entity.address?.zipcode ?? "",
                        geo: Geo(lat: "", lng: "")
                    ),
                    phone: entity.phone ?? "",
                    website: entity.website ?? "",
                    company: Company(name: "", catchPhrase: "", bs: "")
                )
            }
            return .success(users)
        } catch {
            print("❌ Users fetch qilishda xatolik:", error.localizedDescription)
            return .failure(error)
        }
    }
    
    // MARK: - Delete Methods
    
    /// CoreData-dagi barcha Todos ma'lumotlarini o‘chiradi.
    func clearTodosFromCoreData() {
        let fetchRequest: NSFetchRequest<TodosEntity> = TodosEntity.fetchRequest()
        
        do {
            let todos = try context.fetch(fetchRequest)
            todos.forEach { context.delete($0) }
            saveContext()
            print("🗑 Todos tozalandi")
        } catch {
            print("❌ Todos tozalashda xatolik:", error.localizedDescription)
        }
    }
    
    /// CoreData-dagi barcha Users ma'lumotlarini o‘chiradi.
    func clearUsersFromCoreData() {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let users = try context.fetch(fetchRequest)
            users.forEach { context.delete($0) }
            saveContext()
            print("🗑 Users tozalandi")
        } catch {
            print("❌ Users tozalashda xatolik:", error.localizedDescription)
        }
    }
    
    // MARK: - Private Methods
    
    /// CoreData kontekstni saqlaydi va xatoliklarni tekshiradi.
    private func saveContext() {
        do {
            try context.save()
            print("✅ CoreData muvaffaqiyatli saqlandi")
        } catch {
            print("❌ CoreData saqlashda xatolik:", error.localizedDescription)
        }
    }
}
