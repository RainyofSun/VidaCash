//
//  VCAPPCertificationPopTableView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/8.
//

import UIKit

protocol APPCertificationPopTableProtocol: AnyObject {
    func didSelectedCity(tableView: VCAPPCertificationPopTableView, didSelectRowAt indexPath: IndexPath)
}

class VCAPPCertificationPopTableView: UITableView {
    
    weak open var tableDelegate: APPCertificationPopTableProtocol?
    
    private lazy var _city_model_array: [String] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        
        self.delegate = self
        self.dataSource = self
        self.register(VCAPPCertificationPopTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(VCAPPCertificationPopTableViewCell.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadCitySource(_ source: [String]) {
        self._city_model_array.removeAll()
        self._city_model_array.append(contentsOf: source)
        self.reloadData()
    }
}

extension VCAPPCertificationPopTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._city_model_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(VCAPPCertificationPopTableViewCell.self), for: indexPath) as? VCAPPCertificationPopTableViewCell else {
            return UITableViewCell()
        }
        
        _cell.reloadTitle(self._city_model_array[indexPath.row])
        return _cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _cell = tableView.cellForRow(at: indexPath) as? VCAPPCertificationPopTableViewCell else {
            return
        }
        
        self.tableDelegate?.didSelectedCity(tableView: self, didSelectRowAt: indexPath)
        
        _cell.setSelected(true, animated: false)
    }
}
