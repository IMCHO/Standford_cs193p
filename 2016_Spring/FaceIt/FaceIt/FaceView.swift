//
//  FaceView.swift
//  FaceIt
//
//  Created by In Taek Cho on 2020-09-09.
//  Copyright © 2020 dlsxor21c. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable
    var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var mouthCurvature: Double = 0.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var eyesOpen: Bool = false { didSet { setNeedsDisplay() } }
    @IBInspectable
    var eyeBrowTilt: Double = 0.5 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }
    
    @objc func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch  recognizer.state {
        case .changed, .ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }

    private var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
//    lazy private var skullRadius = min(bounds.size.width, bounds.size.height) / 2 * scale
//    lazy private var skullCenter = CGPoint(x: bounds.midX, y: bounds.midY)

    private struct Ratios {
        static let SkullRadiusToEyeOffest: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
        static let SkullRadiusToBrowOffset: CGFloat = 5
    }
    
    enum Eye {
        case Left
        case Right
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2 * Double.pi),
            clockwise: true
        )
        path.lineWidth = lineWidth
        return path

    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint {
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffest
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        
        switch eye {
        case .Left:
            eyeCenter.x -= eyeOffset
        case .Right:
            eyeCenter.x += eyeOffset
        }
        
        return eyeCenter
    }
    
    private func pathForEye(eye: Eye) -> UIBezierPath {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye: eye)
        
        if eyesOpen {
            return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
        } else {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            path.lineWidth = lineWidth
            return path
        }
    }
    
    private func pathForMount() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mountHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth / 2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mountHeight)
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        
        return path
    }
    
    private func pathForBrow(eye: Eye) -> UIBezierPath {
        var tilt = eyeBrowTilt
        
        switch eye {
        case .Left:
            tilt *= -1.0
        case .Right:
            break
        }
        
        var browCenter = getEyeCenter(eye: eye)
        browCenter.y -= skullRadius / Ratios.SkullRadiusToBrowOffset
        
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let tiltOffest = CGFloat(max(-1, min(tilt, 1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffest)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffest)
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = lineWidth
        
        return path
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
//        var skullRadius = min(bounds.size.width, bounds.size.height) / 2 * scale
//        var skullCenter = CGPoint(x: bounds.midX, y: bounds.midY)

        
//        let skull = pathForCircleCenteredAtPoint(midPoint: skullCenter, withRadius: skullRadius)
        
//        skull.lineWidth = 5.0
        color.set()
//        skull.stroke()
        pathForCircleCenteredAtPoint(midPoint: skullCenter, withRadius: skullRadius).stroke()
        pathForEye(eye: .Left).stroke()
        pathForEye(eye: .Right).stroke()
        pathForMount().stroke()
        pathForBrow(eye: .Left).stroke()
        pathForBrow(eye: .Right).stroke()
    }
}
