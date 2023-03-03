/*
 * replace html dom to white space
 * push to html string, will return text without html element
 */

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