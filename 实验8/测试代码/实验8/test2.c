#include "process2.h"
extern void print();
extern void printchar();
extern void delay();

extern int getsem();
extern void p();
extern void v();

extern int fork();
extern void wait();
extern int exit();

main() {
   int s, cid;
   s = getsem(0);							/* 初始化信号量 */
   print("\r\nUser: forking...\r\n");
   cid = fork();							/* 创建子进程1 */
   if(cid) {
	   while(1) {
		   p(s);							/* 同时有水果和祝福时吃水果 */
		   p(s);
		   print("Father enjoys the fruit.\r\n");
		}
   }
   else {									/* 子进程1，送祝福 */
	   print("User: forking again...\r\n");  	
	   cid = fork();						/* 创建子进程2 */
	   if(cid) {
		   while(1) {
			   print("Father will live forever!\r\n") ;
			   v(s);
			   delay();
		   }
	   }
	   else {								/* 子进程2，送水果 */	
		   while(1) {
			   print("Put one fruit onto the plate.\r\n") ;
			   v(s);
			   delay();
		   }
	   }
   }
}

