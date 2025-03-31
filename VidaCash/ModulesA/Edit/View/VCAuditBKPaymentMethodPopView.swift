//
//  VCAuditBKPaymentMethodPopView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/21.
//

import UIKit

class VCAuditBKPaymentMethodCell: UITableViewCell {
    
    private lazy var bgImgView: UIImageView = UIImageView(image: UIImage(named: "bk_pop_select_bg"))
    private lazy var titleLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.systemFont(ofSize: 14), labelColor: BLACK_COLOR_333333)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        self.bgImgView.isHidden = true
        
        self.contentView.addSubview(self.bgImgView)
        self.contentView.addSubview(self.titleLab)
        
        self.bgImgView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 3.5)
            make.verticalEdges.equalToSuperview()
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.bgImgView.isHidden = !selected
        self.titleLab.textColor = selected ? .white : BLACK_COLOR_333333
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadText(_ text: String) {
        self.titleLab.text = text
    }
}

class VCAuditBKPaymentMethodPopView: VCAuditBKBasePopView {

    open var selected_method: String?
    
    private lazy var methodTableView: UITableView = {
        let view = UITableView(frame: CGRectZero, style: UITableView.Style.plain)
        view.separatorStyle = .none
        return view
    }()
    
    private var method_array: [String] = []
    
    override func buildBKPopViews() {
        super.buildBKPopViews()
        
        self.imgContentView.image = UIImage(named: "bk_pop_bg1")
        self.methodTableView.corner(16)
        
        self.methodTableView.delegate = self
        self.methodTableView.dataSource = self
        self.methodTableView.register(VCAuditBKPaymentMethodCell.self, forCellReuseIdentifier: VCAuditBKPaymentMethodCell.className())
        
        self.imgContentView.addSubview(self.methodTableView)
    }

    override func layoutBKPopViews() {
        super.layoutBKPopViews()
        
        self.imgContentView.snp.remakeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(ScreenWidth * 1.11)
        }
        
        self.methodTableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.top.equalTo(self.titleLab.snp.bottom).offset(PADDING_UNIT * 3.5)
            make.bottom.equalTo(self.confirmBtn.snp.top).offset(-PADDING_UNIT * 3)
        }
    }
    
    public func reloadMethodsSource(_ source: [String]) {
        self.method_array.removeAll()
        self.method_array.append(contentsOf: source)
        self.methodTableView.reloadData()
    }
}

extension VCAuditBKPaymentMethodPopView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.method_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _cell = tableView.dequeueReusableCell(withIdentifier: VCAuditBKPaymentMethodCell.className(), for: indexPath) as? VCAuditBKPaymentMethodCell else {
            return UITableViewCell()
        }
        
        _cell.reloadText(self.method_array[indexPath.row])
        
        return _cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _cell = tableView.cellForRow(at: indexPath) as? VCAuditBKPaymentMethodCell else {
            return
        }
        
        self.selected_method = self.method_array[indexPath.row]
        
        _cell.setSelected(true, animated: true)
    }
}
