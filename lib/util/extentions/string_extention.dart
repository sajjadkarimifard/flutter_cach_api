extension MapExtention on Map<String, dynamic> {
  Map<String, dynamic> toLowerCase() {
    return Map.fromEntries(
      entries.map(
        (entry) => MapEntry(entry.key.toLowerCase(), entry.value),
      ),
    );
  }
}
