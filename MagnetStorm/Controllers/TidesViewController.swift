//
//  TidesViewController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 15.01.2024.
//

import UIKit
import WebKit
import SafariServices
import CoreLocation

final class TidesViewController: UIViewController, WKNavigationDelegate {
    //MARK: - Properties
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.navigationDelegate = self
        webView.backgroundColor = .black
        webView.scrollView.isScrollEnabled = false
        return webView
    }()
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .systemGray2
        indicator.hidesWhenStopped = true
        return indicator
    }()
    private let refreshButton: UIButton = {
        let button = UIButton()
        let refreshIcon = UIImage(systemName: "arrow.clockwise")
        button.setImage(refreshIcon, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()
    private let bottomMarginView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.9)
        return view
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        loadTidesPage()
        addTarget()
    }
    
    private func setupConstraints() {
        view.backgroundColor = .clear
        // страница
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        // обновить
        view.addSubview(refreshButton)
        refreshButton.layer.zPosition = 999
        refreshButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-25) // Изменено
            make.width.height.equalTo(30)
        }
        // индикатор загрузки
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        // tab bar background
        view.addSubview(bottomMarginView)
        bottomMarginView.layer.zPosition = 999
        bottomMarginView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-0)
        }
    }
    // load web page
    public func loadTidesPage() {
        guard let url = URL(string: "https://tidesandcurrents.noaa.gov/map/") else {
            return
        }
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    // настройки страницы
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Показ черного фона при начале загрузки страницы
        view.backgroundColor = .black
        // Запуск анимации индикатора загрузки
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Скрытие черного фона и остановка анимации индикатора после завершения загрузки страницы
        view.backgroundColor = .black
        activityIndicator.stopAnimating()
    }
    
    private func addTarget() {
        refreshButton.addTarget(self, action: #selector(refreshButtonAction), for: .touchUpInside)
    }
    
    @objc private func refreshButtonAction() {
        loadTidesPage()
    }
}
