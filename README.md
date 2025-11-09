# MoneyApp - Personal Finance Manager

A Flutter-based personal finance management application with AI-powered chat assistance.

## Features

- 📱 SMS-based transaction parsing
- 💬 AI-powered finance chat assistant with markdown support
- 💰 Account management
- 📊 Budget tracking
- 🔄 Transaction categorization
- 📤 Data export functionality

## AI Chat Backend

The app uses the **Your Finance Bro Agent** backend for AI-powered financial assistance.

**Backend Repository**: [Your-Finance-Bro--Agent](https://github.com/Pavel401/Your-Finance-Bro--Agent)

### Configuring Chat Backend URL

1. Open the app and navigate to the **Chat** screen
2. Tap the **Settings** icon (⚙️) in the app bar
3. In the "Backend URL" section, enter your backend URL:
   - Default: `https://your-finance-bro-agent-production.up.railway.app`
   - For local development: `http://localhost:8000` (or your local server URL)
   - For custom deployment: Enter your deployment URL
4. Click **Test & Save** to validate and save the URL
5. Click **Reset to Default** to restore the default production URL

### Setting Up Local Backend

To run the backend locally:

```bash
# Clone the backend repository
git clone https://github.com/Pavel401/Your-Finance-Bro--Agent.git
cd Your-Finance-Bro--Agent

# Follow the setup instructions in the backend repository
# Then update the app's backend URL to your local server (e.g., http://localhost:8000)
```

## Chat Features

- **Markdown Support**: Assistant responses are rendered with full markdown support including:
  - Headers (H1, H2, H3)
  - Bold, italic, and code formatting
  - Code blocks with syntax highlighting
  - Bulleted and numbered lists
  - Links (tap to open in browser)
  - Blockquotes
  
- **Configurable History**: Set how many previous messages are sent as context (2-20 messages)
- **Message Management**: Delete user messages while keeping assistant responses
- **Persistent Chat**: Chat history is saved locally and persists between sessions

## Getting Started

### Prerequisites

- Flutter SDK (^3.9.2)
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd moneyapp
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Dependencies

Key packages used:
- `get`: State management
- `drift`: Local database
- `flutter_markdown`: Markdown rendering in chat
- `http`: API communication
- `shared_preferences`: Local storage
- `permission_handler`: SMS permissions
- `image_picker`: Image handling
- `intl`: Internationalization

## Project Structure

```
lib/
├── core/
│   ├── constants/      # App constants
│   ├── dependencies/   # Dependency injection
│   ├── services/       # Services (chat, export, etc.)
│   ├── theme/          # App theme
│   └── utils/          # Utility functions
├── data/
│   ├── datasources/    # Data sources
│   ├── models/         # Data models
│   └── repositories/   # Repository implementations
├── domain/
│   ├── entities/       # Domain entities
│   ├── repositories/   # Repository interfaces
│   └── usecases/       # Business logic
└── presentation/
    ├── controllers/    # GetX controllers
    ├── views/          # Screens
    └── widgets/        # Reusable widgets
```




For issues related to:
- **Mobile App**: Open an issue in this repository
- **AI Backend**: Visit [Your-Finance-Bro--Agent](https://github.com/Pavel401/Your-Finance-Bro--Agent)
