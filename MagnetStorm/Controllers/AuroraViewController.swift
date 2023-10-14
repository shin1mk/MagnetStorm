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
    private var isImageOpen = false
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
        auroraLabel.font = UIFont.SFUITextHeavy(ofSize: 35 )
        auroraLabel.textColor = .white
        return auroraLabel
    }()
    private let northActivityLabel: UILabel = {
        let northActivityLabel = UILabel()
        northActivityLabel.text = ""
        northActivityLabel.font = UIFont.SFUITextHeavy(ofSize: 100)
        northActivityLabel.textColor = .white
        return northActivityLabel
    }()
    private let valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.text = "GIGAWATTS"
        valueLabel.font = UIFont.SFUITextMedium(ofSize: 18)
        valueLabel.textColor = .white
        valueLabel.numberOfLines = 0
        return valueLabel
    }()
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "descriptionAurora_text".localized()
        descriptionLabel.font = UIFont.SFUITextMedium(ofSize: 25)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    private let refreshButton: UIButton = {
        let button = UIButton()
        let chevronImage = UIImage(systemName: "arrow.clockwise.circle")
        button.setImage(chevronImage, for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    private let descriptionButton: UIButton = {
        let button = UIButton()
        let chevronImage = UIImage(systemName: "info.circle")
        button.setImage(chevronImage, for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    private let chevronButton: UIButton = {
        let button = UIButton()
        let chevronImage = UIImage(systemName: "chevron.up.chevron.down")
        button.setImage(chevronImage, for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 2 // количество экранов
        pageControl.currentPage = 1 // текущий экран
        pageControl.pageIndicatorTintColor = UIColor.gray // Цвет точек
        pageControl.currentPageIndicatorTintColor = UIColor.white // Цвет текущей
        return pageControl
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        setupSwipeGesture()
        view.backgroundColor = .black
        //        setupAuroraGIFBackground()
        setupTarget()
        fetchDataAndDisplayAuroraImage()
        fetchAuroraNowcastValue()
        animationLabels()
    }
    //MARK: Methods
    private func setupConstraint() {
        navigationItem.hidesBackButton = true
        view.addSubview(auroraLabel)
        auroraLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
        }
        view.addSubview(northActivityLabel)
        northActivityLabel.snp.makeConstraints { make in
            make.top.equalTo(auroraLabel.snp.bottom).offset(0)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
        }
        view.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(northActivityLabel.snp.bottom).offset(0)
            make.centerX.equalToSuperview()
        }
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        // image north aurora
        view.addSubview(imageView)
        imageView.isHidden = true
        imageView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.35)
        }
        // buttons
        view.addSubview(refreshButton)
        refreshButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        view.addSubview(chevronButton)
        chevronButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        view.addSubview(descriptionButton)
        descriptionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        // page control
        view.addSubview(pageControl)
        pageControl.layer.zPosition = 100
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-60)
        }
    }
    //MARK: GIF Background
    func setupAuroraGIFBackground() {
        let gifImageView = SDAnimatedImageView(frame: view.bounds)
        if let gifURL = Bundle.main.url(forResource: "auroraBackground_gif", withExtension: "gif") {
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
//MARK: Gestures
extension AuroraViewController {
    // swipe back
    private func setupSwipeGesture() {
        // свайп назад на main VC
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight(_:)))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
        // tap по картинке
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        // свайп вверх для вызова описания
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUpGesture.direction = .up
        swipeUpGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeUpGesture)
        // свайп вниз для вызова описания
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        swipeDownGesture.direction = .down
        swipeDownGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeDownGesture)
        swipeUpGesture.require(toFail: swipeDownGesture) // зависимость между жестами
    }
    
    @objc private func handleSwipeRight(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func imageTapped() {
        // Создайте контроллер для отображения полноразмерной картинки
        let fullScreenImageViewController = FullScreenImageViewController(image: imageView.image)
        fullScreenImageViewController.modalPresentationStyle = .popover
        present(fullScreenImageViewController, animated: true, completion: nil)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if isImageOpen {
            return // Если картина уже открыта, игнорируем свайп вверх
        }
        
        feedbackGenerator.selectionChanged()
        imageView.alpha = 0.0 // Установите начальное значение прозрачности
        imageView.isHidden = false
        
        UIView.animate(withDuration: 0.7) {
            self.imageView.alpha = 1.0 // Увеличьте прозрачность до 1 (полностью видимое состояние)
        }
        isImageOpen = true
    }
    
    @objc private func handleSwipeDown(_ gesture: UISwipeGestureRecognizer) {
        feedbackGenerator.selectionChanged()
        UIView.animate(withDuration: 0.3, animations: {
            self.imageView.alpha = 0.0
        }) { _ in
            self.imageView.isHidden = true
        }
        isImageOpen = false
    }
}
//MARK: Actions
extension AuroraViewController {
    // targets
    private func setupTarget() {
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        chevronButton.addTarget(self, action: #selector(chevronButtonTapped), for: .touchUpInside)
        descriptionButton.addTarget(self, action: #selector(descriptionButtonTapped), for: .touchUpInside)
    }
    // refresh button action
    @objc private func refreshButtonTapped() {
        print("refreshAurora")
        feedbackGenerator.selectionChanged()
        fetchDataAndDisplayAuroraImage()
        fetchAuroraNowcastValue()
        animationLabels()
    }
    
    @objc private func chevronButtonTapped() {
        feedbackGenerator.selectionChanged()
        
        if imageView.isHidden {
            imageView.alpha = 0.0
            imageView.isHidden = false
            
            UIView.animate(withDuration: 0.3) {
                self.imageView.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.imageView.alpha = 0.0
            }) { _ in
                self.imageView.isHidden = true
            }
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
}
//MARK: Animations
extension AuroraViewController {
    private func animationLabels() {
        animateAuroraLabelAppearance(withText: "titleAurora_text".localized())
        animateValueLabelAppearance(withText: "GIGAWATTS")
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
