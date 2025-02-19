#define VIDMEM 0xb8000

typedef unsigned short u16;

void screen_clear(unsigned char color)
{
	for(int i=0;i<80*25;i++)
		((u16*)VIDMEM)[i] = ' '|color<<8;
}

void screen_write(const char* str, unsigned char color)
{
	int i=0;
	while(str[i]!='\0')
		((u16*)VIDMEM)[i++] = str[i]|color<<8;
}

void kmain(void)
{
	screen_clear(0x0f);
	screen_write("Hello World!\0",0x3f);
}
