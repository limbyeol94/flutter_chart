import 'package:json_annotation/json_annotation.dart';

part 'healthy_step_model.g.dart';

@JsonSerializable()
class HealthyStepModel {
  final String date, step;

  HealthyStepModel({
    required this.date,
    required this.step,
  });

  factory HealthyStepModel.fromJson(Map<String, dynamic> json) =>
      _$HealthyStepModelFromJson(json);
  Map<String, dynamic> toJson() => _$HealthyStepModelToJson(this);
}
