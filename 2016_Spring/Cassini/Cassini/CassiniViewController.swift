//
//  CassiniViewController.swift
//  Cassini
//
//  Created by In Taek Cho on 2020-09-30.
//

import UIKit

class CassiniViewController: UIViewController {
    private struct Storyboard {
        static let showImageSegue = "Show Image"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        var destinationVC = segue.destination
//        if let navcon = destinationVC as? UINavigationController {
//            destinationVC = navcon.visibleViewController ?? destinationVC
//        }
        
        if segue.identifier == Storyboard.showImageSegue {
            if let iVC = segue.destination.contentViewController as? ImageViewController {
//                if let sendingButton = sender as? UIButton {
//                    let imageName = sendingButton.currentTitle
//                }
                let imageName = (sender as? UIButton)?.currentTitle
                iVC.imageURL = DemoURL.NASAImageNamed(imageName: imageName)
                iVC.title = imageName
//                print(iVC)
            } else {
                print("fail")
            }
        }
    }
    
    @IBAction func showImage(_ sender: UIButton) {
        if let iVC = splitViewController?.viewControllers.last?.contentViewController as? ImageViewController {
            let imageName = sender.currentTitle
            iVC.imageURL = DemoURL.NASAImageNamed(imageName: imageName)
            iVC.title = imageName
        } else {
            performSegue(withIdentifier: Storyboard.showImageSegue, sender: sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}

extension CassiniViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        print("hello")
        if primaryViewController.contentViewController == self {
            if let iVC = secondaryViewController.contentViewController as? ImageViewController {
                if iVC.imageURL == nil {
                    return true
                }
            }
        }
        return false
    }
}
