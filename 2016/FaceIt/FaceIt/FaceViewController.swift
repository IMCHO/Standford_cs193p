//
//  ViewController.swift
//  FaceIt
//
//  Created by In Taek Cho on 2020-09-09.
//  Copyright © 2020 dlsxor21c. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.changeScale(recognizer:))))
            
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseHappiness))
            happierSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseHappiness))
            sadderSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            updateUI()  
        }
    }
    var expression: FacialExpression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile) {
        didSet {
            updateUI()
        }
    }
    private var mouthCurvature = [FacialExpression.Mouth.Frown:-1.0, .Grin:0.5, .Smile:1.0, .Smirk:-0.5, .Neutral:0.0]
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Relaxed:0.5, .Furrowed:-0.5, .Normal:0.0]
    
    private func updateUI() {
        switch expression.eyes {
        case .Open:
            faceView.eyesOpen = true
        case .Closed:
            faceView.eyesOpen = false
        case .Squinting:
            faceView.eyesOpen = false
        }
        faceView.mouthCurvature = mouthCurvature[expression.mouth] ?? 0.0
        faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
    }
    
    @IBAction func toggleEyes(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            switch expression.eyes {
            case .Open:
                expression.eyes = .Closed
            case .Closed:
                expression.eyes = .Open
            case .Squinting:
                break
            }
        }
    }
    
    @objc private func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    @objc private func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
}

