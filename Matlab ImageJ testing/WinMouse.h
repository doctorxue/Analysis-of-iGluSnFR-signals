/* WinMouse.h
 * Replacement of user32.h if it's not available 
   see ismousedpressed.m 
   This file must be located at the same place as ismousedpressed */

short GetAsyncKeyState(
  int vKey
);