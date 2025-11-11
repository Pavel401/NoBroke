

## Introduction

No Broke ("we," "our," or "the App") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, store, and protect your information when you use our personal finance management application.

## Information We Collect

### 1. SMS Messages
- **What we collect:** The App reads SMS messages from your device to extract banking and financial transaction information.
- **Purpose:** To automatically parse and categorize your financial transactions from banking SMS notifications.
- **How it's used:** SMS content is processed locally on your device to identify transaction details (amount, merchant, date, type).
- **Storage:** Only transaction-related SMS content is stored locally in the app's database.

### 2. Camera and Photos
- **What we collect:** Images captured through the camera or selected from your device's photo library.
- **Purpose:** To allow you to attach receipts, bills, or other transaction-related images to your financial records.
- **How it's used:** Images are stored locally on your device and associated with specific transactions.
- **Storage:** All photos are stored locally on your device within the app's storage.

### 3. Financial Data
We collect and store the following financial information that you provide:
- **Transaction details:** Amount, date, type (credit/debit), category, merchant name, description, location
- **Account information:** Account names, types, balances, and currency
- **Budget information:** Monthly budget allocations and spending limits
- **Notes and descriptions:** Any custom notes or descriptions you add to transactions

### 4. AI Chat Data
- **What we collect:** Your chat messages and queries sent to our AI finance assistant
- **Financial context:** Aggregated transaction data, account balances, and budget information sent to provide personalized financial advice
- **Chat history:** Previous conversation messages (configurable, 2-20 messages) for context
- **Purpose:** To provide AI-powered financial assistance and personalized recommendations

### 5. App Usage Data
- **Settings and preferences:** Your app configuration choices, theme preferences, and feature settings
- **Backend URL configuration:** Custom backend server URLs if configured

## How We Use Your Information

### Local Processing
- **SMS Parsing:** All SMS parsing and transaction extraction happens locally on your device using Google's Generative AI (Gemini) API
- **Data Storage:** All your financial data is stored locally in an encrypted SQLite database on your device
- **Offline Functionality:** Core features work offline without requiring internet connectivity

### AI-Powered Features
When you use the AI chat assistant:
- Your financial data (transactions, accounts, budgets) is sent to our backend server at `https://your-finance-bro-agent-production.up.railway.app` (or your configured custom URL)
- The backend uses this data to provide personalized financial advice and insights
- Chat history is maintained to provide contextual responses

### Data Analytics
- We do **NOT** collect analytics or tracking data
- We do **NOT** use third-party analytics services
- We do **NOT** track your app usage patterns


### Data We Do NOT Share:
- We do **NOT** sell your personal or financial data to third parties
- We do **NOT** share your data with advertisers
- We do **NOT** share your data with financial institutions
- We do **NOT** use your data for marketing purposes

## Permissions We Require

### Android Permissions:
- **READ_SMS:** To read banking SMS messages for transaction parsing
- **RECEIVE_SMS:** To receive new banking SMS in real-time
- **READ_EXTERNAL_STORAGE:** To access photos for transaction attachments
- **WRITE_EXTERNAL_STORAGE:** To save exported data files
- **CAMERA:** To capture photos of receipts and bills
- **INTERNET:** To communicate with the AI chat backend

All permissions are requested at runtime and can be denied. The app's functionality will be limited if permissions are not granted.

## Data Security

### Security Measures:
- **Local Encryption:** All data stored locally on your device is protected by the device's built-in security features
- **No Cloud Storage:** Your financial data is not automatically uploaded to cloud servers
- **Secure Communication:** All communications with backend services use HTTPS encryption

### Your Responsibilities:
- Keep your device secured with a password, PIN, or biometric lock
- Do not share your device with unauthorized users
- Regularly update the app to receive security patches

## Data Retention and Deletion

### Data Retention:
- **Local Data:** Your financial data remains on your device until you manually delete it
- **Chat History:** Chat messages are stored locally and can be deleted individually or entirely
- **SMS Content:** Only transaction-related SMS excerpts are stored; you can delete transactions at any time

### Data Deletion:
- **Individual Transactions:** Delete any transaction from within the app
- **Chat Messages:** Delete individual user messages while keeping assistant responses
- **Complete Data Removal:** Uninstalling the app removes all locally stored data
- **Backend Data:** Chat data on the backend may be temporarily cached; contact us to request deletion

## Data Export

The App provides a data export feature that allows you to:
- Export your financial data in JSON format
- Share or backup your data
- Transfer data between devices
- Maintain your own copies of your financial records

## Children's Privacy

No Broke is not intended for use by children under the age of 13. We do not knowingly collect personal information from children under 13. If you are a parent or guardian and believe your child has provided us with personal information, please contact us.

## Changes to Financial Data

You have complete control over your data:
- **Edit:** Modify any transaction, account, or budget information
- **Delete:** Remove any data you no longer want to keep
- **Export:** Download all your data at any time
- **Categories:** Customize transaction categories and labels


You have the right to:
- **Access:** View all data stored within the app
- **Correction:** Edit any incorrect information
- **Deletion:** Delete your data at any time
- **Portability:** Export your data in a machine-readable format
- **Opt-out:** Disable AI chat features and use the app offline

## Changes to This Privacy Policy

We may update this Privacy Policy from time to time. Changes will be reflected in the "Last Updated" date at the top of this policy. Continued use of the App after changes constitutes acceptance of the updated policy. Significant changes will be communicated through:
- In-app notifications
- Update notes in app stores
- Prominent notice on first app launch after update

## Open Source and Transparency

- The AI chat backend is open source: https://github.com/Pavel401/Your-Finance-Bro--Agent
- You can review how your data is processed by examining the backend code
- You can self-host the backend and configure the app to use your own server

## Compliance

This Privacy Policy is designed to comply with:
- General Data Protection Regulation (GDPR)
- California Consumer Privacy Act (CCPA)
- India's Information Technology Act and Digital Personal Data Protection Act (DPDPA)
- Other applicable data protection laws

## Contact Us

If you have questions, concerns, or requests regarding this Privacy Policy or your data:

**Email:** [pavelalam401@gmail.com]
**GitHub Issues:** https://github.com/Pavel401/nobroke/issues
**Backend Issues:** https://github.com/Pavel401/Your-Finance-Bro--Agent/issues

**Response Time:** We aim to respond to all privacy-related inquiries within 7 business days.

## Consent

By using No Broke, you consent to:
- The collection and processing of your data as described in this Privacy Policy
- The use of SMS reading permissions for transaction parsing
- The use of camera and storage permissions for receipt management
- The transmission of financial data to AI backend services when using chat features

You can withdraw consent at any time by:
- Revoking permissions in your device settings
- Disabling specific features within the app
- Uninstalling the app

**Thank you for trusting No Broke with your financial data. Your privacy is our priority.**
