import 'package:auto_route/auto_route.dart';
import 'package:finance_app/app/di.dart';
import 'package:finance_app/presentation/accounts_modal/ui/pages/accounts_modal.dart';
import 'package:finance_app/presentation/categories/ui/pages/categories_page.dart';
import 'package:finance_app/presentation/create_transaction/bloc/create_transaction_bloc.dart';
import 'package:finance_app/presentation/create_transaction/di.dart';
import 'package:finance_app/presentation/create_transaction/ui/widget/input_textField_widget.dart';
import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:finance_app/domain/models/transaction.dart';
import 'package:finance_app/domain/models/type_spending.dart';

class CreateTransactionsArgument {
  final Transaction? transaction;
  const CreateTransactionsArgument(this.transaction);
}

@RoutePage()
class NewCreateTransactionsPage extends StatelessWidget {
  final CreateTransactionsArgument? args;
  const NewCreateTransactionsPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.getCreateTransactionBloc(args?.transaction)
        ..add(
          CreateTransactionEvent.initial(data: CreateTransactionData.init()),
        ),
      child: const NewCreateTransactionView(),
    );
  }
}

class NewCreateTransactionView extends StatefulWidget {
  const NewCreateTransactionView({super.key});

  @override
  State<NewCreateTransactionView> createState() =>
      _NewCreateTransactionViewState();
}

class _NewCreateTransactionViewState extends State<NewCreateTransactionView> {
  final TextEditingController _notesController = TextEditingController();

  /// Raw typed amount, e.g. "1234.5". Kept locally so the custom keypad can
  /// drive it without the system keyboard ever appearing.
  String _amountText = '';
  DateTime _selectedDate = DateTime.now();

  /// Editing an existing transaction: seed amount/note/date once, when the
  /// bloc has finished loading it into state.
  bool _seeded = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get _amount => double.tryParse(_amountText) ?? 0;

  // ---------------------------------------------------------------------------
  // Amount keypad
  // ---------------------------------------------------------------------------

  void _onKey(String key) {
    HapticFeedback.selectionClick();
    setState(() {
      if (key == 'del') {
        if (_amountText.isNotEmpty) {
          _amountText = _amountText.substring(0, _amountText.length - 1);
        }
        return;
      }
      if (key == '.') {
        if (_amountText.contains('.')) return;
        _amountText = _amountText.isEmpty ? '0.' : '$_amountText.';
        return;
      }
      // digit
      if (_amountText.contains('.')) {
        final decimals = _amountText.split('.')[1];
        if (decimals.length >= 2) return; // max 2 decimal places
      } else {
        final intPart = _amountText;
        if (intPart.length >= 9) return; // sane upper bound
        if (intPart == '0') {
          _amountText = key; // no leading zeros
          return;
        }
      }
      _amountText = '$_amountText$key';
    });
  }

  String get _formattedAmount {
    if (_amountText.isEmpty) return '0';
    final parts = _amountText.split('.');
    final intValue = int.tryParse(parts[0]) ?? 0;
    final grouped = NumberFormat('#,##0', 'en_US').format(intValue);
    return parts.length > 1 ? '$grouped.${parts[1]}' : grouped;
  }

  // ---------------------------------------------------------------------------
  // Field editing
  // ---------------------------------------------------------------------------

  void _updateType(
    CreateTransactionBloc bloc,
    CreateTransactionData data,
    TypeSpending type,
  ) {
    if (data.selectedType == type) return;
    HapticFeedback.selectionClick();
    // Keep the amount and the source account; only clear the type-specific
    // selections (category / destination) that no longer apply.
    bloc.add(
      CreateTransactionEvent.edit(
        data: data.copyWith(
          selectedType: type,
          category: null,
          toAccount: null,
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 1, 12, 31),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: HomeTokens.accent,
            onPrimary: HomeTokens.surface,
            onSurface: HomeTokens.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDate.hour,
          _selectedDate.minute,
        );
      });
    }
  }

  Future<void> _editNote() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(HomeSpacing.md),
          decoration: BoxDecoration(
            color: HomeTokens.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(HomeTokens.radiusLg),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputTextfieldWidget(
                  hintText: AppStrings.addNotes,
                  inputType: TextInputType.text,
                  maxLine: 4,
                  minLine: 2,
                  controller: _notesController,
                ),
                const SizedBox(height: HomeSpacing.md),
                _PrimaryButton(
                  label: AppStrings.save,
                  enabled: true,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    setState(() {}); // reflect the note preview
  }

  void _showAccountPicker(
    BuildContext context,
    CreateTransactionBloc bloc,
    CreateTransactionData data,
    bool fromAccount,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: HomeTokens.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(HomeTokens.radiusLg),
            ),
          ),
          child: AddAccountsPage(
            fromAccount: fromAccount,
            onTap: (account) {
              bloc.add(
                CreateTransactionEvent.edit(
                  data: fromAccount
                      ? data.copyWith(fromAccount: account)
                      : data.copyWith(toAccount: account),
                ),
              );
            },
            data: data,
          ),
        ),
      ),
    );
  }

  void _showCategoryPicker(
    BuildContext context,
    CreateTransactionBloc bloc,
    CreateTransactionData data,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: HomeTokens.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(HomeTokens.radiusLg),
            ),
          ),
          child: CategoriesPage(
            onCategorySelected: (category) {
              bloc.add(
                CreateTransactionEvent.edit(
                  data: data.copyWith(category: category),
                ),
              );
              Navigator.pop(context);
            },
            isExpense: data.selectedType == TypeSpending.expense,
            data: data,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Validation & save
  // ---------------------------------------------------------------------------

  /// Returns the next required step, or null when the form is ready to save.
  String? _missingStep(CreateTransactionData data) {
    if (_amount <= 0) return 'Enter an amount';
    if (data.fromAccount == null) {
      return data.selectedType == TypeSpending.transfer
          ? 'Choose the source account'
          : 'Choose an account';
    }
    if (data.selectedType == TypeSpending.transfer) {
      if (data.toAccount == null) return 'Choose the destination account';
      if (data.fromAccount?.id == data.toAccount?.id) {
        return 'Pick two different accounts';
      }
    } else if (data.category == null) {
      return 'Choose a category';
    }
    return null;
  }

  void _save(CreateTransactionBloc bloc, CreateTransactionData data) {
    final isTransfer = data.selectedType == TypeSpending.transfer;
    final transaction = Transaction(
      id: data.transaction?.id,
      cash: _amount,
      date: _selectedDate,
      note: _notesController.text,
      account: data.fromAccount,
      destination: isTransfer ? data.toAccount : null,
      category: isTransfer ? null : data.category,
      typeSpending: data.selectedType,
    );
    bloc.add(
      CreateTransactionEvent.saveTransaction(
        data: data.copyWith(transaction: transaction),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateTransactionBloc, CreateTransactionState>(
      listener: (context, state) {
        if (state is SuccessTransactionState) {
          Navigator.pop(context, true);
          return;
        }
        // Seed the editable fields from an existing transaction exactly once.
        if (!_seeded) {
          final t = state.data.transaction;
          if (t != null) {
            _seeded = true;
            _selectedDate = t.date;
            _notesController.text = t.note ?? '';
            final cash = t.cash;
            _amountText = cash <= 0
                ? ''
                : (cash == cash.roundToDouble()
                      ? cash.toStringAsFixed(0)
                      : cash.toString());
            setState(() {});
          }
        }
      },
      builder: (context, state) {
        final bloc = context.read<CreateTransactionBloc>();
        final data = state.data;
        final isSaving = state is LoadingTransactionState;
        final isEdit = data.transaction != null;

        return Scaffold(
          backgroundColor: HomeTokens.background,
          appBar: AppBar(
            backgroundColor: HomeTokens.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: HomeTokens.textPrimary,
              ),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            ),
            title: Text(
              isEdit ? 'Edit transaction' : AppStrings.newTransaction,
              style: HomeTokens.heading(),
            ),
            centerTitle: true,
          ),
          body: state is InitialTransactionState
              ? Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: HomeTokens.accent,
                    ),
                  ),
                )
              : _buildForm(context, bloc, data, isSaving, isEdit),
        );
      },
    );
  }

  Widget _buildForm(
    BuildContext context,
    CreateTransactionBloc bloc,
    CreateTransactionData data,
    bool isSaving,
    bool isEdit,
  ) {
    final typeColor = HomeTokens.forType(data.selectedType);
    final missing = _missingStep(data);
    final canSave = missing == null && !isSaving;
    final isTransfer = data.selectedType == TypeSpending.transfer;

    return SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: HomeTokens.contentMaxWidth,
          ),
          child: Column(
            children: [
              // Segmented type control.
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  HomeSpacing.md,
                  HomeSpacing.sm,
                  HomeSpacing.md,
                  0,
                ),
                child: _TypeSelector(
                  selected: data.selectedType,
                  onChanged: (type) => _updateType(bloc, data, type),
                ),
              ),

              // Scrollable middle so small screens never overflow while the
              // keypad + save button stay pinned to the bottom.
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: HomeSpacing.md,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: HomeSpacing.lg),
                      _AmountDisplay(
                        amount: _formattedAmount,
                        color: typeColor,
                        isPlaceholder: _amountText.isEmpty,
                      ),
                      const SizedBox(height: HomeSpacing.lg),

                      // Account / category selection.
                      if (isTransfer)
                        Row(
                          children: [
                            Expanded(
                              child: _SelectTile(
                                label: 'From',
                                title: data.fromAccount?.title ?? 'Account',
                                icon: data.fromAccount?.icon ?? 'wallet_icon',
                                selected: data.fromAccount != null,
                                onTap: () => _showAccountPicker(
                                  context,
                                  bloc,
                                  data,
                                  true,
                                ),
                              ),
                            ),
                            const SizedBox(width: HomeSpacing.sm),
                            const _TransferArrow(),
                            const SizedBox(width: HomeSpacing.sm),
                            Expanded(
                              child: _SelectTile(
                                label: 'To',
                                title: data.toAccount?.title ?? 'Account',
                                icon: data.toAccount?.icon ?? 'wallet_icon',
                                selected: data.toAccount != null,
                                onTap: () => _showAccountPicker(
                                  context,
                                  bloc,
                                  data,
                                  false,
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: _SelectTile(
                                label: AppStrings.categoriy,
                                title:
                                    data.category?.title ??
                                    AppStrings.categoriy,
                                icon: data.category?.icon ?? 'category_icon',
                                selected: data.category != null,
                                accent: true,
                                onTap: () =>
                                    _showCategoryPicker(context, bloc, data),
                              ),
                            ),
                            const SizedBox(width: HomeSpacing.md),
                            Expanded(
                              child: _SelectTile(
                                label: AppStrings.account,
                                title:
                                    data.fromAccount?.title ??
                                    AppStrings.account,
                                icon: data.fromAccount?.icon ?? 'wallet_icon',
                                selected: data.fromAccount != null,
                                onTap: () => _showAccountPicker(
                                  context,
                                  bloc,
                                  data,
                                  true,
                                ),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: HomeSpacing.md),

                      // Meta: date + note.
                      Row(
                        children: [
                          Expanded(
                            child: _MetaChip(
                              icon: Icons.calendar_today_rounded,
                              label: _dateLabel(_selectedDate),
                              onTap: _pickDate,
                            ),
                          ),
                          const SizedBox(width: HomeSpacing.sm),
                          Expanded(
                            child: _MetaChip(
                              icon: Icons.sticky_note_2_outlined,
                              label: _notesController.text.trim().isEmpty
                                  ? AppStrings.addNotes
                                  : _notesController.text.trim(),
                              muted: _notesController.text.trim().isEmpty,
                              onTap: _editNote,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: HomeSpacing.md),
                    ],
                  ),
                ),
              ),

              // Guidance hint (what's still needed).
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: (missing != null && !isSaving)
                    ? Padding(
                        key: ValueKey(missing),
                        padding: const EdgeInsets.only(bottom: HomeSpacing.sm),
                        child: Text(
                          missing,
                          style: HomeTokens.bodyMuted(),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox(height: HomeSpacing.sm),
              ),

              _Keypad(onKey: _onKey),
              Padding(
                padding: const EdgeInsets.all(HomeSpacing.md),
                child: _PrimaryButton(
                  label: isEdit ? AppStrings.save : AppStrings.add,
                  enabled: canSave,
                  loading: isSaving,
                  onTap: () => _save(bloc, data),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _dateLabel(DateTime date) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday =
        date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    return DateFormat('MMM d, yyyy').format(date);
  }
}

// =============================================================================
// Pieces
// =============================================================================

/// Segmented Expense · Income · Transfer control on a neutral track.
class _TypeSelector extends StatelessWidget {
  final TypeSpending selected;
  final ValueChanged<TypeSpending> onChanged;

  const _TypeSelector({required this.selected, required this.onChanged});

  static const _items = <TypeSpending, String>{
    TypeSpending.expense: AppStrings.expenseText,
    TypeSpending.income: AppStrings.incomeText,
    TypeSpending.transfer: AppStrings.transfer,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(HomeSpacing.xs),
      decoration: BoxDecoration(
        color: HomeTokens.track,
        borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
      ),
      child: Row(
        children: _items.entries.map((e) {
          final isSelected = e.key == selected;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? HomeTokens.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(HomeTokens.radiusSm),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  e.value,
                  style: HomeTokens.body().copyWith(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? HomeTokens.forType(e.key)
                        : HomeTokens.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// The hero amount, currency-prefixed and tinted by the selected type.
class _AmountDisplay extends StatelessWidget {
  final String amount;
  final Color color;
  final bool isPlaceholder;

  const _AmountDisplay({
    required this.amount,
    required this.color,
    required this.isPlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    final valueColor = isPlaceholder ? HomeTokens.textTertiary : color;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Text(
              '₸',
              style: HomeTokens.metricHero().copyWith(
                color: valueColor.withValues(alpha: 0.5),
                fontSize: 28,
              ),
            ),
          ),
          Text(
            amount,
            style: HomeTokens.metricHero().copyWith(
              color: valueColor,
              fontSize: 48,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

/// A tappable account/category selector with a label, glyph and value.
class _SelectTile extends StatelessWidget {
  final String label;
  final String title;
  final String icon;
  final bool selected;
  final bool accent;
  final VoidCallback onTap;

  const _SelectTile({
    required this.label,
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    final ringColor = selected ? HomeTokens.accent : HomeTokens.border;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: HomeTokens.label()),
        const SizedBox(height: HomeSpacing.sm),
        Material(
          color: HomeTokens.surface,
          borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
          child: InkWell(
            borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(HomeSpacing.sm + HomeSpacing.xs),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
                border: Border.all(color: ringColor, width: selected ? 1.5 : 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: HomeTokens.background,
                      borderRadius: BorderRadius.circular(HomeTokens.radiusSm),
                    ),
                    child: Image.asset(
                      'assets/images/$icon.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        accent ? Icons.category_rounded : Icons.wallet_rounded,
                        size: 18,
                        color: HomeTokens.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: HomeSpacing.sm),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HomeTokens.body().copyWith(
                        color: selected
                            ? HomeTokens.textPrimary
                            : HomeTokens.textSecondary,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: selected
                        ? HomeTokens.accent
                        : HomeTokens.textTertiary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TransferArrow extends StatelessWidget {
  const _TransferArrow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Icon(
        Icons.arrow_forward_rounded,
        size: 18,
        color: HomeTokens.textTertiary,
      ),
    );
  }
}

/// Compact, low-emphasis chip for date / note.
class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool muted;
  final VoidCallback onTap;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HomeTokens.surface,
      borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: HomeSpacing.md,
            vertical: HomeSpacing.sm + 2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
            border: Border.all(color: HomeTokens.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: HomeTokens.textSecondary),
              const SizedBox(width: HomeSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: muted
                      ? HomeTokens.bodyMuted()
                      : HomeTokens.body().copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The in-app numeric keypad (no system keyboard, no occlusion).
class _Keypad extends StatelessWidget {
  final ValueChanged<String> onKey;
  const _Keypad({required this.onKey});

  static const _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['.', '0', 'del'],
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HomeSpacing.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _rows
            .map(
              (row) => Row(
                children: row
                    .map(
                      (k) => Expanded(
                        child: _KeypadKey(value: k, onKey: onKey),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _KeypadKey extends StatelessWidget {
  final String value;
  final ValueChanged<String> onKey;
  const _KeypadKey({required this.value, required this.onKey});

  @override
  Widget build(BuildContext context) {
    final isDelete = value == 'del';
    return Padding(
      padding: const EdgeInsets.all(HomeSpacing.xs),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
        child: InkWell(
          borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
          onTap: () => onKey(value),
          child: SizedBox(
            height: 52,
            child: Center(
              child: isDelete
                  ? const Icon(
                      Icons.backspace_outlined,
                      size: 22,
                      color: HomeTokens.textSecondary,
                    )
                  : Text(
                      value,
                      style: HomeTokens.metricMedium().copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Full-width accent primary action with disabled + loading states.
class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final bool loading;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.label,
    required this.enabled,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final active = enabled && !loading;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: active ? 1 : 0.55,
      child: Material(
        color: active ? HomeTokens.accent : HomeTokens.textTertiary,
        elevation: active ? 2 : 0,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
        child: InkWell(
          borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
          onTap: active ? onTap : null,
          child: SizedBox(
            height: 54,
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      label,
                      style: HomeTokens.body().copyWith(
                        color: HomeTokens.surface,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
