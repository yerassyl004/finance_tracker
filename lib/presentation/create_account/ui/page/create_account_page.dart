import 'package:finance_app/app/di.dart';
import 'package:finance_app/presentation/create_account/bloc/create_account_bloc.dart';
import 'package:finance_app/presentation/create_account/di.dart';
import 'package:finance_app/domain/models/account.dart';
import 'package:finance_app/presentation/create_account/ui/widget/balance_field_widget.dart';
import 'package:finance_app/presentation/create_account/ui/widget/name_field_widget.dart';
import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAccountPageArguments {
  final Account? account;
  CreateAccountPageArguments({this.account});
}

class CreateAccountPage extends StatelessWidget {
  final CreateAccountPageArguments? args;
  const CreateAccountPage({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di.getCreateAccountBloc(args?.account)
            ..add(CreateAccountEvent.init()),
      child: CreateAccountPageView(isEdit: args?.account != null),
    );
  }
}

class CreateAccountPageView extends StatelessWidget {
  final bool isEdit;
  const CreateAccountPageView({super.key, this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocConsumer<CreateAccountBloc, CreateAccountState>(
        listener: (context, state) {
          if (state is SuccessCreateAccountState) {
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) => state.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          show: (data) {
            final bloc = context.read<CreateAccountBloc>();
            final canSave = (data.account?.title ?? '').trim().isNotEmpty;

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  HomeSpacing.md,
                  HomeSpacing.sm,
                  HomeSpacing.md,
                  HomeSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _GrabHandle(),
                    _SheetHeader(
                      title: isEdit ? 'Edit account' : AppStrings.addNewAccount,
                    ),
                    const SizedBox(height: HomeSpacing.lg),

                    _FieldLabel(AppStrings.name),
                    const SizedBox(height: HomeSpacing.sm),
                    NameFieldWidget(
                      initialValue: data.account?.title,
                      placeholder: 'e.g. Cash, Card, Savings',
                      onChanged: (text) => bloc.add(
                        CreateAccountEvent.edit(
                          data: data.copyWith(
                            account: data.account?.copyWith(title: text),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: HomeSpacing.md),

                    _FieldLabel(AppStrings.initialAmount),
                    const SizedBox(height: HomeSpacing.sm),
                    BalanceFieldWidget(
                      initialValue: _initialAmountText(data.account),
                      onChanged: (text) => bloc.add(
                        CreateAccountEvent.edit(
                          data: data.copyWith(
                            account: data.account?.copyWith(
                              cash: double.tryParse(text) ?? 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: HomeSpacing.md),

                    _FieldLabel(AppStrings.selectIcon),
                    const SizedBox(height: HomeSpacing.sm),
                    SizedBox(
                      height: 68,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.imageAssets.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: HomeSpacing.sm),
                        itemBuilder: (context, index) => _IconOption(
                          asset: data.imageAssets[index],
                          selected: data.selectedImageIndex == index,
                          onTap: () => bloc.add(
                            CreateAccountEvent.edit(
                              data: data.copyWith(
                                account: data.account?.copyWith(
                                  icon: data.imageAssets[index],
                                ),
                                selectedImageIndex: index,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: HomeSpacing.xl),

                    PrimaryButton(
                      label: isEdit ? AppStrings.save : AppStrings.add,
                      enabled: canSave,
                      onTap: () =>
                          bloc.add(CreateAccountEvent.create(data: data)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Blank for a brand-new account (so the field shows its hint), the real
  /// balance when editing.
  String? _initialAmountText(Account? account) {
    if (account == null) return null;
    final cash = account.cash;
    if (cash == 0) return null;
    return cash == cash.roundToDouble()
        ? cash.toStringAsFixed(0)
        : cash.toString();
  }
}

// =============================================================================
// Shared sheet pieces (also used by CreateCategoryPage).
// =============================================================================

class _GrabHandle extends StatelessWidget {
  const _GrabHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: HomeSpacing.md),
        decoration: BoxDecoration(
          color: HomeTokens.track,
          borderRadius: BorderRadius.circular(HomeTokens.radiusPill),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final String title;
  const _SheetHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: HomeTokens.heading())),
        SizedBox(
          width: 36,
          height: 36,
          child: Material(
            color: HomeTokens.track,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.close_rounded,
                size: 18,
                color: HomeTokens.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: HomeTokens.label());
  }
}

/// A selectable icon chip (accent ring when active) shared by the create forms.
class _IconOption extends StatelessWidget {
  final String asset;
  final bool selected;
  final VoidCallback onTap;

  const _IconOption({
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 60,
        padding: const EdgeInsets.all(HomeSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? HomeTokens.accentSoft : HomeTokens.background,
          borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
          border: Border.all(
            color: selected ? HomeTokens.accent : HomeTokens.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Image.asset('assets/images/$asset.png', fit: BoxFit.contain),
      ),
    );
  }
}
