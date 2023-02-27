/// replace html dom to white space

import 'dart:core';

String removeHtmlTags(String htmlString) {
  RegExp exp = RegExp('<(.*?)>');
  Iterable<Match> matches = exp.allMatches(htmlString);
  List<String?> result = matches.map((match) => match.group(1)).toList();
  result.forEach((element) {
    htmlString = htmlString.replaceAll("<${element}>", ' ');
  });
  return htmlString;
}