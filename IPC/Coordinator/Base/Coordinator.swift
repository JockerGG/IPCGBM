//
//  Coordinator.swift
//  IPC
//
//  Created by Eduardo García González on 12/03/23.
//

import UIKit

protocol Coordinator: AnyObject {
    /// Child coordinators that can be added to the same flow
    var child: [Coordinator] { get set }
    /// The parent view controller that will present the new controller. 
    var parentViewController: UIViewController? { get set }
    /// The router that will handle the navigation.
    var router: Router { get set }
    /// Function to start the flow
    func start()
    /// Add child coordinators to the flow.
    func add(coordinator: Coordinator)
    /// Remove child coorniators when the flow overs.
    func remove(coordinator: Coordinator?)
}

extension Coordinator {
    func add(coordinator: Coordinator) {
        /// Verify if the coordinator is not included in the `child` array.
        /// We are comparing if both elements have the same memory reference
        guard !child.contains(where: { coordinator === $0 }) else { return }
        /// Add to the `child` array.
        child.append(coordinator)
    }
    
    func remove(coordinator: Coordinator?) {
        /// 1. Verify if the coordinator is not nil.
        /// 2. Verify if the `child` array is not empty.
        /// 3. Verify if the `index` exist.
        /// 4. Remove the coordinator from the `child` array.
        guard let coordinator = coordinator,
              !child.isEmpty,
              let index = child.firstIndex(where: { coordinator === $0 }) else {
            return
        }
        
        child.remove(at: index)
    }
}
