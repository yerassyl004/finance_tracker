import 'package:dartz/dartz.dart';
import 'package:finance_app/app/failure.dart';
import 'package:finance_app/domain/models/financial_profile.dart';
import 'package:finance_app/domain/repository/repository.dart';
import 'package:finance_app/domain/usecases.dart/base_usecase.dart';

class LoadFinancialProfileUsecase extends BaseUseCase<void, FinancialProfile?> {
  final Repository _repository;

  LoadFinancialProfileUsecase(this._repository);

  @override
  Future<Either<Failure, FinancialProfile?>> execute(input) {
    return _repository.loadFinancialProfile();
  }
}
