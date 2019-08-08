extern void cls();							    /* 清屏 */
extern void printchar(char ch, int pos);	    /* 在指定位置输出字符 */
extern void showchar(char phar);			    /* 输出字符 */
extern void getChar();							/* 输入字符 */
extern void progInfo();							/* 读程序信息 */
extern void loadp(int index);					/* 加载程序 */
extern void setMyInt(); 
extern void resetInt();
extern void shutDown();
void prints(char const *Messeage);				/* 输出字符串 */
int strlen(char const *Messeage);				/* 计算字符串长度 */
int strcmp(char const *m1,char const *m2);		/* 比较字符串 */
void helpList();								/* 输出提示信息 */
void getinfo();									/* 将程序信息输入到结构体存储 */
void listshow();								/* l指令，显示程序信息 */							
void runprog(int index);						/* 运行程序n */
void readcmd();									/* 读指令 */
void MyCmd();									/* 运行指令 */
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

/*  void print_next_line(char const* Messeage){
	prints(Messeage);
	prints("\n\r");					/* ////!!!!!!!!!!!!!! 
} */

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

void helpList(){
	prints("Command help:\n\r");
	prints("-l: to get some help imformation.\n\r");
	prints("-r n: (n is the index of user program.) to run the user program with index 'n'.\n\r");
	prints("    For example: input \"r 1 3\" to run user program1 and then program3.\n\r");
	prints("-h: to get some help imformation.\n\r");
	prints("-s: shut down my OS.\n\r");
	prints("-c: clear screen.\n\r");
	prints("-q: quit.\n\r");
	prints("-init.cmd: to run the batch commmand in the disk.\n\r");
}

void runprog(int index){
	cls();
	loadp(index);
	cls();
}

void readcmd(){
	while(1){
		getChar();
		if(save == 8){
			char k = ' ';
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
	char *run = "r";
	char *clear = "c";
	char *shutdown = "s";
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
        if(strcmp(recv,help) == 1 ||strcmp(recv,quit) == 1 || strcmp(recv,list) == 1 || strcmp(recv,run) == 1 || strcmp(recv,clear) == 1 || recv[0] == 'r' || strcmp(recv,batch) == 1 || strcmp(recv,shutdown) == 1){
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
				
			else if(recv[0] == 'r'){
				int i = 1;
				int len0 = 0;
				len0 = strlen(recv);
				
				setMyInt();
				
				if(strlen(recv)==1){
					prints("Invalid input.\n\r");
					continue;
				}
				
				for(i = 1; i < len0; i++){
					int index_of_prog = recv[i]-'0';
					if(recv[i]==32) continue;
					if(index_of_prog > 0 && index_of_prog < 7){	/*只有6个程序*/
						runprog(index_of_prog); 
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
				
			else if(strcmp(recv,"init.cmd") == 1){
				
				int i = 0;
				int len0 = strlen(batchcmd);
				setMyInt();
				for(i = 1; i < len0; i++){
					int index_of_prog = batchcmd[i]-'0';
					if(batchcmd[i]==32) continue;
					if(index_of_prog > 0 && index_of_prog < 5){	/*只有4个程序*/
						runprog(index_of_prog); 
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
	helpList();
	MyCmd();

}

