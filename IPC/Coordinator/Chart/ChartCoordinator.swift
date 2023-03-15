//
//  ChartCoordinator.swift
//  IPC
//
//  Created by Eduardo García González on 15/03/23.
//

import Foundation
import UIKit

final class ChartCoordinator: Coordinator {
    internal var child: [Coordinator] = []
    internal weak var parentViewController: UIViewController?
    internal var router: Router
    
    private lazy var nextViewController: ChartViewController = {
        let ipcRepository = IPCRepository(service: NetworkServiceImplementation(session: URLSession.shared), request: IPCRequest())
        return ChartViewController(viewModel: .init(ipcRepository: ipcRepository))
    }()
    
    init(parentViewController: UIViewController?, router: Router? = nil) {
        self.parentViewController = parentViewController
        
        if let router {
            self.router = router
        } else {
            self.router = RouterImplementation(root: parentViewController)
        }
    }
    
    func start() {
        router.setRoot(nextViewController, animated: true)
    }
}
