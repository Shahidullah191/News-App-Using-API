import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String baseUrl = "https://newsapi.org/v2/everything?";

String token = "0dec5b9f472c4803ab863d837d970a36";

myStyle(double fs, Color clr, [FontWeight? fw]){
  return GoogleFonts.nunito(fontSize: fs, color: clr, fontWeight: fw);
}