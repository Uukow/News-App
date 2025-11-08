import 'package:html/parser.dart' as html_parser;

class HtmlParser {
  /// Parse HTML string and extract plain text
  static String parseHtmlString(String htmlString) {
    if (htmlString.isEmpty) return '';
    
    try {
      final document = html_parser.parse(htmlString);
      final text = document.body?.text ?? '';
      
      // Trim and remove excessive whitespace
      return text.trim().replaceAll(RegExp(r'\s+'), ' ');
    } catch (e) {
      return htmlString;
    }
  }

  /// Strip HTML tags from a string
  static String stripHtmlTags(String htmlString) {
    if (htmlString.isEmpty) return '';
    
    try {
      final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
      return htmlString
          .replaceAll(regex, '')
          .replaceAll('&nbsp;', ' ')
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&quot;', '"')
          .replaceAll('&#39;', "'")
          .trim();
    } catch (e) {
      return htmlString;
    }
  }
}

