//
// CardSettingsPresenterTest.swift
// AptoSDK
//
// Created by Takeichi Kanzaki on 27/06/2019.
//

import XCTest
import AptoSDK
@testable import AptoUISDK

class CardSettingsPresenterTest: XCTestCase {
  private var sut: CardSettingsPresenter! // swiftlint:disable:this implicitly_unwrapped_optional

  // Collaborators
  private let serviceLocator = ServiceLocatorFake()
  private lazy var platform = serviceLocator.platformFake
  private let card = ModelDataProvider.provider.card
  private let config = CardSettingsPresenterConfig(cardholderAgreement: nil, privacyPolicy: nil, termsAndCondition: nil,
                                                   faq: nil, showDetailedCardActivity: true,
                                                   showMonthlyStatements: true)
  private let emailRecipients = ["email@aptopayments.com"]
  private let uiConfig = ModelDataProvider.provider.uiConfig
  private let view = CardSettingsViewSpy()
  private lazy var router = CardSettingsModuleSpy(serviceLocator: serviceLocator)
  private let interactor = CardSettingsInteractorFake()
  private let analyticsManager = AnalyticsManagerSpy()

  override func setUp() {
    super.setUp()
    setUpSUT(card: card, config: config)
  }

  func testViewLoadedTrackEvent() {
    // When
    sut.viewLoaded()

    // Then
    XCTAssertTrue(analyticsManager.trackCalled)
    XCTAssertEqual(Event.manageCardCardSettings, analyticsManager.lastEvent)
  }

  func testCardWithoutSetPinShowChangePinIsFalse() {
    // When
    sut.viewLoaded()

    // Then
    XCTAssertFalse(sut.viewModel.buttonsVisibility.value.showChangePin)
  }

  func testCardWithSetPinShowChangePinIsTrue() {
    // Given
    setUpSUT(card: ModelDataProvider.provider.cardWithChangePIN, config: config)

    // When
    sut.viewLoaded()

    // Then
    XCTAssertTrue(sut.viewModel.buttonsVisibility.value.showChangePin)
  }

  func testCardWithoutSetPassCodeIsFalse() {
    // When
    sut.viewLoaded()

    // Then
    XCTAssertFalse(sut.viewModel.buttonsVisibility.value.showSetPassCode)
  }

  func testCardWithSetPassCodeIsTrue() {
    // Given
    setUpSUT(card: ModelDataProvider.provider.cardWithPassCode, config: config)

    // When
    sut.viewLoaded()

    // Then
    XCTAssertTrue(sut.viewModel.buttonsVisibility.value.showSetPassCode)
  }

  func testCardWithoutGetPinShowGetIsFalse() {
    // When
    sut.viewLoaded()

    // Then
    XCTAssertFalse(sut.viewModel.buttonsVisibility.value.showGetPin)
  }

  func testCardWithGetPinShowGetPinIsTrue() {
    // Given
    setUpSUT(card: ModelDataProvider.provider.cardWithVoIP, config: config)

    // When
    sut.viewLoaded()

    // Then
    XCTAssertTrue(sut.viewModel.buttonsVisibility.value.showGetPin)
  }

  func testActiveCardLockedIsFalse() {
    // When
    sut.viewLoaded()

    // Then
    XCTAssertEqual(false, sut.viewModel.locked.value)
  }

  func testInactiveCardLockedIsTrue() {
    // Given
    setUpSUT(card: ModelDataProvider.provider.cardInactive, config: config)

    // When
    sut.viewLoaded()

    // Then
    XCTAssertEqual(true, sut.viewModel.locked.value)
  }

  func testCardWithoutIvrSupportShowIvrSupportIsFalse() {
    // When
    sut.viewLoaded()

    // Then
    XCTAssertFalse(sut.viewModel.buttonsVisibility.value.showIVRSupport)
  }

  func testCardWithIvrSupportShowIvrSupportIsTrue() {
    // Given
    setUpSUT(card: ModelDataProvider.provider.cardWithIVR, config: config)

    // When
    sut.viewLoaded()

    // Then
    XCTAssertTrue(sut.viewModel.buttonsVisibility.value.showIVRSupport)
  }

  func testViewLoadedWithShowDetailedCardActivityShowDetailedCardActivity() {
    // When
    sut.viewLoaded()

    // Then
    XCTAssertTrue(sut.viewModel.buttonsVisibility.value.showDetailedCardActivity)
  }

  func testViewLoadedWithoutShowDetailedCardActivityDoNotShowDetailedCardActivity() {
    // Given
    let config = CardSettingsPresenterConfig(cardholderAgreement: nil, privacyPolicy: nil, termsAndCondition: nil,
                                             faq: nil, showDetailedCardActivity: false, showMonthlyStatements: true)
    setUpSUT(card: card, config: config)

    // When
    sut.viewLoaded()

    // Then
    XCTAssertFalse(sut.viewModel.buttonsVisibility.value.showDetailedCardActivity)
  }

  func testViewLoadedWithShowMonthlyStatementsShowMonthlyStatements() {
    // When
    sut.viewLoaded()

    // Then
    XCTAssertTrue(sut.viewModel.buttonsVisibility.value.showMonthlyStatements)
  }

  func testViewLoadedWithoutShowMonthlyStatementsDoNotShowMonthlyStatements() {
    // Given
    let config = CardSettingsPresenterConfig(cardholderAgreement: nil, privacyPolicy: nil, termsAndCondition: nil,
                                             faq: nil, showDetailedCardActivity: false, showMonthlyStatements: false)
    setUpSUT(card: card, config: config)

    // When
    sut.viewLoaded()

    // Then
    XCTAssertFalse(sut.viewModel.buttonsVisibility.value.showMonthlyStatements)
  }

  func testViewLoadedLoadDetailedCardActivityEnabled() {
    // Given
    interactor.nextIsShowDetailedCardActivityEnabledResult = true

    // When
    sut.viewLoaded()

    // Then
    XCTAssertTrue(interactor.isShowDetailedCardActivityEnabledCalled)
    XCTAssertTrue(sut.viewModel.buttonsVisibility.value.isShowDetailedCardActivityEnabled)
  }

  func testUpdateCardNewStatusNotifyRouter() {
    // When
    sut.updateCardNewStatus()

    // Then
    XCTAssertTrue(router.cardStateChangedCalled)
    XCTAssertTrue(router.closeFromShiftCardSettingsCalled)
  }

  func testCloseTappedNotifyRouter() {
    // When
    sut.closeTapped()

    // Then
    XCTAssertTrue(router.closeFromShiftCardSettingsCalled)
  }

  func testCallIvrTappedCallCallURL() {
    // Given
    setUpSUT(card: ModelDataProvider.provider.cardWithIVR, config: config)

    // When
    sut.callIvrTapped()

    // Then
    XCTAssertTrue(router.callURLCalled)
  }

  func testChangePinTappedNotifyRouter() {
    // When
    sut.changePinTapped()

    // Then
    XCTAssertTrue(router.changeCardPinCalled)
  }

  func testSetPassCodeTappedNotifyRouter() {
    // When
    sut.setPassCodeTapped()

    // Then
    XCTAssertTrue(router.setPassCodeCalled)
  }

  func testCardWithVoIPGetPinTappedCallShowVoIP() {
    // Given
    setUpSUT(card: ModelDataProvider.provider.cardWithVoIP, config: config)

    // When
    sut.getPinTapped()

    // Then
    XCTAssertTrue(router.showVoIPCalled)
    XCTAssertEqual(VoIPActionSource.getPin, router.lastShowVoIPActionSource)
  }

  func testCardWithIvrGetPinTappedCallCallURL() {
    // Given
    setUpSUT(card: ModelDataProvider.provider.cardWithIVR, config: config)

    // When
    sut.getPinTapped()

    // Then
    XCTAssertTrue(router.callURLCalled)
  }

  func testShowContentCalledNotifyRouter() {
    // Given
    let content = Content.plainText("content")
    let title = "Title"

    // When
    sut.show(content: content, title: title)

    // Then
    XCTAssertTrue(router.showContentCalled)
    XCTAssertEqual(content, router.lastContentToShow)
    XCTAssertEqual(title, router.lastContentTitleToShow)
  }

  func testShowDetailedCardActivityCallInteractor() {
    // When
    sut.showDetailedCardActivity(true)

    // Then
    XCTAssertTrue(interactor.setShowDetailedCardActivityEnabledCalled)
    XCTAssertEqual(true, interactor.lastIsShowDetailedCardActivityEnabled)
  }

  func testShowDetailedCardActivityNotifyRouter() {
    // When
    sut.showDetailedCardActivity(true)

    // Then
    XCTAssertTrue(router.cardStateChangedCalled)
    XCTAssertEqual(true, router.lastCardStateChangeIncludeTransactions)
  }

  func testMonthlyStatementsTappedCallRouter() {
    // When
    sut.monthlyStatementsTapped()

    // Then
    XCTAssertTrue(router.showMonthlyStatementsCalled)
  }

  func testTapShowCardDetailsChangedCallRouterToAuthenticate() {
    // When
    sut.didTapOnShowCardInfo()

    // Then
    XCTAssertTrue(router.authenticateCalled)
  }

  func testAuthenticationSucceedAskRouterToShowCardInfoAndClose() {
    // Given
    router.nextAuthenticateResult = true

    // When
    sut.didTapOnShowCardInfo()

    // Then
    XCTAssertTrue(router.showCardInfoCalled)
    XCTAssertTrue(router.closeFromShiftCardSettingsCalled)
  }

  func testAuthenticationFailsUpdateViewModel() {
    // Given
    router.nextAuthenticateResult = false

    // When
    sut.didTapOnShowCardInfo()

    // Then
    XCTAssertFalse(router.showCardInfoCalled)
  }

  // MARK: - Helper methods
  private func setUpSUT(card: Card, config: CardSettingsPresenterConfig) {
    sut = CardSettingsPresenter(platform: platform, card: card, config: config, emailRecipients: emailRecipients,
                                uiConfig: uiConfig)
    sut.view = view
    sut.interactor = interactor
    sut.router = router
    sut.analyticsManager = analyticsManager
  }
}
