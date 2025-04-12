enum Languages {
  vi,
  en,
  th,
}

extension LanguagesExtension on Languages {
  String get value {
    switch (this) {
      case Languages.vi:
        return 'vi-VN';
      case Languages.en:
        return 'en-US';
      case Languages.th:
        return 'th-TH';
    }
  }
}
