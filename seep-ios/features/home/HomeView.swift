import UIKit

class HomeView: BaseView {
  
  let titleLabel = UILabel().then {
    $0.font = UIFont(name: "AppleSDGothicNeo-Light", size: 22)
    $0.textColor = .black
    $0.numberOfLines = 0
  }
  
  let emojiView = UIImageView().then {
    $0.image = UIImage(named: "img_home_emoji")
  }
  
  let successCountButton = UIButton().then {
    $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12)
    $0.setTitleColor(.black, for: .normal)
    $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 4, right: 15)
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 12
    $0.layer.shadowColor = UIColor.black.cgColor
    $0.layer.shadowOffset = CGSize(width: 0, height: 1)
    $0.layer.shadowOpacity = 0.05
  }
  
  let categoryStackView = UIStackView().then {
    $0.alignment = .leading
    $0.axis = .horizontal
    $0.distribution = .equalSpacing
    $0.backgroundColor = .clear
  }
  
  let wantToDoButton = UIButton().then {
    $0.setTitle("common_category_want_to_do".localized, for: .normal)
    $0.setTitleColor(UIColor(r: 186, g: 186, b: 186), for: .normal)
    $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
    $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 18, bottom: 4, right: 18)
    $0.setKern(kern: -0.28)
  }
  
  let wantToGetButton = UIButton().then {
    $0.setTitle("common_category_want_to_get".localized, for: .normal)
    $0.setTitleColor(UIColor(r: 186, g: 186, b: 186), for: .normal)
    $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
    $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 18, bottom: 4, right: 18)
    $0.setKern(kern: -0.28)
  }
  
  let wantToGoButton = UIButton().then {
    $0.setTitle("common_category_want_to_go".localized, for: .normal)
    $0.setTitleColor(UIColor(r: 186, g: 186, b: 186), for: .normal)
    $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
    $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 18, bottom: 4, right: 18)
    $0.setKern(kern: -0.28)
  }
  
  let activeButton = UIButton().then {
    $0.backgroundColor = .seepBlue
    $0.layer.cornerRadius = 15
    $0.setTitleColor(.white, for: .normal)
    $0.layer.shadowOpacity = 0.15
    $0.layer.shadowColor = UIColor.black.cgColor
    $0.layer.shadowOffset = CGSize(width: 0, height: 2)
    $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeoEB00", size: 14)
    $0.contentEdgeInsets = UIEdgeInsets(top: 4, left: 18, bottom: 4, right: 18)
    $0.setKern(kern: -0.28)
  }
  
  let viewTypeButton = UIButton().then {
    $0.setImage(UIImage(named: "ic_grid"), for: .normal)
  }
  
  let containerView = UIView().then {
    $0.isUserInteractionEnabled = true
    $0.backgroundColor = .clear
  }
  
  let writeButton = UIButton().then {
    $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    $0.backgroundColor = .tennisGreen
    $0.layer.cornerRadius = 25
    $0.contentEdgeInsets = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
  }
  
  
  override func setup() {
    self.backgroundColor = UIColor(r: 246, g: 246, b: 246)
    self.categoryStackView.addArrangedSubview(wantToDoButton)
    self.categoryStackView.addArrangedSubview(wantToGetButton)
    self.categoryStackView.addArrangedSubview(wantToGoButton)
    self.addSubViews(
      titleLabel, emojiView, successCountButton, categoryStackView,
      viewTypeButton, activeButton, containerView, writeButton
    )
  }
  
  override func bindConstraints() {
    self.titleLabel.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(22)
      make.top.equalTo(safeAreaLayoutGuide).offset(34 * RatioUtils.height)
    }
    
    self.emojiView.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide).offset(30 * RatioUtils.height)
      make.right.equalToSuperview().offset(-20)
    }
    
    self.successCountButton.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(22)
      make.top.equalTo(self.titleLabel.snp.bottom).offset(20 * RatioUtils.height)
    }
    
    self.categoryStackView.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(20)
      make.top.equalTo(self.successCountButton.snp.bottom).offset(50 * RatioUtils.height)
    }
    
    self.viewTypeButton.snp.makeConstraints { make in
      make.right.equalToSuperview().offset(-24)
      make.centerY.equalTo(self.categoryStackView)
    }
    
    self.activeButton.snp.makeConstraints { make in
      make.centerY.equalTo(self.categoryStackView)
      make.height.equalTo(30)
      make.centerX.equalTo(self.categoryStackView.arrangedSubviews[0])
    }
    
    self.containerView.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview()
      make.top.equalTo(self.categoryStackView.snp.bottom).offset(16)
    }
    
    self.writeButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.height.equalTo(50)
      make.bottom.equalTo(safeAreaLayoutGuide).offset(-24)
    }
  }
  
  func showWriteButton() {
    UIView.transition(with: self.writeButton, duration: 0.3, options: .curveEaseInOut) {
      self.writeButton.alpha = 1.0
      self.writeButton.transform = .identity
    }
  }
  
  func hideWriteButton() {
    UIView.transition(with: self.writeButton, duration: 0.3, options: .curveEaseInOut) {
      self.writeButton.alpha = 0.0
      self.writeButton.transform = .init(translationX: 0, y: 100)
    }
  }
  
  func setWishCount(category: Category, count: Int) {
    if count == 0 {
      self.titleLabel.attributedText = self.getEmptyTitle(by: category, count: count)
    } else{
      self.titleLabel.attributedText = self.getCountTitle(by: category, count: count)
    }
  }
  
  func startAnimation() {
    UIView.animate(withDuration: 2, delay: 0, options: [.autoreverse, .repeat]) {
      self.emojiView.transform = self.emojiView.transform.rotated(by: 0.3)
    }
  }
  
  func moveActiveButton(category: Category) {
    let index = category.getIndex()
    
    self.activeButton.snp.remakeConstraints { make in
      make.centerY.equalTo(self.categoryStackView)
      make.height.equalTo(30)
      make.centerX.equalTo(self.categoryStackView.arrangedSubviews[index])
    }
    self.activeButton.setTitle(category.rawValue.localized, for: .normal)
    UIView.animate(withDuration: 0.3, delay: 0, options:.curveEaseOut, animations: {
      self.layoutIfNeeded()
    }, completion: nil)
  }
  
  func setSuccessCount(category: Category, count: Int) {
    let text = count != 0 ? String(format: "home_finish_count_\(category.rawValue)_format".localized, count) : String(format: "home_finish_count_\(category.rawValue)_format_empty".localized, count)
    let attributedString = NSMutableAttributedString(string: text)
    let underlineTextRange = (text as NSString).range(of: category == .wantToGo ? "\(count)곳" : "\(count)개")
    
    attributedString.addAttribute(
      .foregroundColor,
      value: UIColor.seepBlue,
      range: underlineTextRange
    )
    self.successCountButton.setAttributedTitle(attributedString, for: .normal)
  }
  
  func changeViewType(to viewType: ViewType) {
    self.viewTypeButton.setImage(UIImage(named: viewType.toggle().imageName), for: .normal)
  }
  
  private func getEmptyTitle(by category: Category, count: Int) -> NSMutableAttributedString {
    let text = "home_write_\(category.rawValue)_count_empty".localized
    let attributedString = NSMutableAttributedString(string: text)
    let boldTextRange = (text as NSString).range(of: "적어봐요!")
    
    attributedString.addAttribute(
      .font,
      value: UIFont(name: "AppleSDGothicNeo-Bold", size: 22)!,
      range: boldTextRange
    )
    
    return attributedString
  }
  
  private func getCountTitle(by category: Category, count: Int) -> NSMutableAttributedString {
    let text = String(format: "home_write_\(category.rawValue)_count_format".localized, count)
    let attributedString = NSMutableAttributedString(string: text)
    let underlineTextRange = (text as NSString).range(of: String(format: "home_write_\(category.rawValue)_unit".localized, count))
    let boldTextRange = (text as NSString).range(of: "남았어요!")
    
    attributedString.addAttributes([
      .foregroundColor: UIColor.tennisGreen,
      .underlineStyle: NSUnderlineStyle.thick.rawValue,
      .underlineColor: UIColor.tennisGreen,
      .font: UIFont(name: "AppleSDGothicNeo-Bold", size: 22)!
    ], range: underlineTextRange)
    
    attributedString.addAttribute(
      .font,
      value: UIFont(name: "AppleSDGothicNeo-Bold", size: 22)!,
      range: boldTextRange
    )
    
    return attributedString
  }
}
