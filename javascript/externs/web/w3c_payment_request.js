/*
 * Copyright 2019 The Closure Compiler Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @fileoverview Definitions for W3C's Payment Request API.
 * @see https://w3c.github.io/payment-request/
 *
 * @externs
 */

/**
 * @constructor
 * @param {!Array<!PaymentMethodData>} methodData
 * @param {!PaymentDetailsInit} details
 * @param {!PaymentOptions=} options
 * @implements {EventTarget}
 * @see https://w3c.github.io/payment-request/#paymentrequest-interface
 */
function PaymentRequest(methodData, details, options) {}
/**
 * @param {!Promise<!PaymentDetailsUpdate>=} detailsPromise
 * @return {!Promise<!PaymentResponse>}
 */
PaymentRequest.prototype.show = function(detailsPromise) {};
/** @return {!Promise<undefined>} */
PaymentRequest.prototype.abort = function() {};
/** @return {!Promise<boolean>} */
PaymentRequest.prototype.canMakePayment = function() {};
/** @return {!Promise<boolean>} */
PaymentRequest.prototype.hasEnrolledInstrument = function() {};
/** @const {string} */
PaymentRequest.prototype.id;
/** @const {?PaymentAddress} */
PaymentRequest.prototype.shippingAddress;
/** @const {?string} */
PaymentRequest.prototype.shippingOption;
/** @const {?string} */
PaymentRequest.prototype.shippingType;
/** @type {?function(!Event)} */
PaymentRequest.prototype.onmerchantvalidation;
/** @type {?function(!Event)} */
PaymentRequest.prototype.onshippingaddresschange;
/** @type {?function(!Event)} */
PaymentRequest.prototype.onshippingoptionchange;
/** @type {?function(!Event)} */
PaymentRequest.prototype.onpaymentmethodchange;

/**
 * @record
 * @see https://w3c.github.io/payment-request/#paymentmethoddata-dictionary
 */
function PaymentMethodData() {};
/** @type {string} */
PaymentMethodData.prototype.supportedMethods;
/** @type {!Object|undefined} */
PaymentMethodData.prototype.data;

/**
 * @record
 * @see https://w3c.github.io/payment-request/#paymentcurrencyamount-dictionary
 */
function PaymentCurrencyAmount() {};
/** @type {string} */
PaymentCurrencyAmount.prototype.currency;
/** @type {string} */
PaymentCurrencyAmount.prototype.value;

/**
 * @record
 * @see https://w3c.github.io/payment-request/#paymentdetailsbase-dictionary
 */
function PaymentDetailsBase() {};
/** @type {!Array<!PaymentItem>|undefined} */
PaymentDetailsBase.prototype.displayItems;
/** @type {!Array<!PaymentShippingOption>|undefined} */
PaymentDetailsBase.prototype.shippingOptions;
/** @type {!Array<!PaymentDetailsModifier>|undefined} */
PaymentDetailsBase.prototype.modifiers;

/**
 * @extends {PaymentDetailsBase}
 * @record
 * @see https://w3c.github.io/payment-request/#paymentdetailsinit-dictionary
 */
function PaymentDetailsInit() {};
/** @type {string|undefined} */
PaymentDetailsInit.prototype.id;
/** @type {!PaymentItem} */
PaymentDetailsInit.prototype.total;

/**
 * @extends {PaymentDetailsBase}
 * @record
 * @see https://w3c.github.io/payment-request/#paymentdetailsupdate-dictionary
 */
function PaymentDetailsUpdate() {};
/** @type {string|undefined} */
PaymentDetailsUpdate.prototype.error;
/** @type {!PaymentItem|undefined} */
PaymentDetailsUpdate.prototype.total;
/** @type {!AddressErrors|undefined} */
PaymentDetailsUpdate.prototype.shippingAddressErrors;
/** @type {!PayerErrors|undefined} */
PaymentDetailsUpdate.prototype.payerErrors;
/** @type {!Object|undefined} */
PaymentDetailsUpdate.prototype.paymentMethodErrors;

/**
 * @record
 * @see https://w3c.github.io/payment-request/#paymentdetailsmodifier-dictionary
 */
function PaymentDetailsModifier() {};
/** @type {string} */
PaymentDetailsModifier.prototype.supportedMethods;
/** @type {!PaymentItem|undefined} */
PaymentDetailsModifier.prototype.total;
/** @type {!Array<!PaymentItem>|undefined} */
PaymentDetailsModifier.prototype.additionalDisplayItems;
/** @type {!Object|undefined} */
PaymentDetailsModifier.prototype.data;

/**
 * @record
 * @see https://w3c.github.io/payment-request/#paymentoptions-dictionary
 */
function PaymentOptions() {};
/** @type {boolean|undefined} */
PaymentOptions.prototype.requestPayerName;
/** @type {boolean|undefined} */
PaymentOptions.prototype.requestBillingAddress;
/** @type {boolean|undefined} */
PaymentOptions.prototype.requestPayerEmail;
/** @type {boolean|undefined} */
PaymentOptions.prototype.requestPayerPhone;
/** @type {boolean|undefined} */
PaymentOptions.prototype.requestShipping;
/** @type {string|undefined} */
PaymentOptions.prototype.shippingType;

/**
 * @record
 * @see https://w3c.github.io/payment-request/#paymentitem-dictionary
 */
function PaymentItem() {};
/** @type {string} */
PaymentItem.prototype.label;
/** @type {!PaymentCurrencyAmount} */
PaymentItem.prototype.amount;
/** @type {boolean|undefined} */
PaymentItem.prototype.pending;

/**
 * @interface
 * @see https://w3c.github.io/payment-request/#paymentaddress-interface
 */
function PaymentAddress() {}
/**
 * @return {Object}
 * @override
 */
PaymentAddress.prototype.toJSON = function() {};
/** @const {string|undefined} */
PaymentAddress.prototype.city;
/** @const {string|undefined} */
PaymentAddress.prototype.country;
/** @const {string|undefined} */
PaymentAddress.prototype.dependentLocality;
/** @const {string|undefined} */
PaymentAddress.prototype.organization;
/** @const {string|undefined} */
PaymentAddress.prototype.phone;
/** @const {string|undefined} */
PaymentAddress.prototype.postalCode;
/** @const {string|undefined} */
PaymentAddress.prototype.recipient;
/** @const {string|undefined} */
PaymentAddress.prototype.region;
/** @const {string|undefined} */
PaymentAddress.prototype.sortingCode;
/** @const {!Array<string>|undefined} */
PaymentAddress.prototype.addressLine;

/**
 * @record
 * @see https://w3c.github.io/payment-request/#addressinit-dictionary
 */
function AddressInit() {};
/** @type {string|undefined} */
AddressInit.prototype.country;
/** @type {!Array<string>|undefined} */
AddressInit.prototype.addressLine;
/** @type {string|undefined} */
AddressInit.prototype.region;
/** @type {string|undefined} */
AddressInit.prototype.city;
/** @type {string|undefined} */
AddressInit.prototype.dependentLocality;
/** @type {string|undefined} */
AddressInit.prototype.postalCode;
/** @type {string|undefined} */
AddressInit.prototype.sortingCode;
/** @type {string|undefined} */
AddressInit.prototype.organization;
/** @type {string|undefined} */
AddressInit.prototype.recipient;
/** @type {string|undefined} */
AddressInit.prototype.phone;

/**
 * @record
 * @see https://w3c.github.io/payment-request/#addresserrors-dictionary
 */
function AddressErrors() {};
/** @type {string|undefined} */
AddressErrors.prototype.addressLine;
/** @type {string|undefined} */
AddressErrors.prototype.city;
/** @type {string|undefined} */
AddressErrors.prototype.country;
/** @type {string|undefined} */
AddressErrors.prototype.dependentLocality;
/** @type {string|undefined} */
AddressErrors.prototype.organization;
/** @type {string|undefined} */
AddressErrors.prototype.phone;
/** @type {string|undefined} */
AddressErrors.prototype.postalCode;
/** @type {string|undefined} */
AddressErrors.prototype.recipient;
/** @type {string|undefined} */
AddressErrors.prototype.region;
/** @type {string|undefined} */
AddressErrors.prototype.sortingCode;

/**
 * @record
 * @see https://w3c.github.io/payment-request/#paymentshippingoption-dictionary
 */
function PaymentShippingOption() {};
/** @type {string} */
PaymentShippingOption.prototype.id;
/** @type {string} */
PaymentShippingOption.prototype.label;
/** @type {!PaymentCurrencyAmount} */
PaymentShippingOption.prototype.amount;
/** @type {boolean|undefined} */
PaymentShippingOption.prototype.selected;

/**
 * @constructor
 * @implements {EventTarget}
 * @see https://w3c.github.io/payment-request/#paymentresponse-interface
 */
function PaymentResponse() {}
/**
 * @return {!Object}
 * @override
 */
PaymentResponse.prototype.toJSON = function() {};
/** @const {string} */
PaymentResponse.prototype.requestId;
/** @const {string} */
PaymentResponse.prototype.methodName;
/** @const {!Object} */
PaymentResponse.prototype.details;
/** @const {?PaymentAddress} */
PaymentResponse.prototype.shippingAddress;
/** @const {?string} */
PaymentResponse.prototype.shippingOption;
/** @const {?string} */
PaymentResponse.prototype.payerName;
/** @const {?string} */
PaymentResponse.prototype.payerEmail;
/** @const {?string} */
PaymentResponse.prototype.payerPhone;
/**
 * @param {string=} result
 * @return {!Promise<undefined>}
 */
PaymentResponse.prototype.complete = function(result) {};
/**
 * @param {!PaymentValidationErrors=} errorFields
 * @return {!Promise<undefined>}
 */
PaymentResponse.prototype.retry = function(errorFields) {};
/** @type {?function(!Event)} */
PaymentResponse.prototype.onpayerdetailchange;

/**
 * @record
 * @see https://w3c.github.io/payment-request/#paymentvalidationerrors-dictionary
 */
function PaymentValidationErrors() {};
/** @type {!PayerErrors|undefined} */
PaymentValidationErrors.prototype.payer;
/** @type {!AddressErrors|undefined} */
PaymentValidationErrors.prototype.shippingAddress;
/** @type {string|undefined} */
PaymentValidationErrors.prototype.error;
/** @type {!Object|undefined} */
PaymentValidationErrors.prototype.paymentMethod;

/**
 * @record
 * @see https://w3c.github.io/payment-request/#payererrors-dictionary
 */
function PayerErrors() {};
/** @type {string|undefined} */
PayerErrors.prototype.email;
/** @type {string|undefined} */
PayerErrors.prototype.name;
/** @type {string|undefined} */
PayerErrors.prototype.phone;

/**
 * @constructor
 * @param {string} type
 * @param {!MerchantValidationEventInit=} eventInitDict
 * @extends {Event}
 * @see https://w3c.github.io/payment-request/#merchantvalidationevent-interface
 */
function MerchantValidationEvent(type, eventInitDict) {};
/** @const {string} */
MerchantValidationEvent.prototype.methodName;
/** @const {string} */
MerchantValidationEvent.prototype.validationURL;
/**
 * @param {!Promise<undefined>} merchantSessionPromise
 * @return {undefined}
 */
MerchantValidationEvent.prototype.complete = function(
    merchantSessionPromise) {};

/**
 * @extends {EventInit}
 * @record
 * @see https://w3c.github.io/payment-request/#merchantvalidationeventinit-dictionary
 */
function MerchantValidationEventInit() {};
/** @type {string|undefined} */
MerchantValidationEventInit.prototype.methodName;
/** @type {string|undefined} */
MerchantValidationEventInit.prototype.validationURL;

/**
 * @constructor
 * @param {string} type
 * @param {!PaymentMethodChangeEventInit=} eventInitDict
 * @extends {PaymentRequestUpdateEvent}
 * @see https://w3c.github.io/payment-request/#paymentmethodchangeevent-interface
 */
function PaymentMethodChangeEvent(type, eventInitDict) {};
/** @const {string} */
PaymentMethodChangeEvent.prototype.methodName;
/** @const {?Object} */
PaymentMethodChangeEvent.prototype.methodDetails;

/**
 * @extends {PaymentRequestUpdateEventInit}
 * @record
 * @see https://w3c.github.io/payment-request/#paymentmethodchangeeventinit-dictionary
 */
function PaymentMethodChangeEventInit() {};
/** @type {string|undefined} */
PaymentMethodChangeEventInit.prototype.methodName;
/** @type {?Object|undefined} */
PaymentMethodChangeEventInit.prototype.methodDetails;

/**
 * @constructor
 * @param {string} type
 * @param {!PaymentRequestUpdateEventInit=} eventInitDict
 * @extends {Event}
 * @see https://w3c.github.io/payment-request/#paymentrequestupdateevent-interface
 */
function PaymentRequestUpdateEvent(type, eventInitDict) {};
/**
 * @param {!Promise<!PaymentDetailsUpdate>} detailsPromise
 * @return {undefined}
 */
PaymentRequestUpdateEvent.prototype.updateWith = function(detailsPromise) {};

/**
 * @extends {EventInit}
 * @record
 * @see https://w3c.github.io/payment-request/#paymentrequestupdateeventinit-dictionary
 */
function PaymentRequestUpdateEventInit() {};
