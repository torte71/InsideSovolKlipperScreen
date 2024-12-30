---
title: makerbase-byid.service files
layout: page
parent: Modifications by Sovol
---
# makerbase-byid.service files
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## /usr/lib/systemd/system/makerbase-byid.service
```
[Unit]
Description=get usb id
After=network.target
Wants=udev.target

[Install]
WantedBy=multi-user.target

[Service]
Type=oneshot
ExecStart=/root/get_id
```

## /root/get_id
Updates `serial:` from section `[mcu]` in `home/mks/printer_data/config/printer.cfg`
```
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <string.h>
#include <termios.h>

#include <iostream>
#include <sstream>
#include <fstream>
#include <vector>
#include <string>
#include <map>
#include <memory>

#define UART_DEVICE_PATH  "/dev/serial/by-id/"
#define KLIPPER_CFG_PATH  "/home/mks/printer_data/config/printer.cfg"

#define MAX_LINE	1024


#include<dirent.h>

char *getDirFileName(char *filedir, char *filename)
{
	DIR *dp;
	struct dirent *dirp;
	
	if((dp = opendir(filedir)) == NULL)
		printf("Can't open %s\n", filedir);
	
	
	if((dirp = readdir(dp)) != NULL)
	{
		while(strcmp(dirp->d_name,".")==0 || strcmp(dirp->d_name,"..")==0) ///current dir OR parrent dir
		{	
			if((dirp = readdir(dp)) == NULL)
				return NULL;
		}
		
		strcpy(filename, filedir);
		strcat(filename, dirp->d_name);
		printf(filename);
		printf("\n");
		return filename;
	}
	
	closedir(dp);
}

int main(int argc, char** argv) {
    FILE *fp;
	int find_node_flag = 0;
	int replace_flag = 0;
	char strLine[MAX_LINE] = {0};
	char fileName[500] = {0};
	
	if(access(UART_DEVICE_PATH, F_OK) == 0)
	{
		getDirFileName(UART_DEVICE_PATH, fileName);
		if ((fp = fopen(KLIPPER_CFG_PATH, "r+"))< 0)
			return -1;
		fseek( fp, 0, SEEK_SET );
		while (!feof(fp))									//循环读取每一行，直到文件尾
		{
			if(replace_flag)
				break;
			memset(strLine, 0, MAX_LINE);
			long offset = ftell(fp);
			fgets(strLine,MAX_LINE,fp);					    //将fp所指向的文件一行内容读到strLine缓冲区
			printf("offset:%d\n", offset);		   					//输出所读到的内容
			if(strstr(strLine, "[mcu]"))
			{
				find_node_flag = 1;
			}
			else if(strLine[0] == '[')
			{
				if((find_node_flag == 1) && (replace_flag == 0))
				{
					char save[1000][1024];
					fseek(fp, offset, SEEK_SET);
					int i = 0; // 清0, 记录后面共有多少行
					while ((fgets(save[i], 1024, fp))) { // 循环读取文件, 直到fgets返回NULL表示读完
						i++;
					}
					//fseek( fp, 0 - strlen(strLine), SEEK_CUR);
					fseek(fp, offset, SEEK_SET);
					
					
					
					fputs("serial:", fp);
					fputs(fileName, fp);
                    fputs("\n", fp);
					
					int j;

						for (j = 0; j < i; j++) { // 之前保存的数据, 依次往后面写
						fputs(save[j], fp);
					}
					replace_flag = 1;
				}
				find_node_flag = 0;
			}
			else if((find_node_flag == 1) && (strncmp(strLine, "serial:", strlen("serial:")) == 0))
			{
				char save[1000][1024];
				//fseek(fp, offset, SEEK_SET);
				int i = 0; // 清0, 记录后面共有多少行
				while ((fgets(save[i], 1024, fp))) { // 循环读取文件, 直到fgets返回NULL表示读完
					i++;
				}
				//fseek( fp, 0 - strlen(strLine), SEEK_CUR);
				fseek(fp, offset, SEEK_SET);
				
				
				
				fputs("serial:", fp);
				fputs(fileName, fp);
                fputs("\n", fp);
				
				int j;

					for (j = 0; j < i; j++) { // 之前保存的数据, 依次往后面写
					fputs(save[j], fp);
				}
				replace_flag = 1;
			}
			
		}
		fclose(fp);
		
	}

    return 0;
}
```

----
Back to [start](index.md)
