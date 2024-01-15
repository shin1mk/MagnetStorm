//
//  AboutViewController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 11.01.2024.
//

import UIKit
import SnapKit
import SafariServices

final class AboutViewController: UIViewController {
    //MARK: Properties
    private let bottomMarginView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.3)
        return view
    }()
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "about_text_label".localized()
        label.font = UIFont.SFUITextRegular(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    private let source1Label: UILabel = {
        let label = UILabel()
        label.text = "source_text1".localized()
        label.font = UIFont.SFUITextRegular(ofSize: 16)
        label.textColor = .white
        return label
    }()
    private let source1Button: UIButton = {
        let button = UIButton()
        button.setTitle("NOAA SWPC Magnet forecast", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.SFUITextRegular(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let source2Button: UIButton = {
        let button = UIButton()
        button.setTitle("NOAA SWPC Aurora forecast", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.SFUITextRegular(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let source3Button: UIButton = {
        let button = UIButton()
        button.setTitle("NOAA SWPC Tides and Currents", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.SFUITextRegular(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let likeLabel: UILabel = {
        let label = UILabel()
        label.text = "like_label".localized()
        label.font = UIFont.SFUITextRegular(ofSize: 16)
        label.textColor = .white
        return label
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("share_button".localized(), for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let rateButton: UIButton = {
        let button = UIButton()
        button.setTitle("rate_button".localized(), for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("support_button".localized(), for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let letterButton: UIButton = {
        let button = UIButton()
        button.setTitle("letter_button".localized(), for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let clearCacheButton: UIButton = {
        let button = UIButton()
        button.setTitle("cache_button".localized(), for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let cacheLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFUITextRegular(ofSize: 12)
        label.textAlignment = .left
        label.text = ""
        label.textColor = .systemGray2
        return label
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .black
        return scrollView
    }()
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        addTarget()
        updateCacheLabel()
    }
    
    private func setupConstraints() {
        view.backgroundColor = .black
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.width.equalTo(scrollView)
            make.height.equalToSuperview().priority(.low)
            make.top.bottom.equalToSuperview()
        }
        
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(0)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.greaterThanOrEqualTo(200)
        }
        
        contentView.addSubview(source1Label)
        source1Label.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(0)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        contentView.addSubview(source1Button)
        source1Button.snp.makeConstraints { make in
            make.top.equalTo(source1Label.snp.bottom).offset(0)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        contentView.addSubview(source2Button)
        source2Button.snp.makeConstraints { make in
            make.top.equalTo(source1Button.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }    
        
        contentView.addSubview(source3Button)
        source3Button.snp.makeConstraints { make in
            make.top.equalTo(source2Button.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        contentView.addSubview(likeLabel)
        likeLabel.snp.makeConstraints { make in
            make.top.equalTo(source3Button.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        contentView.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(likeLabel.snp.bottom).offset(0)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        contentView.addSubview(rateButton)
        rateButton.snp.makeConstraints { make in
            make.top.equalTo(shareButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        contentView.addSubview(buyButton)
        buyButton.snp.makeConstraints { make in
            make.top.equalTo(rateButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        contentView.addSubview(letterButton)
        letterButton.snp.makeConstraints { make in
            make.top.equalTo(buyButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        contentView.addSubview(clearCacheButton)
        clearCacheButton.snp.makeConstraints { make in
            make.top.equalTo(letterButton.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        contentView.addSubview(cacheLabel)
        cacheLabel.snp.makeConstraints { make in
            make.top.equalTo(clearCacheButton.snp.bottom).offset(0)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-10)
        }
        // tab bar background
        contentView.addSubview(bottomMarginView)
        bottomMarginView.layer.zPosition = 999
        bottomMarginView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(0)
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.bottomMargin).offset(-0)
        }
    }
    
    private func addTarget() {
        source1Button.addTarget(self, action: #selector(openNOAA1Link), for: .touchUpInside)
        source2Button.addTarget(self, action: #selector(openNOAA2Link), for: .touchUpInside)
        source3Button.addTarget(self, action: #selector(openNOAA3Link), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        rateButton.addTarget(self, action: #selector(rateButtonTapped), for: .touchUpInside)
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        letterButton.addTarget(self, action: #selector(letterButtonTapped), for: .touchUpInside)
        clearCacheButton.addTarget(self, action: #selector(clearCacheButtonTapped), for: .touchUpInside)
    }
    
    @objc private func openNOAA1Link() {
        if let url = URL(string: "https://www.swpc.noaa.gov/products/3-day-forecast") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func openNOAA2Link() {
        if let url = URL(string: "https://www.swpc.noaa.gov/communities/aurora-dashboard-experimental") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func openNOAA3Link() {
        if let url = URL(string: " https://tidesandcurrents.noaa.gov/map/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    // share
    @objc private func shareButtonTapped() {
        // Создайте экземпляр UIActivityViewController
        let appURL = URL(string: "https://apps.apple.com/us/app/magnetstorm/id6468251721")!
        let shareText = "MagnetStorm\n\(appURL)"
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        // Предотвратите показывание контроллера на iPad в поповере
        activityViewController.popoverPresentationController?.sourceView = view
        // Покажите UIActivityViewController
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func rateButtonTapped() {
        if let url = URL(string: "https://apps.apple.com/us/app/magnetstorm/id6468251721") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    @objc private func buyButtonTapped() {
        if let url = URL(string: "https://www.buymeacoffee.com/shininswift") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func letterButtonTapped() {
        let recipient = "shininswift@gmail.com"
        let subject = "MagnetStorm"
        
        let urlString = "mailto:\(recipient)?subject=\(subject)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let url = URL(string: urlString ?? "") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    // чистим кеш функция
    @objc func clearCacheButtonTapped() {
        // Get the caches directory URL
        if let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            do {
                let cacheFiles = try FileManager.default.contentsOfDirectory(atPath: cachesURL.path)
                
                for file in cacheFiles {
                    try FileManager.default.removeItem(at: cachesURL.appendingPathComponent(file))
                }
                print("Кеш очищен.")
                
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    DispatchQueue.main.async {
                        self.updateCacheLabel()
                    }
                }
            } catch {
                print("Не удалось очистить кеш: \(error.localizedDescription)")
            }
        }
    }
    // обновляем лейбл кеша
    func updateCacheLabel() {
        if let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            do {
                // Get the size of the caches directory
                let cacheSize = try FileManager.default.sizeOfDirectory(at: cachesURL)
                
                let formattedSize = ByteCountFormatter.string(fromByteCount: Int64(cacheSize), countStyle: .file)
                
                cacheLabel.text = cacheSize > 0 ? "Cache size: \(formattedSize)" : "Cache size: 0 Mb"
            } catch {
                cacheLabel.text = "Не удалось получить размер кеша"
            }
        }
    }
} // end
//MARK: Clear Cache
extension FileManager {
    func sizeOfDirectory(at url: URL) throws -> UInt64 {
        let resourceKeys: [URLResourceKey] = [.isRegularFileKey, .fileSizeKey]

        let enumerator = self.enumerator(at: url, includingPropertiesForKeys: resourceKeys, options: [], errorHandler: nil)

        var totalSize: UInt64 = 0

        for case let fileURL as URL in enumerator! {
            let resourceValues = try fileURL.resourceValues(forKeys: Set(resourceKeys))
            if resourceValues.isRegularFile ?? false {
                totalSize += UInt64(resourceValues.fileSize ?? 0)
            }
        }

        return totalSize
    }
}

