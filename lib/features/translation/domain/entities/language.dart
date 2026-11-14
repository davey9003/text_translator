class Language {
  final String code;
  final String name;
  final String nativeName;
  
  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Language && other.code == code;
  }
  
  @override
  int get hashCode => code.hashCode;
}


