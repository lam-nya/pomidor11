//
//  ViewController.swift
//  Pomidor11
//
//  Created by Igor Kuzmin on 13.12.2021.
//

import UIKit

enum State {
    case work
    case rest
}

class ViewController: UIViewController {

//    private let progressBarLayer = CAShapeLayer()
    private lazy var isTimerRunning = false
    private lazy var state: State = .rest
    private  var progress : CGFloat = CGFloat(-90) {
       didSet {
           createCircleProgressBar(oldValue)
           print(oldValue)
        }
    }

    private lazy var counterLabel: UILabel = {
        let counterLabel = UILabel()
        counterLabel.text = Strings.counterLabel
        counterLabel.font = .systemFont(ofSize: 55)
        counterLabel.textColor = .systemRed
        counterLabel.textAlignment = .center

        return counterLabel
    }()

    private lazy var startStopButton: UIButton = {
        let button = UIButton()
        let sfSymbolsConfiguration =  UIImage.SymbolConfiguration(pointSize: 55)
        button.setImage(UIImage(systemName: "play", withConfiguration: sfSymbolsConfiguration)?.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metrics.stackViewSpacing
        stackView.distribution = .equalSpacing

        return stackView
    }()

    private lazy var progressBar: CAShapeLayer = {
        let progressBarLayer = CAShapeLayer()
        progressBarLayer.lineCap = CAShapeLayerLineCap.round
        progressBarLayer.fillColor = UIColor.clear.cgColor
        progressBarLayer.strokeColor = UIColor.systemGreen.cgColor
        progressBarLayer.lineWidth = 4

        return progressBarLayer
    }()

    private lazy var progressBarBackground: CAShapeLayer = {
        let progressBarLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: view.center, radius: 130, startAngle: -CGFloat.pi/2, endAngle: 3*CGFloat.pi/2, clockwise: true)
        progressBarLayer.lineCap = CAShapeLayerLineCap.round
        progressBarLayer.fillColor = nil
        progressBarLayer.strokeColor = UIColor.systemRed.cgColor
        progressBarLayer.lineWidth = 2
        progressBarLayer.path = circularPath.cgPath

        return progressBarLayer
    }()



    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        setupView()
    }

    // MARK: Settings

    private func setupHierarchy() {
        view.layer.addSublayer(progressBarBackground)
        view.layer.addSublayer(progressBar)

        view.addSubview(stackView)
        stackView.addArrangedSubview(counterLabel)
        stackView.addArrangedSubview(startStopButton)
    }

    private func setupLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }

    private func setupView() {

    }

    // MARK: Prrivate functions

    private func createCircleProgressBar(_ progress: CGFloat) {
        let circularPath = UIBezierPath(arcCenter: view.center, radius: 130, startAngle: (-90 * CGFloat.pi / 180), endAngle: (progress * CGFloat.pi / 180), clockwise: true)
        progressBar.path = circularPath.cgPath
    }

    private func startTimer() {
        var minutesInLabel = Int(counterLabel.text!.dropLast(3))!
        var secondsInLabeel = Int(counterLabel.text!.dropFirst(3))!
        progress += 360 / (CGFloat(minutesInLabel) * 60)

        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [self] timer in
            if progress <= 270 {
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "mm:ss"
//                print(dateFormatter.date(from: counterLabel.text!)!)
//                print(dateFormatter.date(from: "00:01")!)
//                counterLabel.text = dateFormatter.string(from: (dateFormatter.date(from: counterLabel.text!)! - dateFormatter.date(from: "00:01")!))
                if secondsInLabeel == 0 {
                    secondsInLabeel = 59
                    minutesInLabel -= 1
                } else {
                    secondsInLabeel -= 1
                }
                if (minutesInLabel != 0) && (secondsInLabeel != 0) {
                    if secondsInLabeel < 10 {
                        counterLabel.text = String(minutesInLabel) + ":0" + String(secondsInLabeel)
                    } else {
                        counterLabel.text = String(minutesInLabel) + ":" + String(secondsInLabeel)
                    }
                } else {
                    counterLabel.text = "00:00"
                }
                progress += 360 / 15
                print("1")
            }
        })
    }

    @objc func buttonAction(sender: UIButton) {
        startTimer()
        print("Button tapped")
    }
}

//MARK: Constants

enum Metrics {
    static let stackViewSpacing: CGFloat = 30
}


enum Strings {
    static let counterLabel = "25:00"
}
