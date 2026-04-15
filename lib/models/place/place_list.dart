class Shop {
  Shop(
    this.id,
    this.title,
    this.imgURL,
    this.lat,
    this.long,
    this.electronic,
    this.ventilationFan,
    this.masticatory,
    this.situation,
    this.timezone,
    this.seatforme,
    this.sounds,
    this.source,
  );
  String id;
  String title;
  String? imgURL;
  double lat;
  double long;
  int electronic;
  int ventilationFan;
  int masticatory;
  String situation;
  String timezone;
  String seatforme;
  Map<String, double>? sounds;
  String? source;
}
