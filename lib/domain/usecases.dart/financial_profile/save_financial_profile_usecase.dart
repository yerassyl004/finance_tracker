import 'package:dartz/dartz.dart';
import 'package:finance_app/app/failure.dart';
import 'package:finance_app/domain/models/financial_profile.dart';
import 'package:finance_app/domain/repository/repository.dart';
import 'package:finance_app/domain/usecases.dart/base_usecase.dart';

class SaveFinancialProfileUsecase
    extends BaseUseCase<FinancialProfile, String> {
  final Repository _repository;

  SaveFinancialProfileUsecase(this._repository);

  @override
  Future<Either<Failure, String>> execute(FinancialProfile input) {
    return _repository.saveFinancialProfile(input);
  }
}
