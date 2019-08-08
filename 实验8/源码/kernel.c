#include"PCB.h"
extern void cls();							    /* 清屏 */
extern void printchar(char ch, int pos);	    /* 在指定位置输出字符 */
extern void showchar(char phar);			    /* 输出字符 */
extern void getChar();							/* 输入字符 */
extern void progInfo();							/* 读程序信息 */
extern void loadp(int seg,int begin_section);	/* 加载程序并运行 */
extern void setMyInt(); 
extern void resetInt();
extern void shutDown();
extern void justLoadp(int seg,int begin_section);	/*多进程加载程序，不运行*/
extern void run_test_of_7_or_8(int seg, int offset);

void prints(char const *Messeage);				/* 输出字符串 */
int strlen(char const *Messeage);				/* 计算字符串长度 */
int strcmp(char const *m1,char const *m2);		/* 比较字符串 */
void helpList();								/* 输出提示信息 */
void getinfo();									/* 将程序信息输入到结构体存储 */
void listshow();								/* l指令，显示程序信息 */							
void runprog(int index);						/* 运行程序n */
void readcmd();									/* 读指令 */
void MyCmd();									/* 运行指令 */
void load_multi_process(char *cmdp);				/* 多进程 */
void init_Pro(int flag);
void Delay0();
void run_test_program_of_7();
void run_test_program_of_8();
void printnumber(int number);


char *readdata;	
char save;
int index_of_str = 0;
char recv[10] = "";
char batchcmd[14] ="";
char const *CMDHead = "user $: ";

struct programs{
    char name[8];
    char pos[3];
    char size[2];
};

struct programs p[4];

void getinfo(){
	int j =0;
	int i =0;
	
	progInfo();
	
	for(j=0; j<4; j++){
		for(i=0;i<8;i++){
			p[j].name[i] = *readdata;
			readdata++;
		}
		p[j].name[7]='\0';
		
		p[j].pos[0] = *readdata;
		readdata++;
		p[j].pos[1] = *readdata;
		p[j].pos[2] = '\0';
		
		readdata+=3;
		p[j].size[0] = *readdata;
		p[j].size[1] = '\0';
		readdata+=4;
	}
	i = 0;
	while(readdata!=0&&i<14){
		batchcmd[i] = *readdata;
		readdata++;
		i++;
	}
	batchcmd[13]='\0';
}


void prints(char const *Messeage){/* //can follow the position of your input */
	while(*Messeage != '\0'){
		showchar(*Messeage);
		Messeage++;
	}
}


 int strlen(char const *Messeage){
	int i = 0;
	int count = 0;
	while(Messeage[i] != '\0'){
		i++;
		count++;
	}
	return count;
}


int strcmp(char const* m1,char const* m2){
	int i = 0;
	int len1 = strlen(m1);
	int len2 = strlen(m2);
	if(len1 != len2){
		return 0;
	}
	for( i = 0; i < len1; i++){
		if(m1[i] != m2[i]){
			return 0;
		}
	}
	return 1;
}

void listshow(){
	int i =0;
	for(i = 0; i < 4;i++){
		prints(p[i].name);
		prints("         ");
		prints(p[i].pos);
		prints("         ");
		prints(p[i].size);
		prints("\n\r");
	}
	prints("batch command:");
	prints(batchcmd);
	prints("\r\n");
}

void printnumber(int number)
{
    int i = 0;
	char temp[1000];
    while (number)
    {
        temp[i++] = number%10 + '0';
        number /= 10;
    }
    i -= 1;
    while (i >= 0)
        showchar(temp[i--]);
}


void helpList(){
	prints("Command help:\n\r");
	prints("-l: to get some help imformation.\n\r");
	prints("-r n: (n is the index of user program.) to run the user program with index 'n'.\n\r");
	prints("    For example: input \"r 1 3\" to run user program1 and then program3.\n\r");
	prints("-h: to get some help imformation.\n\r");
	prints("-p: to run multi-process program.\"p 12\" to run prog1 and prog2 at the same time.\n\r");
	prints("-t1: to run test program for lab7.\n\r");
	prints("-t2: to run test program for lab8.\n\r");
	prints("-s: shut down my OS.\n\r");
	prints("-c: clear screen.\n\r");
	prints("-q: quit.\n\r");
	prints("-init.cmd: to run the batch commmand in the disk.\n\r");
}

void runprog(int index){
	int run_programs_seg = index*0x1000;			/* 段地址 */
	int begin_section = index*2-1;					/* 起始扇区 */
	cls();
	justLoadp(run_programs_seg,begin_section);
	init(&pcb_list[1],run_programs_seg,0x100);		/* 只有1个程序 */
	pcb_list[1].Used = 1;
	cls();
}

 void load_multi_process(char* cmdp){				/*实验7修改*/
	int i = 0;
	int j = 0;
	int num_of_p = 0;				
	int len = strlen(cmdp);
	Program_Num = 0;								/* 在PCB.H中声明,可直接用，每次重置进程数目为0 */
	cls();
	if(len > 5){
		prints("Too much progroms.\r\n");			/* p+1234,输入时已过滤空格 */
		return;
	}
	
	for( i = 1 ; i < len; i++){						/* check input valid or not */
		if(cmdp[i]<'1'|| cmdp[i]>'4'){
			prints("Invalid input from load.\r\n");
			return;
		}
	}
	
	for( i = 1 ; i < len; i++){						/* load */
		int repeat = 0;
		for( j = i-1; j >0; j--){					/* 避免输入的指令重复 */
			if(cmdp[i]==cmdp[j]){
				repeat = 1;
			}
		}
		if(repeat==1) continue;
		
		if(cmdp[i] >='1' && cmdp[i] <='4' ){
			j = cmdp[i] - '0';
			justLoadp(Segment,j*2-1);	        	/* seg , begin_section */
			Segment += 0x1000;
			num_of_p++;								/* 进程数 */
			pcb_list[num_of_p].Used = 1;			/* 当前PCB标记为已用 */
		}
	}
	Program_Num = num_of_p;							/* 在外面一次性赋值，否则，当其++时 */
	cls();											/* 时钟中断就去执行其他程序了,导致其他程序没有被加载 */
	
} 

void init_Pro(int flag)
{
	Program_Num = 0;							/*	此时状态都是new */
	if(flag == 1)
		init(&pcb_list[0],0xA00,0x100);				/* 内核 段值，用时其实要乘16*/
	
	init(&pcb_list[1],0x1000,0x100);			/*64k 1000h*16*/
	init(&pcb_list[2],0x2000,0x100);
	init(&pcb_list[3],0x3000,0x100);
	init(&pcb_list[4],0x4000,0x100);
	init(&pcb_list[5],0x5000,0x100);
}

void Delay0()
{
	int i = 0;
	int j = 0;
	for( i=0;i<30000;i++ )
		for( j=0;j<20000;j++ )
		{
			j++;
			j--;
		}
}

void Delay1()
{
	int i = 0;
	int j = 0;
	for( i=0;i<10000;i++ )
		for( j=0;j<12000;j++ )
		{
			j++;
			j--;
		}
}

/* 实验7新增 */
void run_test_program_of_7(){
	run_test_of_7_or_8(Segment,6*2-1);
	Segment += 0x1000;
	Program_Num = 1;
	pcb_list[1].Used = 1;
}


/* 实验8新增 */
void run_test_program_of_8()
{
    run_test_of_7_or_8(Segment,7*2-1);
    Segment += 0x1000;
    Program_Num=1;
    pcb_list[1].Used = 1;
}



void readcmd(){
	while(1){
		getChar();
		if(save == 8){
			char k = ' ';
			if(strlen(recv)==0){
				continue;
			}
			index_of_str--;
			recv[index_of_str] = '\0';
			showchar(save);
			showchar(k);
			showchar(save);
			continue;
		}
		showchar(save);
        
		if(save == 32){			/*空格不考虑*/
            continue;				
        }

        if(save == 13){	/*回车命令输入完毕*/
			recv[index_of_str] = '\0';
			break;
	    }
        
		else{
            if(index_of_str < 10){
                recv[index_of_str] = save;
                index_of_str++;
            }
            else{		
				int p =0;
				prints("\r\nThe command is too long, please input again.\n\r");
				prints(CMDHead);
				index_of_str = 0;
				for( p = 0; p < 10; p++){
						recv[p] = '\0';
					}
                continue;
            }

            
        }
		
	}
	
}


void MyCmd(){
    char const *ByeByeMsg = "Bye~";
	char *help = "h";
    char *quit = "q";
    char *list = "l";
	char *clear = "c";
	char *shutdown = "s";
	char *test = "t";
	char *batch = "init.cmd";
	getinfo();
	
	while(1){
		int p = 0;
		index_of_str = 0;
		prints(CMDHead);
		for( p = 0; p < 10; p++){
			recv[p] = '\0';
		}
		readcmd();
        if( strcmp(recv,help) == 1 ||strcmp(recv,quit) == 1 || strcmp(recv,list) == 1 || strcmp(recv,clear) == 1 || recv[0] == 'r' || recv[0] == 'p' || strcmp(recv,batch) == 1 || strcmp(recv,shutdown) == 1 || recv[0]=='t'){
			prints("\r\n");
			if(strcmp(recv,help) == 1){							
				helpList();
				prints("\n\r");					
				continue;
			}
				
			else if( strcmp(recv,quit) == 1){					
				prints(ByeByeMsg);
				break;		
			}
			
				
			else if(strcmp(recv,list) == 1){	
				prints("\n\r");
				prints("fliename     shanqu    size\n\r");
				listshow();
				continue;
			}
			
			else if(recv[0] == 'p'){
				setMyInt();
				init_Pro(0);
				cls();
				load_multi_process(recv);
				Delay0();
				cls();
				resetInt();
				/*cls(); */
			}
			
			else if(recv[0] == 'r'){
				int i = 1;
				int len0 = 0;
				Program_Num = 0;				/* */
				len0 = strlen(recv);
				
				setMyInt();
				
				if(strlen(recv)==1){
					prints("Invalid input.\n\r");
					continue;
				}
				
				for(i = 1; i < len0; i++){
					int index_of_prog = recv[i]-'0';
					if(recv[i]==32) continue;
					init_Pro(0);
					if(index_of_prog > 0 && index_of_prog < 6){	/*只有5个程序可用*/
						runprog(index_of_prog);
						Program_Num = 1;				
						Delay0();
						cls();
					}
					else{
						prints("Invalid input.\n\r");
						break;
					} 
				}
				
				
				resetInt();
				prints("\n\r");
				helpList();
				
				continue;
			}
			
			else if(strcmp(recv,clear) == 1){
				cls();
				continue;
				}
				
			else if(strcmp(recv,shutdown) == 1){
				shutDown();
				}
				
			else if(recv[0] == 't'){		/* 实验7新增 */
				cls();
				setMyInt();
				if(recv[1] == '1')
					run_test_program_of_7();
				else if(recv[1] == '2')
					run_test_program_of_8();
				else{
					printf("Invalid input.\r\n");
				}
				resetInt();
				Delay0();
				cls();
			}
				
			else if(strcmp(recv,"init.cmd") == 1){
				int i = 0;
				int len0 = strlen(batchcmd);
				Program_Num = 0;				/* */
				setMyInt();
				for(i = 1; i < len0; i++){
					int index_of_prog = batchcmd[i]-'0';
					if(batchcmd[i]==32) continue;
					if(index_of_prog > 0 && index_of_prog < 5){	/*只有4个程序*/
						runprog(index_of_prog); 
						Program_Num = 1;
						Delay0();						/* +++++++++++*/
					}
					else{
						prints("Invalid input.\n\r");
						break;
					}
				}
				resetInt();
				Delay0();
				cls();
				prints("\n\r");
				helpList();
				continue;
				}
				
			else{
					prints("\n\rInvalid input.\n\r");
					continue;
				}
        }
		else {
			prints("\n\rInvalid input.\n\r");
			continue;
		}
		
}
}
void cmain(){
	
	cls();					 
    prints(" -------------------------------------------------------------------------\n\r");
    prints("|                              Welcome to YaoOS                           |\n\r");
    prints(" -------------------------------------------------------------------------\n\r\n\r");
	init_Pro(1);
	initsema();				/* 初始化实验8中要使用的信号量 */
	helpList();
	MyCmd();
}

