class TextInputLayout {
  static const String enter = 'ENTER';
  static const String backspace = '<-';
  List<List<String>> get letters {
    return [
      ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
      ['', 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ''],
      [backspace, 'Z', 'X', 'C', 'V', 'B', 'N', 'M', enter],
    ];
  }
}
