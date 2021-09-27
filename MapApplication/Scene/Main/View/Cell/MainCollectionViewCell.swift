//
//  MainCollectionViewCell.swift
//  MapApplication
//
//  Created by Akbar on 27/09/21.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    weak var name: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    var model: VenueAnnotation? {
        didSet {
            name.text = model?.title ?? ""
        }
    }
    
    private func setupUI() {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.applySketchShadow()
        view.layer.cornerRadius = 10
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let lbl = UILabel()
        contentView.addSubview(lbl)
        lbl.numberOfLines = 3
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        lbl.textAlignment = .center
        lbl.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(16)
        }
        self.name = lbl
        
        let shareBtn = UIButton()
        contentView.addSubview(shareBtn)
        shareBtn.setTitle("Открыть в Яндекс", for: .normal)
        shareBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        shareBtn.setTitleColor(.black, for: .normal)
        shareBtn.backgroundColor = UIColor(red: 255/255.0, green: 254/255.0, blue: 0/255.0, alpha: 1.0)
        shareBtn.layer.masksToBounds = true
        shareBtn.layer.cornerRadius = 25
        shareBtn.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(50)
            make.bottom.equalTo(-10)
        }
        shareBtn.addTarget(self, action: #selector(onShareTap(_:)), for: .touchUpInside)
    }
    
    @objc func onShareTap(_ sender: UIButton) {
        guard let latitude = model?.coordinate.latitude, let longitude = model?.coordinate.longitude else { return }
        let url = URL(string: "yandexnavi://build_route_on_map/?lat_to=\(latitude)&lon_to=\(longitude)")!
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
extension MainCollectionViewCell {
    public func configure(with model: VenueAnnotation?) {
        self.model = model
    }
}
