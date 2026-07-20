class AppStrings {
  static const String defaultError = 'default_error';
  static const String unknownError = 'Unknown error';
  static const String expenseText = 'Expense';
  static const String incomeText = 'Income';
  static const String balanceText = 'Balance';
  static const String addNewCategory = 'Add new category';
  static const String addNewAccount = 'Add new account';
  static const String type = 'Type';
  static const String untitled = 'Untitled';
  static const String accounts = 'Accounts';
  static const String account = 'Account';
  static const String categories = 'Categories';
  static const String categoriy = 'Category';
  static const String incomeCategories = 'Income Categories';
  static const String expenseCategories = 'Expense Categories';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String initialAmount = 'Initial amount';

  static const String name = 'Name';
  static const String selectIcon = 'Select an icon';
  static const String add = 'Add';
  static const String save = 'Save';
  static const String newTransaction = 'New Transaction';
  static const String transfer = 'Transfer';

  static const String addNotes = 'Add notes';
  static const String analysis = 'Analysis';
  static const String records = 'Records';
  static const String confirmDelete = 'Confirm Delete';
  static const String cancel = 'Cancel';
  static const String deleteSubTitle =
      'Are you sure you want to delete this transaction?';
  static const String noNoted = 'No noted';
  static const String note = 'Note';

  // Onboarding
  static const String onboardingNext = 'Next';
  static const String onboardingGetStarted = 'Get Started';
  static const String onboardingWelcomeTitle = 'Welcome to Finance Tracker';
  static const String onboardingWelcomeBody =
      'Take control of your money. Track wallets, spending and income all in one place.';
  static const String onboardingTransactionsTitle = 'Record every transaction';
  static const String onboardingTransactionsBody =
      'Add income, expenses and transfers between your accounts in a few taps.';
  static const String onboardingCategoriesTitle = 'Organise with categories';
  static const String onboardingCategoriesBody =
      'Group spending into categories like food, transport and bills to see where your money goes.';
  static const String onboardingAnalysisTitle = 'Understand your habits';
  static const String onboardingAnalysisBody =
      'Visual analytics break down your spending so you can budget smarter each month.';

  // Survey
  static const String surveyHeader = 'Set up your budget';
  static const String surveyBack = 'Back';
  static const String surveyNext = 'Next';
  static const String surveyFinish = 'Finish';
  static const String surveyRetry = 'Retry';
  static const String surveyProfileTitle = 'About you';
  static const String surveyProfileSubtitle =
      'A couple of quick questions so we can tailor the app to you.';
  static const String surveyGoalLabel = 'What do you want to focus on?';
  static const String surveyCurrencyLabel = 'Currency';
  static const String surveyPayFrequencyLabel = 'How often are you paid?';
  static const String surveyIncomeTitle = 'Your income';
  static const String surveyIncomeSubtitle =
      'Tell us how much you earn so we can plan your budget.';
  static const String surveySalary = 'Salary';
  static const String surveyOtherIncome = 'Other income (optional)';
  static const String surveyFixedTitle = 'Fixed monthly payments';
  static const String surveyFixedSubtitle =
      'How much do you pay every month for these essentials?';
  static const String surveyHouse = 'House / Rent';
  static const String surveyCar = 'Car / Loan';
  static const String surveyUtilities = 'Utilities';
  static const String surveyBudgetTitle = 'Monthly budget targets';
  static const String surveyBudgetSubtitle =
      'Set how much you want to spend on each category. We use this for analysis.';

  // AI financial analysis (Gemini)
  static const String aiInsightsTitle = 'AI Insights';
  static const String aiInsightsSubtitle =
      'Personalised tips based on your budget and spending.';
  static const String aiGenerate = 'Analyse my finances';
  static const String aiRegenerate = 'Refresh insights';
  static const String aiLoading = 'Analysing your finances…';
  static const String aiHealthScore = 'Financial health';
  static const String aiNoProfile =
      'Complete your budget setup to get AI insights.';
  static const String aiErrorMissingKey =
      'AI insights are unavailable: no API key configured.';
  static const String aiErrorInvalidKey =
      'AI insights are unavailable: the API key was rejected.';
  static const String aiErrorOffline =
      'You appear to be offline. Connect to the internet to get insights.';
  static const String aiErrorRateLimited =
      'Too many requests right now. Please try again in a moment.';
  static const String aiErrorBadResponse =
      'The AI returned an unexpected response. Please try again.';
  static const String aiErrorUnknown =
      'Could not generate insights right now. Please try again.';

  // Per-category budgets
  static const String budgetsTitle = 'Category budgets';
  static const String budgetsEmpty =
      'Add expenses or set category budgets in the survey to track them here.';
  static const String budgetSpent = 'Spent';
  static const String budgetRemaining = 'left';
  static const String budgetOverBy = 'over';
  static const String budgetNoBudget = 'No budget';
  static const String budgetSet = 'Set';
  static const String budgetDialogHint = 'Monthly budget';
  static const String budgetInvalidAmount = 'Enter a valid amount';

  // Notifications (daily reminders)
  static const String notifChannelName = 'Daily reminders';
  static const String notifChannelDescription =
      'Budget, expense-logging and daily summary reminders.';
  static const String notifMorningTitle = 'Good morning 👋';
  static const String notifMorningBody =
      'Check your budget for today and plan your spending.';
  static const String notifAfternoonTitle = 'Quick check-in';
  static const String notifAfternoonBody =
      'Logged your expenses yet? Add them before you forget.';
  static const String notifEveningTitle = 'Daily summary';
  static const String notifEveningBody =
      'Review what you spent today and see how you did.';
}
