//
//  DetailViewController.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 25/3/2565 BE.
//

import UIKit
import WebKit

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    
    private var viewModel: DetailViewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    func configure(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
    
    func setupWebView() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(URLRequest(url: viewModel.getUrl()))
    }
}

extension DetailViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.indicator.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.indicator.isHidden = true
    }
}
