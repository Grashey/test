//
//  ViewConteiner.swift
//  test
//
//  Created by Aleksandr Fetisov on 04.12.2020.
//

import UIKit
import MobileCoreServices

enum ViewContainerError: Error {
    case invalidType
    case unarchiveFailure
}

class ViewContainer: NSObject {
    
    let view: UIView
    
    required init(view: UIView) {
        self.view = view
    }
    
}

extension ViewContainer: NSItemProviderReading {
    
    static var readableTypeIdentifiersForItemProvider = [kUTTypeData as String]
    
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        if typeIdentifier == kUTTypeData as String {
            guard let view = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIView.self, from: data) else { throw ViewContainerError.unarchiveFailure }
            return self.init(view: view)
        } else {
            throw ViewContainerError.invalidType
        }
    }
}

extension ViewContainer: NSItemProviderWriting {
    
    static var writableTypeIdentifiersForItemProvider = [kUTTypeData as String]
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        if typeIdentifier == kUTTypeData as String {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: view, requiringSecureCoding: false)
                completionHandler(data, nil)
            } catch {
                print(error)
            }
        } else {
            completionHandler(nil, ViewContainerError.invalidType)
        }
        return nil
    }
}
