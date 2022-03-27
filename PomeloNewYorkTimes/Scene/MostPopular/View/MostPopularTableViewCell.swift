//
//  MostPopularTableViewCell.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 25/3/2565 BE.
//

import UIKit
import Kingfisher

final class MostPopularTableViewCell: UITableViewCell {
    
    static let identifier = "MostPopularTableViewCell"
    
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
        
        titleLbl.textColor = .black
        detailLbl.textColor = .darkGray
        dateLbl.textColor = .darkGray
        
        thumbImageView.clipsToBounds = true
        thumbImageView.contentMode = .scaleAspectFill
    }
    
    func configure(item: MostPopularItem) {
        titleLbl.text = item.title
        detailLbl.text = item.abstract
        dateLbl.text = DateHelper.convertDate(source: item.publishedDate, sourceFormat: "yyyy-MM-dd", destinationFormat: "dd MMM yyyy")
        
        guard let media = item.media,
                let mediaItem = media.first,
                let mediaMetaData = mediaItem.mediaMetaData,
                !mediaMetaData.isEmpty else { return }
        let imageUrl = mediaMetaData.last?.url
        
        thumbImageView.kf.setImage(with: imageUrl)
    }
    
}
