import 'package:dartz/dartz.dart';
import 'package:finance_app/app/failure.dart';
import 'package:finance_app/domain/models/financial_analysis.dart';
import 'package:finance_app/domain/repository/repository.dart';
import 'package:finance_app/domain/usecases.dart/base_usecase.dart';

/// Requests a structured financial analysis from the AI layer.
///
/// Returns typed [Failure]s (offline, rate limit, missing key, etc.) via the
/// repository so the presentation layer can react without knowing about Gemini.
class GetFinancialAnalysisUseCase
    extends BaseUseCase<FinancialAnalysisArguments, FinancialAnalysis> {
  final Repository _repository;

  GetFinancialAnalysisUseCase(this._repository);

  @override
  Future<Either<Failure, FinancialAnalysis>> execute(
    FinancialAnalysisArguments input,
  ) {
    return _repository.getFinancialAnalysis(input);
  }
}
