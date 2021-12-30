cd tools
pgsp -o ../src "am scr" 123456
move gmcode.bin ../bin/data/gmcode.bin

cd ../bin/
win32main.exe
pause