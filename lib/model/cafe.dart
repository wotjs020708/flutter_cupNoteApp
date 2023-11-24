class Cafe {
  final int? id;
  final String cafeName;
  final String beenName;
  final String brewing;
  final String hotIce;
  final String processing;
  final String cupNote;

  Cafe({
    required this.cafeName,
    required this.beenName,
    required this.brewing,
    required this.hotIce,
    required this.processing,
    required this.cupNote,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cafeName': cafeName,
      'beenName': beenName,
      'brewing': brewing,
      'hotIce': hotIce,
      'processing': processing,
      'cupNote': cupNote,
    };
  }
}
