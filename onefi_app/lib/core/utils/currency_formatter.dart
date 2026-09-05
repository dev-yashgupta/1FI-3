/// Utility for formatting Indian Rupee amounts consistently across the app.
abstract class CurrencyFormatter {
  /// Formats a number as ₹1,27,400 (Indian numbering system)
  static String format(num amount) {
    final int rounded = amount.round();
    return '₹${_formatIndian(rounded)}';
  }

  /// Formats as ₹1,27,400/mo
  static String formatMonthly(num amount) {
    return '${format(amount)}/mo';
  }

  /// Formats as ₹1,27,400/month
  static String formatPerMonth(num amount) {
    return '${format(amount)}/month';
  }

  static String _formatIndian(int n) {
    if (n < 0) return '-${_formatIndian(-n)}';
    final String s = n.toString();
    if (s.length <= 3) return s;

    final StringBuffer buf = StringBuffer();
    final int rem = (s.length - 3) % 2;
    int i = 0;

    // First group: 1 or 2 digits depending on total length parity
    final int firstGroup = rem == 0 ? 2 : 1;
    buf.write(s.substring(0, firstGroup));
    i = firstGroup;

    while (i < s.length - 3) {
      buf.write(',');
      buf.write(s.substring(i, i + 2));
      i += 2;
    }
    buf.write(',');
    buf.write(s.substring(s.length - 3));
    return buf.toString();
  }
}
