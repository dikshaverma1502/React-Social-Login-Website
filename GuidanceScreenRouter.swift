import UIKit

protocol GuidanceScreenRouterProtocol {
    func addChildVC(_ viewController: UIViewController, animated: Bool)
}

final class GuidanceScreenRouter: GuidanceScreenRouterProtocol {
    weak var viewController: GuidanceScreenViewController?
    func addChildVC(_ vc: UIViewController, animated: Bool) {
        guard let parentVC = viewController else { return }
        DispatchQueue.onMainIfRequired {
            UIHelper.addChildViewController(vc, onParent: parentVC)
        }
    }
    
}
