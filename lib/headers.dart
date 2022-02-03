class Headers {
  Map<String, String> mHeaderValue = Map();
  Headers(this.mHeaderValue);

  Headers.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      mHeaderValue[key] = value.toString();
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    mHeaderValue.forEach((key, value) {
      data[key] = value.toString();
    });

    return data;
  }
}
