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
    private  var progress : CGFloat = Metrics.progressBarStartPosition {
       didSet {
           modifyProgressBar(oldValue)
        }
    }

    private lazy var counterLabel: UILabel = {
        let counterLabel = UILabel()
        counterLabel.text = Strings.counterLabelWorkTime
        counterLabel.font = .systemFont(ofSize: Metrics.startStopButtonSize)
        counterLabel.textColor = Metrics.workColor
        counterLabel.textAlignment = .center

        return counterLabel
    }()

    private lazy var startStopButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: Metrics.startStopButtonSize))?.withTintColor(Metrics.workColor, renderingMode: .alwaysOriginal), for: .normal)
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
        progressBarLayer.strokeColor = Metrics.restColor.cgColor
        progressBarLayer.lineWidth = Metrics.progressBarWidth

        return progressBarLayer
    }()

    private lazy var progressBarBackground: CAShapeLayer = {
        let progressBarLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: view.center, radius: CGFloat(view.frame.width / 2 - Metrics.circleConstraints), startAngle: -CGFloat.pi/2, endAngle: 3*CGFloat.pi/2, clockwise: true)
        progressBarLayer.lineCap = CAShapeLayerLineCap.round
        progressBarLayer.fillColor = nil
        progressBarLayer.strokeColor = Metrics.workColor.cgColor
        progressBarLayer.lineWidth = Metrics.progressBarWidth
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

    private func modifyProgressBar(_ progress: CGFloat) {
        let circularPath = UIBezierPath(arcCenter: view.center, radius: CGFloat(view.frame.width / 2 - Metrics.circleConstraints), startAngle: (Metrics.progressBarStartPosition * CGFloat.pi / 180), endAngle: (progress * CGFloat.pi / 180), clockwise: true)
        progressBar.path = circularPath.cgPath
    }

    private func startTimer() {
        //??????????/?????????? ??????????????
        if isInProgress  {
            isInProgress = false
            switch state {
                case .work:
                    startStopButton.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: Metrics.startStopButtonSize))?.withTintColor(Metrics.workColor, renderingMode: .alwaysOriginal), for: .normal)
                case .rest:
                    startStopButton.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: Metrics.startStopButtonSize))?.withTintColor(Metrics.restColor, renderingMode: .alwaysOriginal), for: .normal)
            }
        } else {
            isInProgress = true
            switch state {
                case .work:
                    startStopButton.setImage(UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: Metrics.startStopButtonSize))?.withTintColor(Metrics.workColor, renderingMode: .alwaysOriginal), for: .normal)
                case .rest:
                    startStopButton.setImage(UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: Metrics.startStopButtonSize))?.withTintColor(Metrics.restColor, renderingMode: .alwaysOriginal), for: .normal)
            }
        }

        // ???????????? ?????? ???????????????? ????????
        if progress == Metrics.progressBarStartPosition {
            if state == .work {
                progress += Metrics.fullCircle / (CGFloat(Float(Strings.counterLabelWorkTime.dropLast(3))!) * Metrics.secInMin + CGFloat(Float(Strings.counterLabelWorkTime.dropFirst(3))!))
            } else {
                progress += Metrics.fullCircle / (CGFloat(Float(Strings.counterLabelRestTime.dropLast(3))!) * Metrics.secInMin + CGFloat(Float(Strings.counterLabelRestTime.dropFirst(3))!))
            }
        }

        // ?????????????????? ?????????????????? ???????????????? ???????????? ?? ???????????? ?? ??????????????
        var minutesInLabel = Int(counterLabel.text!.dropLast(3))!
        var secondsInLabeel = Int(counterLabel.text!.dropFirst(3))!

        // ?????????????????????????????? ????????????
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [self] timer in
            // ?????????????????? ?????????????? ?????????? ???????????????? ??????????
            // ???? ?????? ???????????????? - ???????????? ???? ???????????? ??????????????????????, ?? ???????? ???????????? ???????????? ??????????/??????????, ???? ?????????????????? ??????????????????????
            guard isInProgress else {
                timer.invalidate()
                print("timer is invalidated")
                return
            }

            // ???????????????????? ???????????????????? UI ???????? ???????????????? ?????? ???? ????????????????????
            if progress <= Metrics.progressBarEndPosition {
                print("inside")
                // ?????? ?????? ?????????? ???????????? ?? ???????????? ????????????, ?????????????????????? ???????????????????? ???? ???????????? ????????????????, ?????????????????? ???????????????? ???????????? ???? ?????????????????? ???????????????? ?????????????? ?????? ???????????? ?? ????????????
                // ???????? ?????????? ?????????????? ???????????? ??????????/???????? ???????????????????? ???????????? ??????
                if state == .work {
                    progress += Metrics.fullCircle / (CGFloat(Float(Strings.counterLabelWorkTime.dropLast(3))!) * Metrics.secInMin + CGFloat(Float(Strings.counterLabelWorkTime.dropFirst(3))!))
                } else {
                    progress += Metrics.fullCircle / (CGFloat(Float(Strings.counterLabelRestTime.dropLast(3))!) * Metrics.secInMin + CGFloat(Float(Strings.counterLabelRestTime.dropFirst(3))!))
                }
//                ?????????????? ?????? ???? ?????????? ?????????????? ?????????????? ???? ?????? ???????? ????????????????????
//
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "mm:ss"
//                print(dateFormatter.date(from: counterLabel.text!)!)
//                print(dateFormatter.date(from: "00:01")!)
//                counterLabel.text = dateFormatter.string(from: (dateFormatter.date(from: counterLabel.text!)! - dateFormatter.date(from: "00:01")!))

                // ???????????? ?????????????????? ???????????????? ??????????/???????????? ?? ????????????, ?????????? ???????????? ???????? ????????, ???? ?????? ???????????????????? ???????????????? ??????????
                if secondsInLabeel == 0 {
                    secondsInLabeel = 59
                    minutesInLabel -= 1
                } else {
                    secondsInLabeel -= 1
                }

                // ?????????????????? ???????????????? ???????????????????? Int ?? "????????????????????" String ?????? ???????????? ??????????????
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
                        // ???????????? ?????????????? ???? 00:00
                        switch state {
                            case .work:
                                state = .rest
                                print(state)
                                counterLabel.text = Strings.counterLabelRestTime
                                isInProgress = false
                                invertColors()
                                timer.invalidate()
                            case .rest:
                                state = .work
                                print(state)
                                counterLabel.text = Strings.counterLabelWorkTime
                                isInProgress = false
                                invertColors()
                                timer.invalidate()
                        }
                    }
                }
            }
        })
    }

    // ???????????? ?????????? ?? ?????????????????????? ???? ???????????? ???????????? ??????????????
    func invertColors() {
        switch state {
            case .work:
                progressBarBackground.strokeColor = Metrics.workColor.cgColor
                progressBar.strokeColor = Metrics.restColor.cgColor
                // ?????????? ???? ?????????? ?????? ????????, ???????? 1 ?????? ???????????????? ??????????, ???? ???? ???????????????????????? ?????????????????? ????????????????????????, ???????????????? ???????? ?????? ???? ???????????? ?? modifyProgressBar, ???? ???????)
                progress = Metrics.progressBarStartPosition
                progress = Metrics.progressBarStartPosition
                startStopButton.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: Metrics.startStopButtonSize))?.withTintColor(Metrics.workColor, renderingMode: .alwaysOriginal), for: .normal)
                counterLabel.textColor = Metrics.workColor
            case .rest:
                progressBarBackground.strokeColor = Metrics.restColor.cgColor
                progressBar.strokeColor = Metrics.workColor.cgColor
                progress = Metrics.progressBarStartPosition
                progress = Metrics.progressBarStartPosition
                startStopButton.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: Metrics.startStopButtonSize))?.withTintColor(Metrics.restColor, renderingMode: .alwaysOriginal), for: .normal)
                counterLabel.textColor = Metrics.restColor
        }
    }

    // ?????????? ?????? ???? ???????????? ???? ?????????????????? ?????????????? ???? ?? ?????????? ?????? ?? ???????? ????????????????????
    @objc func buttonAction(sender: UIButton) {
        startTimer()
    }
}

//MARK: Constants

enum Metrics {
    static let stackViewSpacing: CGFloat = 30
    static let progressBarStartPosition: CGFloat = -90
    static let progressBarEndPosition: CGFloat = 270
    static let fullCircle: CGFloat = 360
    static let secInMin: CGFloat = 60
    static let workColor = UIColor.systemRed
    static let restColor = UIColor.systemGreen
    static let circleConstraints: CGFloat = 32
    static let progressBarWidth: CGFloat = 2
    static let startStopButtonSize: CGFloat = 55
}


enum Strings {
    static let counterLabelWorkTime = "00:10"
    static let counterLabelRestTime = "00:15"
}

enum State {
    case work
    case rest
}
