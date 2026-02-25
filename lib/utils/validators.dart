// ---------------------------------------------------------------------------
// Application-level input validators.
// All functions return null on success (matching Flutter FormField.validator
// convention) and a human-readable error string on failure.
// ---------------------------------------------------------------------------
// Case title
// ---------------------------------------------------------------------------

/// Title is the only required field for a case.
/// Returns an error string if [value] is null or blank, otherwise `null`.
String? validateCaseTitle(String? value) {
  if (value == null || value.trim().isEmpty) return 'Title is required';
  return null;
}

// ---------------------------------------------------------------------------
// Client phone (Pakistani mobile — optional, so empty is allowed)
// ---------------------------------------------------------------------------

/// Accepts Pakistani mobile formats:
///   - `03XX-XXXXXXX`   (12 chars with dash)
///   - `03XXXXXXXXX`    (11 digits, no dash)
///   - `+923XXXXXXXXX`  (13 chars international)
///
/// Empty / null is allowed (field is optional on the case form).
String? validateClientPhone(String? value) {
  if (value == null || value.trim().isEmpty) return null; // optional
  final v = value.trim();
  final re = RegExp(r'^(\+92|0)3\d{9}$|^03\d{2}-\d{7}$');
  if (!re.hasMatch(v)) {
    return 'Enter a valid Pakistani mobile number (e.g. 0300-1234567)';
  }
  return null;
}

// ---------------------------------------------------------------------------
// CNIC (optional on the case form, but must match format when supplied)
// ---------------------------------------------------------------------------

/// Standard Pakistani CNIC format: `XXXXX-XXXXXXX-X`
/// Empty / null is allowed (field is optional).
String? validateCnic(String? value) {
  if (value == null || value.trim().isEmpty) return null; // optional
  final v = value.trim();
  final re = RegExp(r'^\d{5}-\d{7}-\d$');
  if (!re.hasMatch(v)) {
    return 'CNIC format: XXXXX-XXXXXXX-X';
  }
  return null;
}
