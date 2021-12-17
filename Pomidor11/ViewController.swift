//
//  ViewController.swift
//  Pomidor11
//
//  Created by Igor Kuzmin on 13.12.2021.
//

import UIKit

//@IBDesignable class ProgressBar: UIView {
//
//    var progress: CGFloat = 0 {
//        didSet { setNeedsDisplay() }
//    }
//
//    private var progressBarLayer = CAShapeLayer()
//    private var backgroundMask = CAShapeLayer()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupLayers()
//
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupLayers()
//    }
//
//    private func setupLayers() {
//        backgroundMask.lineWidth = 5
//        backgroundMask.fillColor = nil
//        backgroundMask.strokeColor = UIColor.systemPink.cgColor
//        layer.mask = backgroundMask
//
//        progressBarLayer.lineWidth = 5
//        progressBarLayer.fillColor = nil
//        layer.addSublayer(progressBarLayer)
//        layer.transform = CATransform3DMakeRotation(CGFloat(90 * Double.pi / 180), 0, 0, -1)
//    }
//
//    override func draw(_ rect: CGRect) {
//        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: 5 / 2, dy: 5 / 2))
//        backgroundMask.path = circlePath.cgPath
//
//        progressBarLayer.path = circlePath.cgPath
//        progressBarLayer.lineCap = .round
//        progressBarLayer.strokeStart = 0
//        progressBarLayer.strokeEnd = progress
//        progressBarLayer.strokeColor = UIColor.systemRed.cgColor
//    }
//}



enum State {
    case work
    case rest
}

class ViewController: UIViewController {

    private let progressBarLayer = CAShapeLayer()

    private lazy var isTimerRunning = false
    private lazy var state: State = .rest
    private  var progress : CGFloat = CGFloat(360) {
       didSet {
            createCircleProgressBar(oldValue)
        }
    }

    private lazy var counterLabel: UILabel = {
        let counterLabel = UILabel()
        counterLabel.text = "25:00"
        counterLabel.font = .systemFont(ofSize: 55)
        counterLabel.textColor = .systemRed
        counterLabel.textAlignment = .center

        return counterLabel
    }()

    private lazy var switchStateButton: UIButton = {
        let button = UIButton()
        let sfSymbolsConfiguration =  UIImage.SymbolConfiguration(pointSize: 55)
        button.setImage(UIImage(systemName: "play", withConfiguration: sfSymbolsConfiguration)?.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)

        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metrics.stackViewSpacing
        stackView.distribution = .equalSpacing

        return stackView
    }()

//    private lazy var progressBar: ProgressBar = {
//        var progressBar = ProgressBar()
//
//        var progressBarLayer : CAShapeLayer = CAShapeLayer()
//
//        progressBarLayer.lineCap = CAShapeLayerLineCap.round
//        progressBarLayer.fillColor = UIColor.clear.cgColor
//        progressBarLayer.strokeColor = UIColor.red.cgColor
//        progressBarLayer.lineWidth = 5
//
//        return progressBarLayer
//    }()


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
//        createCircleProgressBar()


    }

    // MARK: Settings

    private func setupHierarchy() {
        view.layer.addSublayer(progressBarBackground)
        view.layer.addSublayer(progressBar)

        view.addSubview(stackView)
        stackView.addArrangedSubview(counterLabel)
        stackView.addArrangedSubview(switchStateButton)
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

        for i in -90...270 {
            progress = CGFloat(i)
        }
    }

}

//MARK: Constants

enum Metrics {
    static let stackViewSpacing: CGFloat = 30
}


enum Strings {

}
