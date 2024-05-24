class Language {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  Language(this.id, this.flag, this.languageCode, this.name);

  static List<Language> languageList() {
    return <Language>[
      Language(1, '🇺🇸', 'en', 'English'),
      Language(2, '🇪🇸', 'es', 'Spanish'),

    ];

  }
}
