#include "process.h"
extern int fork();
extern void wait();
extern int exit();

char str[80] = "9djsajd128dw9i39ie93i84oiew98kdkd";
int ex;
void main()
{
    int pid=0;
    int i;
    print("The string is: ");
    print(str);
    print("\r\n");
    pid = fork();        /* 封装好的函数 */ 
    if (pid == -1)
    {
        print("error in fork!");
        exit(-1);
    }
   
    if (pid)            /* fork返回的pid是子进程的id */
    {
        int l = 0;
        print("Father process:     This is the father process.\r\n");
        print("Father process:     My child process's ID is: ");
        printnumber(pid);
        print("\r\n");
        wait(); 		/* 封装好的函数 */ 
        print("Father process: The numbers of letters in string is: ");
        for (i=0; str[i]; ++i)
			if((str[i]>='A'&&str[i]<='Z')||(str[i]>='a'&&str[i]<='z'))
				l++;
		printnumber(l);
        print("\n\r");
        delay();
        exit(0);
    }
    
    else               /* 父进程也就是主进程收到的pid为0 */
    {
		int letterNr = 0;
        print("Subprocess:      This is the child process.\r\n");
        for (i=0; str[i]; ++i)
			if((str[i]>='A'&&str[i]<='Z')||(str[i]>='a'&&str[i]<='z'))
				letterNr++;
        print("Subprocess:      The result calculated by child process: ");
        printnumber(letterNr);
        print("\r\n");
        exit(0);
    }
}