//
//  ViewController.swift
//  Pomidor11
//
//  Created by Igor Kuzmin on 13.12.2021.
//

import UIKit

class ViewController: UIViewController {

    private lazy var isInProgress = false
    private lazy var state: State = .work
    private  var progress : CGFloat = CGFloat(-90) {
       didSet {
           createCircleProgressBar(oldValue)
        }
    }

    private lazy var counterLabel: UILabel = {
        let counterLabel = UILabel()
        counterLabel.text = Strings.counterLabelWorkTime
        counterLabel.font = .systemFont(ofSize: 55)
        if state == .work {
            counterLabel.textColor = .systemRed
        } else {
            counterLabel.textColor = .systemGreen
        }
        counterLabel.textAlignment = .center

        return counterLabel
    }()

    private lazy var startStopButton: UIButton = {
        let button = UIButton()
//        let sfSymbolsConfiguration =  UIImage.SymbolConfiguration(pointSize: 55)
        button.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: 55))?.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)
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
        if state == .work {
            progressBarLayer.strokeColor = UIColor.systemGreen.cgColor
        } else {
            progressBarLayer.strokeColor = UIColor.systemRed.cgColor
        }
        progressBarLayer.lineWidth = 2

        return progressBarLayer
    }()

    private lazy var progressBarBackground: CAShapeLayer = {
        let progressBarLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: view.center, radius: 130, startAngle: -CGFloat.pi/2, endAngle: 3*CGFloat.pi/2, clockwise: true)
        progressBarLayer.lineCap = CAShapeLayerLineCap.round
        progressBarLayer.fillColor = nil
        if state == .work {
            progressBarLayer.strokeColor = UIColor.systemRed.cgColor
        } else {
            progressBarLayer.strokeColor = UIColor.systemGreen.cgColor
        }
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
        if isInProgress  {
            isInProgress = false
            switch state {
                case .work:
                    startStopButton.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: 55))?.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)
                case .rest:
                    startStopButton.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: 55))?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal), for: .normal)
            }
        } else {
            isInProgress = true
            switch state {
                case .work:
                    startStopButton.setImage(UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 55))?.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)
                case .rest:
                    startStopButton.setImage(UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 55))?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal), for: .normal)
            }
        }

        if progress == -90 {
            if state == .work {
                progress += 360 / (CGFloat(Float(Strings.counterLabelWorkTime.dropLast(3))!) * 60.0 + CGFloat(Float(Strings.counterLabelWorkTime.dropFirst(3))!))
            } else {
                progress += 360 / (CGFloat(Float(Strings.counterLabelRestTime.dropLast(3))!) * 60.0 + CGFloat(Float(Strings.counterLabelRestTime.dropFirst(3))!))
            }
        }

        var minutesInLabel = Int(counterLabel.text!.dropLast(3))!
        var secondsInLabeel = Int(counterLabel.text!.dropFirst(3))!

        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [self] timer in
            if isInProgress == false {
                print("break")
                timer.invalidate()
                print("timer is invalidated")
                return
            }

            if progress <= 270 {

                if state == .work {
                    progress += 360 / (CGFloat(Float(Strings.counterLabelWorkTime.dropLast(3))!) * 60.0 + CGFloat(Float(Strings.counterLabelWorkTime.dropFirst(3))!))
                } else {
                    progress += 360 / (CGFloat(Float(Strings.counterLabelRestTime.dropLast(3))!) * 60.0 + CGFloat(Float(Strings.counterLabelRestTime.dropFirst(3))!))
                }

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

                if minutesInLabel >= 10 {
                    if secondsInLabeel >= 10 {
                        counterLabel.text = String(minutesInLabel) + ":" + String(secondsInLabeel)
                    } else if secondsInLabeel >= 0 && secondsInLabeel < 10 {
                        counterLabel.text = String(minutesInLabel) + ":0" + String(secondsInLabeel)
                    }
                } else if minutesInLabel > 0 && minutesInLabel < 10 {
                    if secondsInLabeel >= 10 {
                        counterLabel.text = "0" + String(minutesInLabel) + ":" + String(secondsInLabeel)
                    } else if secondsInLabeel > 0 && secondsInLabeel < 10 {
                        counterLabel.text = "0" + String(minutesInLabel) + ":0" + String(secondsInLabeel)
                    } else {
                        counterLabel.text = "0" + String(minutesInLabel) + ":0" + String(secondsInLabeel)
                    }
                } else {
                    if secondsInLabeel >= 10 {
                        counterLabel.text = "0" + String(minutesInLabel) + ":" + String(secondsInLabeel)
                    } else if secondsInLabeel > 0 && secondsInLabeel < 10 {
                        counterLabel.text = "0" + String(minutesInLabel) + ":0" + String(secondsInLabeel)
                    } else {
                        switch state {
                            case .work:
                                state = .rest
                                print(state)
                                counterLabel.text = Strings.counterLabelRestTime
                                isInProgress = false
                                startStopButton.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: 55))?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal), for: .normal)
                                invertColors()
                                progress = -90
                                timer.invalidate()
                            case .rest:
                                state = .work
                                print(state)
                                counterLabel.text = Strings.counterLabelWorkTime
                                isInProgress = false
                                startStopButton.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: 55))?.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)
                                invertColors()
                                progress = -90
                                timer.invalidate()
                        }
                    }
                }


            }
        })
    }

    func invertColors() {
        switch state {
            case .work:
                progressBarBackground.strokeColor = UIColor.systemRed.cgColor
                progressBar.strokeColor = UIColor.systemGreen.cgColor
                progress = -90
                startStopButton.tintColor = UIColor.systemRed
                counterLabel.textColor = UIColor.systemRed
            case .rest:
                progressBarBackground.strokeColor = UIColor.systemGreen.cgColor
                progressBar.strokeColor = UIColor.systemRed.cgColor
                progress = -90
                startStopButton.tintColor = UIColor.systemGreen
                counterLabel.textColor = UIColor.systemGreen
        }
    }

    @objc func buttonAction(sender: UIButton) {
        startTimer()
    }
}

//MARK: Constants

enum Metrics {
    static let stackViewSpacing: CGFloat = 30
}


enum Strings {
    static let counterLabelWorkTime = "00:10"
    static let counterLabelRestTime = "00:15"
}

enum State {
    case work
    case rest
}
