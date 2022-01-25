#include <stdio.h>


int main(){
	int choice = 0;
	while(choice != 4){
		printf("Enter a number to run a program : \n1 - Show Primes \n2 - Factorize\n3 - BubbleSort\n4 - Exit");
		scanf("%d",&choice);
		switch(choice){
			case 1:
				printf("Show Primes\n");
				break;
			case 2:
				printf("Factorize\n");
				break;
			case 3:
				printf("BubbleSort\n");
				break;
			case 4:
				printf("Exited \n");
				break;
			default:
				printf("You've entered wrong choice !\n");
				break;

		}
	}

	return 0;
}