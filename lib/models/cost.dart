part of 'models.dart';

class Cost extends Equatable {
  final int? value;
  final String? etd;
  final String? note;
  final String? courier;
  final String? service; // Ensure this line is present

  const Cost({this.value, this.etd, this.note, this.courier, this.service});

  factory Cost.fromJson(Map<String, dynamic> json) => Cost(
        value: json['value'] as int?,
        etd: json['etd'] as String?,
        note: json['note'] as String?,
        courier: json['code']
            as String?, // Ganti 'code' sesuai dengan key yang benar
      );

  Map<String, dynamic> toJson() => {
        'value': value,
        'etd': etd,
        'note': note,
        'courier': courier,
      };

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [value, etd, note, courier];
}
