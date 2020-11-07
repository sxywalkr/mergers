import 'package:meta/meta.dart';

class PenyediaModel {
  final String id;
  final String aNamaBadanUsaha;
  final String aStatus;
  final String aAlamatPusat;
  final String aTelpPusat;
  final String aFaxPusat;
  final String aEmailPusat;

  PenyediaModel({
    @required this.id,
    @required this.aNamaBadanUsaha,
    this.aStatus,
    this.aAlamatPusat,
    this.aTelpPusat,
    this.aFaxPusat,
    this.aEmailPusat,
  });

  factory PenyediaModel.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    String aNamaBadanUsaha = data['aNamaBadanUsaha'];
    String aStatus = data['aStatus'];
    String aAlamatPusat = data['aAlamatPusat'];
    String aTelpPusat = data['aTelpPusat'];
    String aFaxPusat = data['aFaxPusat'];
    String aEmailPusat = data['aEmailPusat'];

    return PenyediaModel(
      id: documentId,
      aNamaBadanUsaha: aNamaBadanUsaha,
      aStatus: aStatus,
      aAlamatPusat: aAlamatPusat,
      aTelpPusat: aTelpPusat,
      aFaxPusat: aFaxPusat,
      aEmailPusat: aEmailPusat,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'aNamaBadanUsaha': aNamaBadanUsaha,
      'aStatus': aStatus,
      'aAlamatPusat': aAlamatPusat,
      'aTelpPusat': aTelpPusat,
      'aFaxPusat': aFaxPusat,
      'aEmailPusat': aEmailPusat,
    };
  }
}
