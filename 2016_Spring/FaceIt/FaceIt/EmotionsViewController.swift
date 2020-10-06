//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by In Taek Cho on 2020-09-21.
//  Copyright © 2020 dlsxor21c. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {
    
    private let emotionalFaces = ["angry" : FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, mouth: .Frown),
                                  "happy" : FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile),
                                  "worried" : FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smirk),
                                  "mischievious" : FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Grin)
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationVC = segue.destination
        if let navcon = destinationVC as? UINavigationController {
            destinationVC = navcon.visibleViewController ?? destinationVC
        }
        if let faceVC = destinationVC as? FaceViewController {
            if let identifier = segue.identifier {
                if let expression = emotionalFaces[identifier] {
                    faceVC.expression = expression
                    if let sendingButton = sender as? UIButton {
                        faceVC.navigationItem.title = sendingButton.currentTitle
                    }
                }
            }
        }
    }
}
