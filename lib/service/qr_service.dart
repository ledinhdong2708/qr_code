Map<String, String?> extractValuesFromQRData(String qrData) {
  final idPrefix = "ID: ";
  final docEntryPrefix = "DocEntry: ";
  final lineNumPrefix = "LineNum: ";

  String? id;
  String? docEntry;
  String? lineNum;

  final idIndex = qrData.indexOf(idPrefix);
  final docEntryIndex = qrData.indexOf(docEntryPrefix);
  final lineNumIndex = qrData.indexOf(lineNumPrefix);

  if (idIndex != -1) {
    final endIndex = qrData.indexOf(',', idIndex);
    id = qrData.substring(idIndex + idPrefix.length, endIndex != -1 ? endIndex : qrData.length).trim();
  }

  if (docEntryIndex != -1) {
    final endIndex = qrData.indexOf(',', docEntryIndex);
    docEntry = qrData.substring(docEntryIndex + docEntryPrefix.length, endIndex != -1 ? endIndex : qrData.length).trim();
  }

  if (lineNumIndex != -1) {
    final endIndex = qrData.indexOf(',', lineNumIndex);
    lineNum = qrData.substring(lineNumIndex + lineNumPrefix.length, endIndex != -1 ? endIndex : qrData.length).trim();
  }

  return {
    'id': id,
    'docEntry': docEntry,
    'lineNum': lineNum,
  };
}