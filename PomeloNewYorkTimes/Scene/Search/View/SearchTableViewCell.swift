//
//  SearchTableViewCell.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 26/3/2565 BE.
//

import UIKit
import Kingfisher

final class SearchTableViewCell: UITableViewCell {
    
    static let identifier = "SearchTableViewCell"
    
    @IBOutlet private weak var sourceLbl: UILabel!
    @IBOutlet private weak var titleLbl: UILabel!
    @IBOutlet private weak var detailLbl: UILabel!
    @IBOutlet private weak var thumbImageView: UIImageView!
    @IBOutlet private weak var dateLbl: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    private func setupUI() {
        titleLbl.font = .systemFont(ofSize: 28, weight: .bold)
        detailLbl.font = .systemFont(ofSize: 20, weight: .regular)
        dateLbl.font = .systemFont(ofSize: 14, weight: .regular)
        sourceLbl.font = .systemFont(ofSize: 14, weight: .regular)
        
        titleLbl.textColor = .black
        detailLbl.textColor = .darkGray
        dateLbl.textColor = .darkGray
        sourceLbl.textColor = .darkGray
        
        thumbImageView.clipsToBounds = true
        thumbImageView.contentMode = .scaleAspectFit
    }
    
    func configure(item: ArticleSearchItem) {
        titleLbl.text = item.leadParagraph
        detailLbl.text = item.abstract
        dateLbl.text = DateHelper.convertDate(source: item.publishedDate, sourceFormat: "yyyy-MM-dd'T'HH:mm:ssZ", destinationFormat: "dd MMM yyyy")
        sourceLbl.text = item.source?.uppercased()
        
        guard let multimedias = item.multimedia,
                let multimediaItem = multimedias.first,
                let imageUrl = URL(string: "https://static01.nyt.com/\(multimediaItem.url)")
        else { return }
        thumbImageView.kf.setImage(with: imageUrl)
    }
    
}
