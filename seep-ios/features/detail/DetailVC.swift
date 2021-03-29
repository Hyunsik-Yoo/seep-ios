import UIKit
import RxSwift
import ReactorKit

protocol DetailDelegate: class {
  
  func onDismiss()
}

class DetailVC: BaseVC, View {
  
  weak var delegate: DetailDelegate?
  private lazy var detailView = DetailView(frame: self.view.frame)
  private let detailReactor: DetailReactor
  private let wish: Wish
  private let datePicker = UIDatePicker().then {
    $0.datePickerMode = .date
    $0.preferredDatePickerStyle = .wheels
    $0.locale = .init(identifier: "ko_KO")
  }
  
  
  init(wish: Wish) {
    self.detailReactor = DetailReactor(
      wish: wish,
      wishService: WishService()
    )
    self.wish = wish
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  static func instance(wish: Wish) -> DetailVC {
    return DetailVC(wish: wish)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view = self.detailView
    self.reactor = self.detailReactor
    self.setupKeyboardNotification()
    self.detailView.titleField.textField.delegate = self
    self.detailView.dateField.textField.inputView = datePicker
    self.detailView.bind(wish: wish)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    self.delegate?.onDismiss()
  }
  
  override func bindEvent() {
    self.detailView.tapBackground.rx.event
      .observeOn(MainScheduler.instance)
      .bind { [weak self] _ in
        guard let self = self else { return }
        self.detailView.endEditing(true)
      }
      .disposed(by: self.eventDisposeBag)
    
    self.detailView.moreButton.rx.tap
      .observeOn(MainScheduler.instance)
      .bind(onNext: self.showActionSheet)
      .disposed(by: self.eventDisposeBag)
  }
  
  func bind(reactor: DetailReactor) {
    // MARK: Action
    self.detailView.emojiField.rx.text.orEmpty
      .skip(1)
      .map { Reactor.Action.inputEmoji($0) }
      .bind(to: self.detailReactor.action)
      .disposed(by: self.disposeBag)
    
    self.detailView.randomButton.rx.tap
      .map { Reactor.Action.tapRandomEmoji(())}
      .bind(to: self.detailReactor.action)
      .disposed(by: self.disposeBag)
    
    self.detailView.wantToDoButton.rx.tap
      .map { Reactor.Action.tapCategory(.wantToDo) }
      .bind(to: self.detailReactor.action)
      .disposed(by: self.disposeBag)
    
    self.detailView.wantToGetButton.rx.tap
      .map { Reactor.Action.tapCategory(.wantToGet) }
      .bind(to: self.detailReactor.action)
      .disposed(by: self.disposeBag)
    
    self.detailView.wantToGoButton.rx.tap
      .map { Reactor.Action.tapCategory(.wantToGo) }
      .bind(to: self.detailReactor.action)
      .disposed(by: self.disposeBag)
    
    self.detailView.titleField.rx.text.orEmpty
      .skip(1)
      .map { Reactor.Action.inputTitle($0) }
      .bind(to: self.detailReactor.action)
      .disposed(by: self.disposeBag)
    
    self.datePicker.rx.date
      .skip(1)
      .map { Reactor.Action.inputDate($0) }
      .bind(to: self.detailReactor.action)
      .disposed(by: self.disposeBag)
    
    self.detailView.notificationButton.rx.tap
      .map { Reactor.Action.tapPushButton(()) }
      .bind(to: self.detailReactor.action)
      .disposed(by: disposeBag)
    
    self.detailView.memoField.rx.text.orEmpty
      .filter { $0 != "wrtie_placeholder_memo".localized }
      .map { Reactor.Action.inputMemo($0) }
      .bind(to: self.detailReactor.action)
      .disposed(by: self.disposeBag)
    
    self.detailView.hashtagField.rx.text.orEmpty
      .map { Reactor.Action.inputHashtag($0) }
      .bind(to: self.detailReactor.action)
      .disposed(by: self.disposeBag)
    
    self.detailView.editButton.rx.tap
      .map { Reactor.Action.tapSaveButton(()) }
      .bind(to: self.detailReactor.action)
      .disposed(by: self.disposeBag)
        
    // MARK: State
    self.detailReactor.state
      .map { $0.isEditable }
      .distinctUntilChanged()
      .bind(onNext: self.detailView.setEditable(isEditable:))
      .disposed(by: self.disposeBag)
    
    self.detailReactor.state
      .map { $0.emoji }
      .observeOn(MainScheduler.instance)
      .bind(to: self.detailView.emojiField.rx.text)
      .disposed(by: self.disposeBag)

    self.detailReactor.state
      .map { $0.category }
      .distinctUntilChanged()
      .observeOn(MainScheduler.instance)
      .bind(onNext: self.detailView.moveActiveButton(category:))
      .disposed(by: self.disposeBag)

    self.detailReactor.state
      .map { $0.titleError }
      .bind(to: self.detailView.titleField.rx.errorMessage)
      .disposed(by: self.disposeBag)

    self.detailReactor.state
      .map { DateUtils.toString(format: "yyyy년 MM월 dd일 eeee", date: $0.date)}
      .observeOn(MainScheduler.instance)
      .bind(to: self.detailView.dateField.rx.text)
      .disposed(by: self.disposeBag)

    self.detailReactor.state
      .map { $0.dateError }
      .bind(to: self.detailView.dateField.rx.errorMessage)
      .disposed(by: self.disposeBag)
    
    self.detailReactor.state
      .map { $0.editButtonState }
      .observeOn(MainScheduler.instance)
      .bind(to: self.detailView.editButton.rx.state)
      .disposed(by: self.disposeBag)
    
    self.detailReactor.state
      .map { $0.isPushEnable }
      .observeOn(MainScheduler.instance)
      .bind(to: self.detailView.notificationButton.rx.isSelected)
      .disposed(by: self.disposeBag)
    
    self.detailReactor.state
      .map { $0.shouldDismiss }
      .distinctUntilChanged()
      .observeOn(MainScheduler.instance)
      .bind(onNext: { [weak self] shouldDismiss in
        guard let self = self else { return }
        if shouldDismiss {
          self.dismiss()
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func showActionSheet() {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let deleteAction = UIAlertAction(
      title: "detail_action_sheet_delete".localized,
      style: .destructive
    ) { [weak self] action in
      guard let self = self else { return }
      AlertUtils.showWithCancel(
        viewController: self,
        title: nil,
        message: "삭제하면 복원이 안되요😭\n지워도 될까요?") {
        Observable.just(Reactor.Action.tapDeleteButton(()))
          .bind(to: self.detailReactor.action)
          .disposed(by: self.disposeBag)
      }
    }
    let cancelAction = UIAlertAction(
      title: "detail_action_sheet_cancel".localized,
      style: .cancel,
      handler: nil
    )
    let shereAction = UIAlertAction(
      title: "detail_action_sheet_share".localized,
      style: .default
    ) { action in
      
    }
    let editAction = UIAlertAction(
      title: "detail_action_sheet_edit".localized,
      style: .default
    ) { action in
      Observable.just(Reactor.Action.tapEditButton(()))
        .bind(to: self.detailReactor.action)
        .disposed(by: self.disposeBag)
    }
    
    alertController.addAction(shereAction)
    alertController.addAction(editAction)
    alertController.addAction(deleteAction)
    alertController.addAction(cancelAction)
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  private func setupKeyboardNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(_:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(_:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  
  private func dismiss() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc private func keyboardWillShow(_ notification: Notification) {
    guard let userInfo = notification.userInfo as? [String: Any] else { return }
    guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    let keyboardScreenEndFrame = keyboardFrame.cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
    
    self.detailView.scrollView.contentInset.bottom = keyboardViewEndFrame.height
    self.detailView.scrollView.scrollIndicatorInsets = self.detailView.scrollView.contentInset
  }
  
  @objc private func keyboardWillHide(_ notification: Notification) {
    self.detailView.scrollView.contentInset.bottom = .zero
  }
}

extension DetailVC: UITextFieldDelegate {
  
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    guard let text = textField.text else { return true }
    let newLength = text.count + string.count - range.length
    
    if newLength >= 18 {
      self.detailView.titleField.rx.errorMessage.onNext("write_error_max_length_title".localized)
    } else {
      self.detailView.titleField.rx.errorMessage.onNext(nil)
    }
    
    return newLength <= 18
  }
}