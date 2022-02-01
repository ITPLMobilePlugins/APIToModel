
class Input {
  Map<String, dynamic>? mInputValue = Map();

  Input(this.mInputValue);

  Input.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      // if (value.toString().trim().startsWith('{')) {
      //   input[key] = jsonDecode(value);
      // } else {
        mInputValue?[key] = value;
      // }
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    mInputValue?.forEach((key, value) {
      // if (value.toString().trim().startsWith('{')) {
      //   data[key] = json.decode(value);
      // } else {
      data[key] = value;
      // }
    });
    return data;
  }
}
