//
//  ViewController.swift
//  Building level
//
//  Created by macbook on 21.09.2023.
//

import UIKit
import CoreMotion

class MainViewController: UIViewController {

    //MARK: - Properties
    let motionManager = CMMotionManager()
    let bubbleView = UIView()
    let bubbleBackgroundForLabel = UIView()
    let degreeLabel = UILabel()
    let whiteStrip = UIView()
    let levelProgressView = UIProgressView(progressViewStyle: .default)
    var previousXAcceleration: Double = 0.0
    
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMotion()
    }

    //MARK: - UI Setup
    func setupUI() {
        view.backgroundColor = .systemGray
        
        bubbleView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        bubbleView.center = CGPoint(x: view.center.x, y: view.center.y - 50)
        bubbleView.layer.cornerRadius = bubbleView.frame.width / 2
        bubbleView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.addSubview(bubbleView)
        
         
      let whiteStripHeight: CGFloat = 3
            let whiteStripWidth: CGFloat = bubbleView.frame.width * 0.9
            let whiteStripX: CGFloat = (bubbleView.frame.width - whiteStripWidth) / 2
            let whiteStripY: CGFloat = bubbleView.frame.height / 2 - (whiteStripHeight / 2)
            let whiteStrip = UIView(frame: CGRect(x: whiteStripX, y: whiteStripY, width: whiteStripWidth, height: whiteStripHeight))
            whiteStrip.backgroundColor = .white
            bubbleView.addSubview(whiteStrip)
        
       
        bubbleBackgroundForLabel.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        bubbleBackgroundForLabel.center = CGPoint(x: bubbleView.center.x, y: bubbleView.center.y)
        bubbleBackgroundForLabel.layer.cornerRadius = bubbleBackgroundForLabel.frame.width / 2
        bubbleBackgroundForLabel.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.addSubview(bubbleBackgroundForLabel)
        
        degreeLabel.text = "0°"
        degreeLabel.textAlignment = .center
        degreeLabel.font = UIFont.boldSystemFont(ofSize: 26)
        degreeLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        degreeLabel.center = bubbleView.center
        view.addSubview(degreeLabel)
    }
    
    //MARK: - Motion Setup -
    func setupMotion() {
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.gyroUpdateInterval = 0.1
        
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let acceleration = data?.acceleration, error == nil else { return }
            self?.updateBubblePositionWith(acceleration)
        }
        
        motionManager.startGyroUpdates(to: .main) { [weak self] (data, error) in
            guard let rotationRate = data?.rotationRate, error == nil else { return }
            self?.rotateBubbleWith(rotationRate)
        }
    }
    
    //MARK: - Bubble Position -
    func updateBubblePositionWith(_ acceleration: CMAcceleration) {
        let xAcceleration = acceleration.x
        let yAcceleration = acceleration.y
        
        
        if xAcceleration > previousXAcceleration {
            let degrees = Int((xAcceleration * 90).rounded())
            self.degreeLabel.text = "\(degrees)"
        } else if xAcceleration < previousXAcceleration {
            let degrees = Int((-xAcceleration * 90).rounded())
            self.degreeLabel.text = "\(degrees)"
        } else {
            self.degreeLabel.text = "0"
        }
        
        previousXAcceleration = xAcceleration
        
        let angle = atan2(xAcceleration, -yAcceleration)
        
        let degrees = (angle * 180 / .pi)
        
        UIView.animate(withDuration: 0.1) {
            self.bubbleView.transform = CGAffineTransform(rotationAngle: CGFloat(-angle))
            
            self.degreeLabel.text = String(format: "%.0f°", degrees)

        }
    }
    
    //MARK: - Bubble Rotation -
    func rotateBubbleWith(_ rotationRate: CMRotationRate) {
        let xRotation = rotationRate.x
        let yRotation = rotationRate.y
    }
    
}

