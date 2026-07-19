## Personal Finance Tracker

A personal finance tracker and budget management application.

# Features

Wallet Management: Users can create wallets to manage and fund them, with the ability to transfer funds between their accounts.
Analytics: Provides visual UI elements to display transactions and categorize expenses.
Transaction History: The main page shows a history of transactions, with detailed views for each transaction.
AI Insights: The Analysis page can request a structured, AI-generated review of your budget vs. spending (Gemini).
Reminders: Three recurring daily local notifications (morning budget, afternoon log-expense, evening summary).

# Gemini API key

The AI Insights feature reads the API key from a compile-time environment
variable so the secret never lives in source control. Pass it via `--dart-define`:

```
flutter run --dart-define=GEMINI_API_KEY=your_key_here
flutter build apk --release --no-tree-shake-icons --dart-define=GEMINI_API_KEY=your_key_here
```

Without a key the app runs normally; the AI Insights card simply reports that no
key is configured. In CI, provide the key as a secret and pass it through the
same `--dart-define` flag.


# Run Android CI/CD Pipeline
To trigger the CI/CD workflow for building the Flutter Android APK, use the following command in your terminal:

git checkout -b ci-cd

git add .

git commit -m "Trigger Android CI/CD"

git push origin ci-cd

This will trigger the GitHub Actions workflow defined in .github/workflows/flutter_android.yml and automatically build the APK.
