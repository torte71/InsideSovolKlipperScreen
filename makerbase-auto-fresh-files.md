---
title: makerbase-auto-fresh.service files
layout: page
parent: Modifications by Sovol
---
# makerbase-auto-fresh.service files
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## /usr/lib/systemd/system/makerbase-auto-fresh.service
```
[Unit]
Description=MKS-auto-refresh
After=network.target
Wants=udev.target

[Install]
WantedBy=multi-user.target

[Service]
Type=oneshot
ExecStart=/root/auto_refresh
```

## /root/auto_refresh.cpp
source code for "/root/auto_refresh" (no makefile)
```
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <string.h>
#include <dirent.h>

#define MAX_PATH_LEN 1024
#define MAX_CMD_LEN 2048

#define UPDATE_STATE_PATH	"/home/mks/.update_state"
#define UPDATE_IDLE	0
#define UPDATE_ING	1
#define MAX_COMMAND_LENGTH 100
void mark_update_state(int state)
{
	static int cur_state = UPDATE_IDLE;
	char command[100];  // 定义一个足够大的字符数组来存储完整的命令
	if(cur_state == state)
		return;
	if(state == UPDATE_IDLE)
	{
		snprintf(command, sizeof(command), "echo \"idle\" > %s", UPDATE_STATE_PATH);
	}
	else if(state == UPDATE_ING)
	{
		snprintf(command, sizeof(command), "echo \"updating\" > %s", UPDATE_STATE_PATH);
	}
	system(command);
	cur_state = state;
	system("sync");
    snprintf(command, MAX_COMMAND_LENGTH, "pgrep KlipperScreen > /dev/null");
    int result = system(command);
	if (result == 0) {
        printf("KlipperScreen is running, it will be restart...\n");
        snprintf(command, MAX_COMMAND_LENGTH, "systemctl restart KlipperScreen.service");
        system(command);
    }
}
int install_system_debs() {
    char path[MAX_PATH_LEN]; // ���·�����Ļ�����
    char cmd[MAX_CMD_LEN]; // �������Ļ�����
    int find_debs = 0;

    // ��·��
    DIR* dir = opendir("/root/system_deb/");
    if (dir == NULL) {
        printf("Failed to open directory.\n");
        return 0;
    }

    // ����Ŀ¼�е��ļ�
    struct dirent* dirent;
    while ((dirent = readdir(dir)) != NULL) {
        // ����ļ����� .deb ��β
        if (strcmp(dirent->d_name + strlen(dirent->d_name) - 4, ".deb") == 0) {
            mark_update_state(UPDATE_ING);
            // ��������·����
            snprintf(path, MAX_PATH_LEN, "/root/system_deb/%s", dirent->d_name);

            // ���찲װ����
            snprintf(cmd, MAX_CMD_LEN, "dpkg -i %s", path);

            // ִ�а�װ����
            int ret = system(cmd);
            if (ret != 0) {
                printf("Failed to install package %s.\n", path);
            } else {
                // ɾ����Ӧ��deb�ļ�
                remove(path);
            }
            find_debs = 1;
        }
    }

    // �ر�·��
    closedir(dir);
	if(find_debs)
		mark_update_state(UPDATE_IDLE);

    return find_debs;
}


int main(int argc, char** argv) {


    while(1)
    {
		sleep(2);
		
		if(install_system_debs())
		{
		  system("sync");
		  system("reboot");
		}
                if(access("/root/bootsplash.armbian", F_OK) == 0)
		{
			system("mv /root/bootsplash.armbian /usr/lib/firmware/ -f;update-initramfs -u");
			sleep(2);
			system("sync");
			system("reboot");
                        while(1)
			{	
				sleep(2);				
			}
		}
		
		if (access("/dev/sda", F_OK) == 0)
		{
			if (access("/dev/sda1", F_OK) == 0)
			{
				if (access("/home/mks/printer_data/gcodes/USB", F_OK) != 0)
				{
					system("/usr/bin/systemctl --no-block restart makerbase-automount@sda1.service");
				
				   continue;
				}
			}
				 
		}
		

		if(access("/home/mks/printer_data/gcodes/USB/armbian-update.deb", F_OK) == 0)
		{
			//find the update deb file
			if (access("/home/mks/printer_data/gcodes/USB/factory_mode", F_OK) == 0)
			{
				system("cp /home/mks/printer_data/gcodes/USB/armbian-update.deb /home/mks/armbian-update.deb -f");
			}
			else
			{
				system("mv /home/mks/printer_data/gcodes/USB/armbian-update.deb /home/mks/armbian-update.deb -f");
			}
		}
		
		if(access("/home/mks/armbian-update.deb", F_OK) == 0)
		{
			mark_update_state(UPDATE_ING);
			sleep(1);
			system("dpkg -i /home/mks/armbian-update.deb");			
			install_system_debs();
			mark_update_state(UPDATE_IDLE);
			system("sync");
			system("dpkg-deb --info /home/mks/armbian-update.deb | grep \"Version:\" > /home/mks/.DebVersion");
			system("rm -rf /home/mks/armbian-update.deb");
			system("reboot");
		}
   
    }
   
    return 0;
}
```

----
Back to [start](index.html)
