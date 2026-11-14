extension StringExtensions on String {
  bool get isNullOrEmpty => isEmpty;
  
  bool get isNotNullOrEmpty => !isEmpty;
  
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
  
  String toTitleCase() {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }
}


