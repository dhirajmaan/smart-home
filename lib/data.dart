class Data {
  Data({
    required this.led1,
    required this.led2,
    required this.sensor,
  });

  bool led1;
  bool led2;
  String sensor;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        led1: json["led1"],
        led2: json["led2"],
        sensor: json["sensor"],
      );

  Map<String, dynamic> toJson() => {
        "led1": led1,
        "led2": led2,
        "sensor": sensor,
      };
}
