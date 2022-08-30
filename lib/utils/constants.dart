import 'package:flutter/material.dart';
import 'package:xterm/theme/terminal_theme.dart';

const Color darkBlue = Color.fromRGBO(17, 63, 134, 1);
const Color lightBlue = Color.fromRGBO(35, 147, 239, 1);

const defaultTheme = TerminalTheme(
  cursor: 0xffaeafad,
  selection: 0xffffff40,
  foreground: 0xffcccccc,
  background: 0xff1e1e1e,
  black: 0xff000000,
  red: 0xffcd3131,
  green: 0xff0dbc79,
  yellow: 0xffe5e510,
  blue: 0xff2472c8,
  magenta: 0xffbc3fbc,
  cyan: 0xff11a8cd,
  white: 0xffe5e5e5,
  brightBlack: 0xff666666,
  brightRed: 0xfff14c4c,
  brightGreen: 0xff23d18b,
  brightYellow: 0xfff5f543,
  brightBlue: 0xff3b8eea,
  brightMagenta: 0xffd670d6,
  brightCyan: 0xff29b8db,
  brightWhite: 0xffffffff,
  searchHitBackgroundCurrent: 0xffffffff,
  searchHitBackground: 0xffffffff,
  searchHitForeground: 0xffffffff,
);