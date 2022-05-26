
# BNPL Webview Android Application

This application is having a bridging for BNPL onboarding flow and create payment to payment flow.

## Installation

Clone this repository and import into **Android Studio**

```bash
git clone git@github.com:kredx-eng/BNPL-Webview-app.git
```

## Documentation

[Documentation]()

## Getting started

This App contain 2 screens splash screen and main screen with dialogbox `BNPL webview`

```text
 |
 |  app/src/main
 |       |__ java/com/bnplwebview/activity
 |       |                       |
 |       |                       |__ SplashActivity.kt
 |       |                       |__ MainActivity.kt                    
 |       |
 |       |__ java/com/bnplwebview/Api
 |       |                       |__ ApiRequest.kt
 |       |
 |       |__ java/com/bnplwebview/preference
 |       |                       |
 |       |                       |__ AppPreference.kt
 |       |                       |__ PreferenceHelp.kt
 |       |                       
 |       |__ res/layout
 |       |       |
 |       |       |__ SplashActivity.xml
 |       |       |__ MainActivity.xml
 |       |
 |       |
 |       |__ res/xml
 |       |      |
 |       |      |__ file_path.xml
 |       |      |__ network_security_config.xml
 |       |                      
 |       | 
 |       |__ AndroidManifest.xml

build.gradle
```

- [SplashActivity](https://github.com/kredx-eng/BNPL-Webview-app/blob/main/android/app/src/main/java/com/bnplwebview/activity/SplashActivity.kt) is the main landing page which is having two buttons which opens up conditionaly.
  - **First button** `Register Flow` having a intent which opens webview which is having in `MainActivity`. first this will check all user permission. If all per granted then only it navigate to bnpl page.
  - **Second button** `Payment Flow` this check where user has onboardeded successfully or not. If onboardeded this store the token of user in local storage and then this button will hit the Order Create Api and pass url intent into webview `MainActivity`.
- [MainActivity](https://github.com/kredx-eng/BNPL-Webview-app/blob/main/android/app/src/main/java/com/bnplwebview/activity/MainActivity.kt) this actvity is having a dialog box which contains a webview and this webview is having a certian modifications according to the requirement.


## Library

`implementation 'androidx.webkit:webkit:1.4.0'`
This webview we are using for showing webview pages

`implementation 'com.loopj.android:android-async-http:1.4.9'`
This Async https we are using for api calling

`implementation 'com.github.k0shk0sh:PermissionHelper:1.1.0'`
This we are using to capture mobile application permission for vKYC

`implementation 'androidx.swiperefreshlayout:swiperefreshlayout:1.1.0'`
This we are using for custom pull to refresh


## API Reference

#### Create Sample Order for dynamic transcation link

```http

  Post /orders
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `order_amount` | `number` | **Required**. Your API key |
| `merchant_order_number` | `string` | **Required**. Your API key |
| `discounts` | `[]` | **Required**. Your API key |
| `tax_amount` | `object` | **Required**. Your API key |
| `order_description` | `string` | **Required**. Your API key |
| `customer_details` | {"first_name": "string", "last_name": "string", "email": "string","phone": "string","company_pan": "string"} | **Required**. Your API key |
| `billing_address` | `object` | **Required**. Your API key |
| `shipping_address` | `object` | **Required**. Your API key |
| `order_lines` | `[{}]` | **Required**. Your API key |
| `urls` | `object` | **Required**. Your API key |

### This api will return you the payment flow redirected url

#### In this project we are using asynchttps library for rest api connection you can use anyother library according to your project