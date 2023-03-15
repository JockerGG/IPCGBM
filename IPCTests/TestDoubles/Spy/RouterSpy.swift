//
//  RouterSpy.swift
//  IPCTests
//
//  Created by Eduardo García González on 15/03/23.
//

import Foundation

@testable import IPC
import Foundation
import UIKit

final class RouterSpy: Router {
    // MARK: - Spy: Router
    var rootGetterCalled: Bool { rootGetterCallCount > 0 }
    var rootGetterCallCount: Int = 0
    var rootSetterCalled: Bool { rootSetterCallCount > 0 }
    var rootSetterCallCount: Int = 0
    var rootParameter: UIViewController?
    var rootParameterList: [UIViewController?] = []
    var stubbedRoot: UIViewController? = nil

    var root: UIViewController? {
        get {
            rootGetterCallCount += 1
            return stubbedRoot
        }
        set {
            rootSetterCallCount += 1
            rootParameter = newValue
            rootParameterList.append(newValue)
        }
    }
    var presentCalled: Bool { presentCallCount > 0 }
    var presentCallCount: Int = 0
    var presentParameters: (viewController: UIViewController, animated: Bool)?
    var presentParameterList: [(viewController: UIViewController, animated: Bool)] = []

    func present(_ viewController: UIViewController, animated: Bool) {
        presentCallCount += 1
        presentParameters = (viewController, animated)
        presentParameterList.append((viewController, animated))
    }

    var pushCalled: Bool { pushCallCount > 0 }
    var pushCallCount: Int = 0
    var pushParameters: (viewController: UIViewController, animated: Bool)?
    var pushParameterList: [(viewController: UIViewController, animated: Bool)] = []

    func push(_ viewController: UIViewController, animated: Bool) {
        pushCallCount += 1
        pushParameters = (viewController, animated)
        pushParameterList.append((viewController, animated))
    }

    var popCalled: Bool { popCallCount > 0 }
    var popCallCount: Int = 0
    var popParameters: (animated: Bool, completion: (() -> Void)?)?
    var popParameterList: [(animated: Bool, completion: (() -> Void)?)] = []
    var popCompletionShouldInvoke: Bool = false

    func pop(animated: Bool, completion: (() -> Void)?) {
        popCallCount += 1
        popParameters = (animated, completion)
        popParameterList.append((animated, completion))
        if popCompletionShouldInvoke {
            completion?()
        }
    }

    var dismissCalled: Bool { dismissCallCount > 0 }
    var dismissCallCount: Int = 0
    var dismissParameters: (animated: Bool, completion: (() -> Void)?)?
    var dismissParameterList: [(animated: Bool, completion: (() -> Void)?)] = []
    var dismissCompletionShouldInvoke: Bool = false

    func dismiss(animated: Bool, completion: (() -> Void)?) {
        dismissCallCount += 1
        dismissParameters = (animated, completion)
        dismissParameterList.append((animated, completion))
        if dismissCompletionShouldInvoke {
            completion?()
        }
    }

    var setRootCalled: Bool { setRootCallCount > 0 }
    var setRootCallCount: Int = 0
    var setRootParameters: (viewController: UIViewController, animated: Bool)?
    var setRootParameterList: [(viewController: UIViewController, animated: Bool)] = []

    func setRoot(_ viewController: UIViewController, animated: Bool) {
        setRootCallCount += 1
        setRootParameters = (viewController, animated)
        setRootParameterList.append((viewController, animated))
    }

    var popToRootViewControllerCalled: Bool { popToRootViewControllerCallCount > 0 }
    var popToRootViewControllerCallCount: Int = 0
    var popToRootViewControllerParameters: (animated: Bool, completion: (() -> Void)?)?
    var popToRootViewControllerParameterList: [(animated: Bool, completion: (() -> Void)?)] = []
    var popToRootViewControllerCompletionShouldInvoke: Bool = false

    func popToRootViewController(animated: Bool, completion: (() -> Void)?) {
        popToRootViewControllerCallCount += 1
        popToRootViewControllerParameters = (animated, completion)
        popToRootViewControllerParameterList.append((animated, completion))
        if popToRootViewControllerCompletionShouldInvoke {
            completion?()
        }
    }
}
