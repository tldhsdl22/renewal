//
//  File.swift
//  GGBB_re
//
//  Created by 송시온 on 14/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

class StoreInfoPageViewController: UIViewController
{
    
    @IBOutlet var labelStoreName: UILabel!
    @IBOutlet var labelViewCnt: UILabel!
    @IBOutlet var labelReviewCnt: UILabel!
    @IBOutlet var labelLikeCnt: UILabel!
    
    @IBOutlet var labelAddress: UILabel!
    @IBOutlet var labelOpenTime: UILabel!
    @IBOutlet var labelHoliday: UILabel!
    @IBOutlet var labelParking: UILabel!
    
    @IBOutlet var labelCoupon: UILabel!
    @IBOutlet var labelEditorReview: UILabel!
    @IBOutlet var editorImage: UIView!
    
    @IBOutlet var imgCollectionView: UICollectionView!
    @IBOutlet var couponLayout: UIView!
    @IBOutlet var mapArea: UIView!
    @IBOutlet var callArea: UIView!
    @IBOutlet var recommendArea: UIView!
    
    // 버튼 메뉴
    @IBOutlet var mapBtnView: UIView!
    @IBOutlet var callBtnView: UIView!
    @IBOutlet var recommendBtnView: UIView!

    @IBOutlet var recommendBtnImage: UIImageView!
    @IBOutlet var recommendBtnLabel: UILabel!
    
    // 리뷰
    @IBOutlet var review1: UIView!
    @IBOutlet var review2: UIView!
    @IBOutlet var review3: UIView!
    @IBOutlet var reviewImage1: UIImageView!
    @IBOutlet var reviewImage2: UIImageView!
    @IBOutlet var reviewImage3: UIImageView!
    @IBOutlet var reviewNickname1: UILabel!
    @IBOutlet var reviewNickname2: UILabel!
    @IBOutlet var reviewNickname3: UILabel!
    @IBOutlet var reviewContents1: UILabel!
    @IBOutlet var reviewContents2: UILabel!
    @IBOutlet var reviewContents3: UILabel!
    @IBOutlet var reviewDate1: UILabel!
    @IBOutlet var reviewDate2: UILabel!
    @IBOutlet var reviewDate3: UILabel!
    
    // 댓글 달기
    @IBOutlet var myThumbImg: UIImageView!
    @IBOutlet var reviewField: UITextField!
    @IBOutlet var sendBtn: UIButton!
    
    
    // 하단 버튼
    @IBOutlet var bottomScrapBtnView: UIView!
    @IBOutlet var bottomShareBtnView: UIView!
    @IBOutlet var bottomMapBtnView: UIView!
    @IBOutlet var bottomCallBtnView: UIView!
    @IBOutlet var bottomLikeBtnView: UIView!
    @IBOutlet var bottomScrapImg: UIImageView!
    @IBOutlet var bottomLikeImg: UIImageView!
    @IBOutlet var bottomScrapLabel: UILabel!
    @IBOutlet var bottomLikeLabel: UILabel!
    
    @IBOutlet var editorReviewArea: UIView!
    
    @IBOutlet var myScrollView: UIScrollView!
    
    
    public var itemInfo = IndicatorInfo(title: "")
    //public var storeInfo:StoreThumb? = nil
    
    public var storeNum:String?
    public var storeType:String?
    
    public var storeInfoDetail:StoreInfoDetail? = nil
    {
        didSet(oldVal)
        {
            imgCollectionView.reloadData()
            if( storeInfoDetail?.reviewList != nil)
            {
                var reviewList = [ReviewInfo]()
                if(storeInfoDetail?.reviewList != nil)
                {
                    for review in storeInfoDetail!.reviewList!
                    {
                        print(review.blind)
                        if review.blind == "0"
                        {
                            reviewList.append(review)
                        }
                        
                        if reviewList.count >= 3 {
                            break
                        }
                    }
                }
                
                if (reviewList.count == 1)
                {
                    review1.isHidden = false
                }
                else if ( reviewList.count == 2 )
                {
                    review1.isHidden = false
                    review2.isHidden = false
                }
                else if ( reviewList.count >= 3 )
                {
                    review1.isHidden = false
                    review2.isHidden = false
                    review3.isHidden = false
                }
                else { // 0
                    
                }
                
                if review1.isHidden == false
                {
                    reviewImage1.cacheImage(urlString: reviewList[0].url ?? "")
                    reviewImage1.layer.cornerRadius = reviewImage1.frame.width / 2
                    reviewNickname1.text = reviewList[0].nickName
                    reviewDate1.text = reviewList[0].date
                    reviewContents1.text = reviewList[0].review
                }
                
                if review2.isHidden == false
                {
                    reviewImage2.cacheImage(urlString: reviewList[1].url ?? "")
                    reviewImage2.layer.cornerRadius = reviewImage1.frame.width / 2
                    reviewNickname2.text = reviewList[1].nickName
                    reviewDate2.text = reviewList[1].date
                    reviewContents2.text = reviewList[1].review
                }
                
                if review3.isHidden == false
                {
                    reviewImage3.cacheImage(urlString: reviewList[2].url ?? "")
                    reviewImage3.layer.cornerRadius = reviewImage1.frame.width / 2
                    reviewNickname3.text = reviewList[2].nickName
                    reviewDate3.text = reviewList[2].date
                    reviewContents3.text = reviewList[2].review
                }
            }
            
            // 나머지
            labelStoreName.text = storeInfoDetail?.name
            labelViewCnt.text = storeInfoDetail?.view
            labelReviewCnt.text = storeInfoDetail?.review
            labelLikeCnt.text = storeInfoDetail?.recommend
            labelEditorReview.text = storeInfoDetail?.editor
            labelCoupon.text = storeInfoDetail?.coupon
            
            // 좋아요 버튼
            print("storeInfoDetail " + (storeInfoDetail?.isRec ?? ""))
            if storeInfoDetail?.isRec == "0"
            {
                recommendBtnImage.image = UIImage(named: "detail_good")
                bottomLikeImg.image = UIImage(named: "bottom_good")
                bottomLikeLabel.textColor = .lightGray
                recommendBtnLabel.textColor = .lightGray
                bottomLikeLabel.text = "추천하기"

                recommendBtnLabel.text = "추천하기"
            }
            else
            {
                recommendBtnImage.image = UIImage(named: "detail_good_on")
                bottomLikeImg.image = UIImage(named: "bottom_good_on")
                bottomLikeLabel.textColor = Util.AppColor
                recommendBtnLabel.textColor = Util.AppColor

                bottomLikeLabel.text = "추천취소"
                recommendBtnLabel.text = "추천취소"
            }
            
            
            // 스크랩 버튼
            print("storeInfoDetail " + (storeInfoDetail?.isScrap ?? ""))
            if storeInfoDetail?.isScrap == "0"
            {
                bottomScrapImg.image = UIImage(named: "bottom_scrap")
                bottomScrapLabel.textColor = .lightGray
            }
            else
            {
                bottomScrapImg.image = UIImage(named: "bottom_scrap_on")
                bottomScrapLabel.textColor = Util.AppColor
            }
            
            loadViewIfNeeded()
        }
    }
    
    var orgHeight:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDetailData(num:self.storeNum ?? "", type:self.storeType ?? "")
        
        review1.isHidden = true
        review2.isHidden = true
        review3.isHidden = true
        
        editorReviewArea.layer.cornerRadius = 10
        
        initImageViews()
        attachClickEvent()
    
        
        
        // touchEvnet
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        myScrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc func endEditing()
    {
        self.view.endEditing(true)
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    
    var isNextPaging = false
    override func viewDidDisappear(_ animated: Bool) {
        isNextPaging = true
        print("viewDidDisappear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewDidAppear")
        if (isNextPaging == true)
        {
            getDetailData(num: self.storeNum ?? "", type:self.storeType ?? "")
            isNextPaging = false
        }
    }
    
    private func initImageViews()
    {
        myThumbImg.layer.cornerRadius = myThumbImg.frame.width / 2
        myThumbImg.cacheImage(urlString: UserInfo.getUserThumb() ?? "")
        editorImage.layer.cornerRadius = editorImage.frame.width / 2
        
        couponLayout.layer.borderColor = UIColor.lightGray.cgColor
        couponLayout.layer.borderWidth = 0.7
        couponLayout.layer.cornerRadius = 5
        
        mapArea.layer.cornerRadius = mapArea.frame.width / 2
        callArea.layer.cornerRadius = callArea.frame.width / 2
        recommendArea.layer.cornerRadius = recommendArea.frame.width / 2
    }
    
    private func getDetailData(num:String, type:String)
    {
        let kakaoId = UserInfo.getUserId() ?? ""
        let param = ["num":num, "type":type, "kakaoID":kakaoId] as [String : Any]
         Alamofire.request("http://iloveggbb.com/app/main/store.php", method: .post, parameters: param)
            .responseJSON {(response) in
                switch response.result
                {
                case .success(let obj):
                    //print("succss1")
                    //print(obj)
                    if obj is NSDictionary
                    {
                        do
                        {
                            let jsonObj = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                            let data = try JSONDecoder().decode(StoreInfoDetail.self, from: jsonObj)
                            self.storeInfoDetail = data
                        }
                        catch
                        {
                            print("fail")
                            print(error.localizedDescription)
                        }
                    }
                    break
                case .failure(let error):
                    print("fail")
                    print(error.localizedDescription)
                    break
                }
                self.isWait = false
                //print(response)
        }
    }
    
    private func attachClickEvent()
    {
        // 전화하기 이벤트
        let call_gesture1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(callPhone))
        call_gesture1.numberOfTapsRequired = 1
        callBtnView?.isUserInteractionEnabled = true
        callBtnView?.addGestureRecognizer(call_gesture1)
        
        let call_gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(callPhone))
        call_gesture.numberOfTapsRequired = 1

        
        // 추천하기 이벤트
        let recommend_gesture1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(recommend))
        recommend_gesture1.numberOfTapsRequired = 1
        recommendBtnView?.isUserInteractionEnabled = true
        recommendBtnView?.addGestureRecognizer(recommend_gesture1)
        
        let recommend_gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(recommend))
        recommend_gesture.numberOfTapsRequired = 1

        
        
        // 지도보기 이벤트
        let map_gesture1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        map_gesture1.numberOfTapsRequired = 1
        mapBtnView?.isUserInteractionEnabled = true
        mapBtnView?.addGestureRecognizer(map_gesture1)

        let map_gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        map_gesture.numberOfTapsRequired = 1
        
        
        // 스크랩 이벤트
        let scrap_gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrap))
        scrap_gesture.numberOfTapsRequired = 1
        
        // 공유하기 이벤트
        let share_gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(share))
        share_gesture.numberOfTapsRequired = 1
        
        
        // 하단바
        bottomScrapBtnView?.isUserInteractionEnabled = true
        bottomScrapBtnView?.addGestureRecognizer(scrap_gesture)
        
        bottomShareBtnView?.isUserInteractionEnabled = true
        bottomShareBtnView?.addGestureRecognizer(share_gesture)
        
        bottomMapBtnView?.isUserInteractionEnabled = true
        bottomMapBtnView?.addGestureRecognizer(map_gesture)
        
        bottomCallBtnView?.isUserInteractionEnabled = true
        bottomCallBtnView?.addGestureRecognizer(call_gesture)
        
        bottomLikeBtnView?.isUserInteractionEnabled = true
        bottomLikeBtnView?.addGestureRecognizer(recommend_gesture)
    }
    
    var isWaitScrap = false
    @objc private func scrap()
    {
        print("scrap")
        if(isWaitScrap == true)
        {
            return
        }
        isWaitScrap = true
        
        let kakaoId = UserInfo.getUserId() ?? ""
        if kakaoId == ""
        {
            let alert = UIAlertController(title: "사용 불가", message: "로그인 후 사용할 수 있는 기능입니다.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            isWaitScrap = false
            return
        }
        
        var type = "" // or unlike
        if(self.storeInfoDetail?.isScrap == "0")
        {
            type = "post.php"
        }
        else
        {
            type = "delete.php"
        }
        let param = ["kakaoID":kakaoId, "storeNum":self.storeInfoDetail?.num ?? "", "storeType":self.storeInfoDetail?.type ?? ""] as [String:Any]
        print(type)

        Alamofire.request("http://iloveggbb.com/app/scrap/"+type, method: .post, parameters: param)
            .responseJSON {(response) in
                print("response")
                print(response)
                
                switch response.result
                {
                case .success(let obj):
                    print("succss1")
                    if obj is NSDictionary
                    {
                        do
                        {
                            let jsonObj = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                            let data = try JSONDecoder().decode(RecommendResult.self, from: jsonObj)
                            if data.result == "success"
                            {
                                self.getDetailData(num: self.storeNum ?? "", type: self.storeType ?? "")
                                self.isWaitScrap = false
                            }
                            else
                            {
                                let alert = UIAlertController(title: "실패", message: data.message, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                self.isWaitScrap = false
                            }
                        }
                        catch
                        {
                            print("fail")
                            print(error.localizedDescription)
                            
                            let alert = UIAlertController(title: "실패", message: "서버 연결상태가 좋지 않습니다.", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            self.isWaitScrap = false
                        }
                    }
                    break
                case .failure(let error):
                    print("fail")
                    print(error.localizedDescription)
                    break
                }
        }

    }
    
    
    @objc private func showMap()
    {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoreInfoGmapViewController") as? StoreInfoGmapViewController
        {
            vc.storeNum = self.storeNum ?? ""
            vc.storeType = self.storeType ?? ""
            self.show(vc, sender: self)
        }
    }
    
    @objc private func share()
    {
        let header =  "응답하라 경기북부 혜택 매장 \n\n"
        let name = storeInfoDetail?.name ?? ""
        let couponBonus = "쿠폰혜택 : " + (storeInfoDetail?.coupon ?? "") + "\n"
        let url = URL(string: "http://www.iloveggbb.com/share/store?content="+(storeInfoDetail?.num ?? "")+"&type=" + (storeInfoDetail?.type ?? "" ))
        let end = "\n응답하라 경기북부 앱에서 확인해보세요!"
        
        let dataToShare = [header, name, couponBonus, url, end] as [Any]
        
        
        //let activityVC = UIActivityViewController(activityItems: dataToShare, applicationActivities: nil)
        //activityVC.excludedActivityTypes = [UIActivityType.message]]
        //sender.present(activityVC, animated: true, completion: nil)

        //Util.getInstance().showShared(sender: self, data: dataToShare) // 공유창 띄우기
        let activityViewController = UIActivityViewController(activityItems: dataToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.message]
        // exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)



    }
    
    
    @objc private func callPhone()
    {
        let tel = (storeInfoDetail?.tel) ?? ""
        guard let number = URL(string: "tel://" + tel) else { return }
        
        UIApplication.shared.open(number)
    }
    
    var isWait = false
    @objc private func recommend()
    {
        if(isWait == true)
        {
            return
        }
        isWait = true
        
        let kakaoId = UserInfo.getUserId() ?? ""
        if kakaoId == ""
        {
            let alert = UIAlertController(title: "사용 불가", message: "로그인 후 사용할 수 있는 기능입니다.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            isWait = false
            return
        }
        
        var type = "" // or unlike
        if(self.storeInfoDetail?.isRec == "0")
        {
            type = "like"
        }
        else
        {
            type = "unlike"
        }
        let param = ["kakaoID":kakaoId, "storeNum":self.storeInfoDetail?.num ?? "", "storeType":self.storeInfoDetail?.type ?? "", "type":type] as [String:Any]
        
        Alamofire.request("http://www.iloveggbb.com/app/main/recommend.php", method: .post, parameters: param)
            .responseJSON {(response) in
                print("response")
                print(response)
                
                switch response.result
                {
                case .success(let obj):
                    print("succss1")
                    if obj is NSDictionary
                    {
                        do
                        {
                            let jsonObj = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                            let data = try JSONDecoder().decode(RecommendResult.self, from: jsonObj)
                            if data.result == "success"
                            {
                                self.getDetailData(num: self.storeNum ?? "", type: self.storeType ?? "")
                                
                                /*
                                let alert = UIAlertController(title: "추천하기 성공", message: data.message, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                */
                            }
                            else
                            {
                                let alert = UIAlertController(title: "실패", message: data.message, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                self.isWait = false
                            }
                        }
                        catch
                        {
                            print("fail")
                            print(error.localizedDescription)
                            
                            let alert = UIAlertController(title: "실패", message: "서버 연결상태가 좋지 않습니다.", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            self.isWait = false
                        }
                    }
                    break
                case .failure(let error):
                    print("fail")
                    print(error.localizedDescription)
                    break
                }
        }
    }
    
    @IBAction func showReview(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoreReviewViewController") as? StoreReviewViewController
        {
            vc.num = self.storeNum
            vc.type = self.storeType
            
            self.show(vc, sender: self.parent)
        }
    }
    
    @IBAction func sendReview(_ sender: Any) {
        self.sendBtn.isEnabled = false
        
        let kakaoId = UserInfo.getUserId() ?? ""
        let serviceType = "10" // 댓글 서비스는 10번
        let review = self.reviewField.text
        let param = ["kakaoID":kakaoId , "serviceType":serviceType , "storeNum":self.storeNum  ?? "", "type":self.storeType  ?? "", "review":review ?? ""] as [String:Any]
        print(param)
        
        if( review == "" )
        {
            self.sendBtn.isEnabled = true
            return
        }
        
        Alamofire.request("http://www.iloveggbb.com/index2.php", method: .post, parameters: param)
            .responseJSON {(response) in
                print(response)
                switch response.result
                {
                case .success(let obj):
                    print("succss1")
                    if obj is NSDictionary
                    {
                        do
                        {
                            let jsonObj = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                            let data = try JSONDecoder().decode(ReviewResult.self, from: jsonObj)
                            if data.result == "success"
                            {
                                self.getDetailData(num: self.storeNum ?? "", type: self.storeType ?? "")
                                self.reviewField?.text = ""

                            }
                            else
                            {
                                let alert = UIAlertController(title: "댓글달기 실패", message: "서버 연결상태가 좋지 않습니다.", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        catch
                        {
                            print("fail")
                            print(error.localizedDescription)
                            
                            let alert = UIAlertController(title: "댓글달기 실패", message: "서버 연결상태가 좋지 않습니다.", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    break
                case .failure(let error):
                    print("fail")
                    print(error.localizedDescription)
                    break
                }
                //print(response)
                
                self.sendBtn.isEnabled = true
        }
    }
}

extension StoreInfoPageViewController: IndicatorInfoProvider  {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

extension StoreInfoPageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeInfoDetail?.img?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreInfoPageCollectionImageCell", for: indexPath) as? StoreInfoPageCollectionImageCell
        {
            cell.imageView.cacheImage(urlString: storeInfoDetail?.img?[indexPath.row ?? 0] ?? "")

            cell.imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]

            cell.imageView.contentMode = .scaleAspectFill
            //cell.imageView.contentMode = .scaleAspectFit
            //cell.imageView.image = UIImage(named: "06_timer_1x")
            
            return cell
        }
        else
        {
            return UICollectionViewCell()
        }
    }
}


extension StoreInfoPageViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        sendReview(self)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing")
        return true
    }
}



class StoreInfoPageCollectionImageCell: UICollectionViewCell
{
    @IBOutlet var imageView: UIImageView!
}
