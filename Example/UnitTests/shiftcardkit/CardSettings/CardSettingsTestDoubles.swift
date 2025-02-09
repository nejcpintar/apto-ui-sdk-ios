//
// CardSettingsTestDoubles.swift
// AptoSDK
//
// Created by Takeichi Kanzaki on 27/06/2019.
//

import AptoSDK
@testable import AptoUISDK

class CardSettingsModuleSpy: UIModuleSpy, CardSettingsRouterProtocol, CardSettingsModuleProtocol {
 
  var delegate: CardSettingsModuleDelegate?
  
  func showAddFunds(for card: Card, extraContent: ExtraContent?) {}
  
    func showAddMoneyBottomSheet(card: Card, extraContent: ExtraContent?) {}
    
    func showACHAccountAgreements(disclaimer: Content,
                                   cardId: String,
                                   acceptCompletion: @escaping () -> Void,
                                   declineCompletion: @escaping () -> Void) {}

    func showOrderPhysicalCard(_ card: Card, completion: OrderPhysicalCardUIComposer.OrderedCompletion?) {}
    
  private(set) var closeFromShiftCardSettingsCalled = false
  func closeFromShiftCardSettings() {
    closeFromShiftCardSettingsCalled = true
  }

  private(set) var changeCardPinCalled = false
  func changeCardPin() {
    changeCardPinCalled = true
  }

  private(set) var setPassCodeCalled = false
  func setPassCode() {
    setPassCodeCalled = true
  }

  private(set) var showVoIPCalled = false
  private(set) var lastShowVoIPActionSource: VoIPActionSource?
  func showVoIP(actionSource: VoIPActionSource) {
    showVoIPCalled = true
    lastShowVoIPActionSource = actionSource
  }

  private(set) var callURLCalled = false
  private(set) var lastURLToCall: URL?
  func call(url: URL, completion: @escaping () -> Void) {
    callURLCalled = true
    lastURLToCall = url
  }

  private(set) var showCardInfoCalled = false
  func showCardInfo() {
    showCardInfoCalled = true
  }

  private(set) var hideCardInfoCalled = false
  func hideCardInfo() {
    hideCardInfoCalled = true
  }

  private(set) var isCardInfoVisibleCalled = false
  func isCardInfoVisible() -> Bool {
    isCardInfoVisibleCalled = true
    return false
  }

  private(set) var cardStateChangedCalled = false
  private(set) var lastCardStateChangeIncludeTransactions: Bool?
  func cardStateChanged(includingTransactions: Bool) {
    cardStateChangedCalled = true
    lastCardStateChangeIncludeTransactions = includingTransactions
  }

  private(set) var showContentCalled = false
  private(set) var lastContentToShow: Content?
  private(set) var lastContentTitleToShow: String?
  func show(content: Content, title: String) {
    showContentCalled = true
    lastContentToShow = content
    lastContentTitleToShow = title
  }

  private(set) var showMonthlyStatementsCalled = false
  func showMonthlyStatements() {
    showMonthlyStatementsCalled = true
  }

  private(set) var authenticateCalled = false
  var nextAuthenticateResult = true
  func authenticate(completion: @escaping (Bool) -> Void) {
    authenticateCalled = true
    completion(nextAuthenticateResult)
  }
}

class CardSettingsModuleDelegateSpy: CardSettingsModuleDelegate {
  private(set) var showCardInfoCalled = false
  func showCardInfo() {
    showCardInfoCalled = true
  }

  private(set) var hideCardInfoCalled = false
  func hideCardInfo() {
    hideCardInfoCalled = true
  }

  private(set) var isCardInfoVisibleCalled = false
  func isCardInfoVisible() -> Bool {
    isCardInfoVisibleCalled = true
    return true
  }

  private(set) var cardStateChangedCalled = false
  private(set) var lastCardStateChangedIncludingTransactions: Bool?
  func cardStateChanged(includingTransactions: Bool) {
    cardStateChangedCalled = true
    lastCardStateChangedIncludingTransactions = includingTransactions
  }
}

class CardSettingsInteractorSpy: CardSettingsInteractorProtocol {
  private(set) var isShowDetailedCardActivityEnabledCalled = false
  func isShowDetailedCardActivityEnabled() -> Bool {
    isShowDetailedCardActivityEnabledCalled = true
    return true
  }

  private(set) var setShowDetailedCardActivityEnabledCalled = false
  private(set) var lastIsShowDetailedCardActivityEnabled: Bool?
  func setShowDetailedCardActivityEnabled(_ isEnabled: Bool) {
    setShowDetailedCardActivityEnabledCalled = true
    lastIsShowDetailedCardActivityEnabled = isEnabled
  }
}

class CardSettingsInteractorFake: CardSettingsInteractorSpy {
  var nextIsShowDetailedCardActivityEnabledResult = true
  override func isShowDetailedCardActivityEnabled() -> Bool {
    _ = super.isShowDetailedCardActivityEnabled()
    return nextIsShowDetailedCardActivityEnabledResult
  }
}

class CardSettingsPresenterSpy: CardSettingsPresenterProtocol {
  let viewModel = CardSettingsViewModel()
  // swiftlint:disable implicitly_unwrapped_optional
  var view: CardSettingsViewProtocol!
  var interactor: CardSettingsInteractorProtocol!
  var router: CardSettingsRouterProtocol!
  // swiftlint:enable implicitly_unwrapped_optional
  var analyticsManager: AnalyticsServiceProtocol?

  func didTapOnLoadFunds() {
      
  }
  
    func didTapOnOrderPhysicalCard() {}
    
  private(set) var viewLoadedCalled = false
  func viewLoaded() {
    viewLoadedCalled = true
  }

  private(set) var closeTappedCalled = false
  func closeTapped() {
    closeTappedCalled = true
  }

  private(set) var helpTappedCalled = false
  func helpTapped() {
    helpTappedCalled = true
  }

  private(set) var lostCardTappedCalled = false
  func lostCardTapped() {
    lostCardTappedCalled = true
  }

  private(set) var changePinTappedCalled = false
  func changePinTapped() {
    changePinTappedCalled = true
  }

  private(set) var getPinTappedCalled = false
  func getPinTapped() {
    getPinTappedCalled = true
  }

  private(set) var setPassCodeTappedCalled = false
  func setPassCodeTapped() {
    setPassCodeTappedCalled = true
  }

  private(set) var callIvrTappedCalled = false
  func callIvrTapped() {
    callIvrTappedCalled = true
  }

  private(set) var lockCardChangedCalled = false
  func lockCardChanged(switcher: UISwitch) {
    lockCardChangedCalled = true
  }

  private(set) var didTapOnShowCardInfoCalled = false
  func didTapOnShowCardInfo() {
    didTapOnShowCardInfoCalled = true
  }

  private(set) var showContentCalled = false
  private(set) var lastContentToShow: Content?
  private(set) var lastContentTitleToShow: String?
  func show(content: Content, title: String) {
    showContentCalled = true
    lastContentToShow = content
    lastContentTitleToShow = title
  }

  private(set) var updateCardNewStatusCalled = false
  func updateCardNewStatus() {
    updateCardNewStatusCalled = true
  }

  private(set) var showDetailedCardActivityCalled = false
  func showDetailedCardActivity(_ newValue: Bool) {
    showDetailedCardActivityCalled = true
  }

  private(set) var monthlyStatementsTappedCalled = false
  func monthlyStatementsTapped() {
    monthlyStatementsTappedCalled = true
  }
}

class CardSettingsViewSpy: ViewControllerSpy, CardSettingsViewProtocol {
  func show(error: Error) {
    super.show(error: error, uiConfig: nil)
  }

  private(set) var showClosedCardErrorAlertCalled = false
  private(set) var lastClosedCardErrorAlertTitle: String?
  func showClosedCardErrorAlert(title: String) {
    showClosedCardErrorAlertCalled = true
    lastClosedCardErrorAlertTitle = title
  }
}

class CardSettingsViewControllerDummy: ShiftViewController, CardSettingsViewProtocol {
  func showClosedCardErrorAlert(title: String) {
  }
}
