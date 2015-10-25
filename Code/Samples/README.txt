Foobar.c

clang foobar.c -o foobar_x86
# file foobar_x86 
./foobar_x86
otool -h foobar_x86
otool -tdv foobar_x86
Mach-O-View foobar_x86

clang -O3 foobar.c -o foobar_arm -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk -arch armv7

file foobar.o
otool -h foobar.o
otool -tdv foobar.o
Mach-O-View foobar.o
	-> Header
	-> _TEXT
	-> CSTRING
	
----------

Droid.m

clang droid.m -o droid_x86 -fobjc-arc -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk -Os -L /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/arc -arch x86_64

./droid_x86
file droid_x86
otool -tdv droid_x86
otool -tdv droid_x86 | wc -l

clang droid.m -o droid_arm -fobjc-arc -arch armv7 -miphoneos-version-min=6.0 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk -mthumb -Os -larclite_iphoneos -L /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/arc

./droid_arm
file droid_arm
otool -tdv droid_arm
otool -tdv droid_arm | wc -l
Mach-O-View
IDA
	-> Kommentare, Opcodes, Symbole, Methoden, Branches

----------

clang crypto.c -o crypto_x86
otool -tdv crypto_x86
clang crypto.c -o crypto_x86 -O1
otool -tdv crypto_x86

clang crypto.c -o crypto_arm -fobjc-arc -arch armv7 -miphoneos-version-min=6.0 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk -mthumb -larclite_iphoneos -L /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/arc -O1
otool -tdv crypto_arm

asm volatile("" : : "r"(&buf) : "memory");
-> volatile = nicht wegoptimieren
asm volatile (asm-template : output-operand-list : input-operand-list : clobber-list);

IDA