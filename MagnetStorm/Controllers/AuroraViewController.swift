//
//  AuroraViewController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 06.10.2023.
//

import UIKit
import SnapKit
import SDWebImage

final class AuroraViewController: UIViewController {
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    private var labelTimer: Timer?
    private var value: String = ""
    //MARK: Properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 10.0
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        return imageView
    }()
    private let auroraLabel: UILabel = {
        let auroraLabel = UILabel()
        auroraLabel.text = "titleAurora_text".localized()
        auroraLabel.font = UIFont.SFUITextHeavy(ofSize: 28)
        auroraLabel.textColor = .white
        return auroraLabel
    }()
    private let northActivityLabel: UILabel = {
        let northActivityLabel = UILabel()
        northActivityLabel.text = ""
        northActivityLabel.font = UIFont.SFUITextHeavy(ofSize: 100)
        northActivityLabel.textColor = .white
        northActivityLabel.isUserInteractionEnabled = true
        return northActivityLabel
    }()
    private let valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.text = "gigawatts".localized()
        valueLabel.font = UIFont.SFUITextMedium(ofSize: 18)
        valueLabel.textColor = .white
        valueLabel.numberOfLines = 0
        valueLabel.isUserInteractionEnabled = true
        return valueLabel
    }()
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "descriptionAurora_text".localized()
        descriptionLabel.font = UIFont.SFUITextMedium(ofSize: 20)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        descriptionLabel.isUserInteractionEnabled = true
        return descriptionLabel
    }()
    private let infoButton: UIButton = {
        let button = UIButton()
        let chevronImage = UIImage(systemName: "info.circle")
        button.setImage(chevronImage, for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    private let imageButton: UIButton = {
        let button = UIButton()
        button.setTitle("open_forecast".localized(), for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 18)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        return button
    }()
    private let bottomMarginView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.3)
        return view
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        return refreshControl
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        setupAuroraGIFBackground()
        setupTarget()
        setupGestures()
        fetchDataAndDisplayAuroraImage()
        fetchAuroraNowcastValue()
        animationLabels()
    }
    //MARK: Methods
    private func setupConstraint() {
        view.backgroundColor = .black
        view.addSubview(scrollView)
        scrollView.refreshControl = refreshControl
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(auroraLabel)
        auroraLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
        }
        scrollView.addSubview(northActivityLabel)
        northActivityLabel.snp.makeConstraints { make in
            make.top.equalTo(auroraLabel.snp.bottom).offset(0)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
        }
        scrollView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(northActivityLabel.snp.bottom).offset(0)
            make.centerX.equalToSuperview()
        }
        scrollView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        scrollView.addSubview(imageButton)
        imageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-60)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }

        view.addSubview(infoButton)
        infoButton.snp.makeConstraints { make in
            make.leading.equalTo(auroraLabel.snp.trailing).offset(10)
            make.centerY.equalTo(auroraLabel)
        }
        // tab bar background
        view.addSubview(bottomMarginView)
        bottomMarginView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-0)
        }
    }
    //MARK: GIF Background
    func setupAuroraGIFBackground() {
        let gifImageView = SDAnimatedImageView(frame: view.bounds)
        if let gifURL = Bundle.main.url(forResource: "AuroraBackground2", withExtension: "gif") {
            gifImageView.sd_setImage(with: gifURL)
        }
        view.addSubview(gifImageView)
        view.sendSubviewToBack(gifImageView)
    }
    
    private func fetchAuroraNowcastValue() {
        auroraNowcastValue { result in
            switch result {
            case .success(let value):
                print("Получено значение: \(value)")
                DispatchQueue.main.async {
                    self.northActivityLabel.text = value
                    self.animateNorthActivityLabelAppearance(withText: value)
                }
            case .failure(let error):
                print("Произошла ошибка: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchDataAndDisplayAuroraImage() {
        fetchHTMLData { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let html):
                    if let imageURL = extractLastImageURL(from: html) {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.imageView.alpha = 0.0
                        }) { _ in
                            UIView.animate(withDuration: 0.7) {
                                self.imageView.alpha = 1.0
                                self.loadAndDisplayImageFromURL(imageURL)
                            }
                        }
                    }
                case .failure(let error):
                    print("Error fetching HTML: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func loadAndDisplayImageFromURL(_ imageURL: String) {
        loadImage(imageURL, into: self.imageView)
    }
} // end
//MARK: Actions
extension AuroraViewController {
    private func setupGestures() {
        // тап по тексту и по цифру
        let northActivityLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(descriptionButtonTapped))
        northActivityLabel.addGestureRecognizer(northActivityLabelTapGesture)
        // тап по цифре
        let valueLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(descriptionButtonTapped))
        valueLabel.addGestureRecognizer(valueLabelTapGesture)
        
        let descriptionLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(descriptionButtonTapped))
        descriptionLabel.addGestureRecognizer(descriptionLabelTapGesture)
    }
    // targets
    private func setupTarget() {
        infoButton.addTarget(self, action: #selector(descriptionButtonTapped), for: .touchUpInside)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        imageButton.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
    }
    // refresh button action
    @objc private func refreshData() {
        print("refresh")
        fetchDataAndDisplayAuroraImage()
        fetchAuroraNowcastValue()
        animationLabels()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // Завершение обновления данных
            self?.refreshControl.endRefreshing()
        }
    }
    // description button action
    @objc private func descriptionButtonTapped() {
        print("descriptionButtonTappedAurora")
        feedbackGenerator.selectionChanged() // Добавьте виброотклик
        
        let descriptionViewController = AuroraDescriptionViewController()
        descriptionViewController.modalPresentationStyle = .popover
        present(descriptionViewController, animated: true, completion: nil)
    }
    
    @objc private func imageButtonTapped() {
        // Создайте контроллер для отображения полноразмерной картинки
        let fullScreenImageViewController = FullScreenImageViewController(image: imageView.image)
        fullScreenImageViewController.modalPresentationStyle = .popover
        present(fullScreenImageViewController, animated: true, completion: nil)
    }
}
//MARK: Animations
extension AuroraViewController {
    private func animationLabels() {
        animateAuroraLabelAppearance(withText: "titleAurora_text".localized())
        animateValueLabelAppearance(withText: "gigawatts".localized())
        animateDescriptionLabelAppearance(withText: "descriptionAurora_text".localized())
        animateNorthActivityLabelAppearance(withText: value)
    }
    
    private func animateAuroraLabelAppearance(withText text: String) {
        auroraLabel.alpha = 0.0 // Начнем с нулевой прозрачности
        auroraLabel.text = text // Устанавливаем текст
        
        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            self?.auroraLabel.alpha = 1.0 // Увеличиваем прозрачность до 1 (полностью видимый)
        }) { [weak self] (_) in
            self?.labelTimer?.invalidate() // По завершении анимации останавливаем таймер
        }
    }
    // Animate GeomagneticActivityLabel
    private func animateNorthActivityLabelAppearance(withText text: String) {
        northActivityLabel.alpha = 0.0 // Начнем с нулевой прозрачности
        northActivityLabel.text = text // Устанавливаем текст
        
        UIView.animate(withDuration: 1.2, animations: { [weak self] in
            self?.northActivityLabel.alpha = 1.0 // Увеличиваем прозрачность до 1 (полностью видимый)
        }) { [weak self] (_) in
            self?.labelTimer?.invalidate() // По завершении анимации останавливаем таймер
        }
    }
    private func animateValueLabelAppearance(withText text: String) {
        valueLabel.alpha = 0.0 // Начнем с нулевой прозрачности
        valueLabel.text = text // Устанавливаем текст
        
        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            self?.valueLabel.alpha = 1.0 // Увеличиваем прозрачность до 1 (полностью видимый)
        }) { [weak self] (_) in
            self?.labelTimer?.invalidate() // По завершении анимации останавливаем таймер
        }
    }
    private func animateDescriptionLabelAppearance(withText text: String) {
        descriptionLabel.alpha = 0.0 // Начнем с нулевой прозрачности
        descriptionLabel.text = text // Устанавливаем текст
        
        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            self?.descriptionLabel.alpha = 1.0 // Увеличиваем прозрачность до 1 (полностью видимый)
        }) { [weak self] (_) in
            self?.labelTimer?.invalidate() // По завершении анимации останавливаем таймер
        }
    }
}
