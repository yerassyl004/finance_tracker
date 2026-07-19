import 'package:finance_app/app/di.dart';
import 'package:finance_app/presentation/survey/bloc/survey_bloc.dart';

extension SurveyDI on DI {
  SurveyBloc getSurveyBloc() {
    return SurveyBloc(getIt(), getIt());
  }
}
