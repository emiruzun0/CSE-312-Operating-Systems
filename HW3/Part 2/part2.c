#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <math.h>
#include <unistd.h>
#include <sys/time.h>
#include <pthread.h>




struct tableInformations{  //The page table holds these informations.
	int isUsedRecent;
	int referencedBit;
	int modifiedBit;
	int present;
    int pageNum;
};
 struct printInformations{	//Each program(fill,quick etc) holds these informations. 
 	int numOfRead;		//These informations is in homework pdf. 
 	int numOfWrite;
 	int numOfPageMisses;
 	int numOfPageReplacements;
 	int numOfDiskPageWrites;
 	int numOfDiskPageReads;
 };


int thread_no[2] = {0,0};
int frameSize;	//First command line argument
int numPhysical;	//Second command line argument
int numVirtual;	//Third command line argument
char pageReplacement[10];	//Fourth command line argument
char tableType[10];	//Fifth command line argument
int pageTablePrint;	//Sixth command line argument
char diskFileName[50];	//Seventh command line argument
int physicalMemorySize;		//frameSize multiplied by physical num
int virtualMemorySize;		//frameSize multiplied by virtual num
struct tableInformations* phySicalPages;	//Create a physical pages informations dynamically
struct tableInformations* virtualPages;		//Create a virtual pages informations dynamically
struct printInformations printsInfo[6]; //For fill,quick bubble,merge,linear,binary
int* virtualMemory;		//Virtual page table array dynamically
int* physicalMemory;	//Physical page table array dynamically
pthread_t sortThreads[2];   //2 threads for bubble and quick sort
pthread_t threadForMerge;
pthread_t searchThreads[2];  //2 threads for linear and binary search;
pthread_mutex_t mutex;		//Mutex for enter and leave from critical region
int SC[2]= {0,0};			//Second chance array. First is for bubble and second for quick








//It search the memories for number x with linear format. 
int linearSearch(int x)
{
    int i;
    for (i = 0; i < physicalMemorySize; i++){
        printsInfo[4].numOfRead++;
        if (physicalMemory[i] == x)
            return i;
    }
    for (i = 0; i < virtualMemorySize; i++){
        printsInfo[4].numOfRead++;
        printsInfo[4].numOfDiskPageReads++;
        if (virtualMemory[i] == x)
            return i;
    }
        
    return -1;
}


//It seearch the memory for number x with binary format
int binarySearch( int l, int r, int x)
{
    if (r >= l) {
        int mid = l + (r - l) / 2;
 
        printsInfo[5].numOfRead++;
        if (virtualMemory[mid] == x)
            return mid;
        printsInfo[5].numOfRead++;
        if (virtualMemory[mid] > x)
            return binarySearch(l, mid - 1, x);
        return binarySearch(mid + 1, r, x);
    }
    return -1;
}

//It checks the index of phyisal memory array if its value is in physical memory or not.
int checkInPhysicalMemory(unsigned int index){
    int temp = -1;
    int numPage = (int) virtualMemory[index]/ (int)frameSize;
    for(int i = 0;i<numPhysical;++i){
        if(phySicalPages[i].pageNum == numPage){
            temp = i;
            break;
        }
    }
    if(temp != -1){
        int tempIndex = temp*frameSize;
        int finding = virtualMemory[index]%frameSize;
        return physicalMemory[tempIndex+finding];
    }
    return -1;

}


//Change the physical and virtual page array's pageNum index with the given page parameter
void FindPage(int page, int pageNum){
    phySicalPages[pageNum].pageNum = page;
    phySicalPages[pageNum].present = 1;
    phySicalPages[pageNum].isUsedRecent = 1;
    phySicalPages[pageNum].referencedBit = 1;
    phySicalPages[pageNum].modifiedBit = 0;
    virtualPages[pageNum].pageNum = page;
    virtualPages[pageNum].present = 1;
    virtualPages[pageNum].isUsedRecent = 1;
    virtualPages[pageNum].referencedBit = 1;
    virtualPages[pageNum].modifiedBit = 0;
}

void SecondChance(int page){
    if(strcmp(tableType,"regular") == 0){
        while(phySicalPages[SC[0]].referencedBit != 0){
            phySicalPages[SC[0]].referencedBit = 0 ;
            SC[0]++;
            SC[0] = SC[0]%numPhysical;
        }
        FindPage(page,SC[0]);
        SC[0]++;
        SC[0] = SC[0]%numPhysical;
    }
    else if(strcmp(tableType,"inverted") == 0){
        SC[1] = numPhysical;
        while(phySicalPages[SC[1]].referencedBit != 0){
            phySicalPages[SC[1]].referencedBit = 0 ;
            SC[1]--;
            if(SC[1] < 1) SC[1] += numPhysical;
        }
        FindPage(page,SC[1]);
        SC[1]--;
        if(SC[1] < 1) SC[1] += numPhysical;
    }

}



//Get function gives the value of virtual memory's indexth element. Also it 
//checks the name of the given parameter. 
int get(unsigned int index, char * tName){
	int value ;
	pthread_mutex_lock(&mutex);		//Critical region starts
	if(strcmp(tName,"quick") == 0){
        if(checkInPhysicalMemory(index) == -1){
            int page = (int) virtualMemory[index]/ (int)frameSize;
            printsInfo[1].numOfPageReplacements++;
            printsInfo[1].numOfPageMisses++;
            printsInfo[1].numOfDiskPageReads++;
            printsInfo[1].numOfDiskPageWrites++;
            printsInfo[1].numOfRead += 2;
            if(strcmp(pageReplacement,"SC") == 0){
                SecondChance(page);
            }
            else if(strcmp(pageReplacement,"LRU")){
                //I didn't do 
            }
            else if(strcmp(pageReplacement,"WSClock")){
                //I didn't do 
            }
        }
		else printsInfo[1].numOfRead++;
		value = virtualMemory[index];
	}
	else if(strcmp(tName,"bubble") == 0){
        if(checkInPhysicalMemory(index) == -1){
            int page = (int) virtualMemory[index]/ (int)frameSize;
            printsInfo[2].numOfPageReplacements++;
            printsInfo[2].numOfPageMisses++;
            printsInfo[2].numOfDiskPageReads++;
            printsInfo[2].numOfDiskPageWrites++;
            printsInfo[2].numOfRead += 2;
            if(strcmp(pageReplacement,"SC") == 0){
                SecondChance(page);
            }
            else if(strcmp(pageReplacement,"LRU")){
                //I didn't do 
            }
            else if(strcmp(pageReplacement,"WSClock")){
                //I didn't do 
            }
        }
        else printsInfo[2].numOfRead++;
		value = virtualMemory[index];
	} 
	else if(strcmp(tName,"merge") == 0){
		printsInfo[3].numOfRead++;
		value = virtualMemory[index];
	}
	pthread_mutex_unlock(&mutex);		//Critical region finishes
	return value;
}

//It turns the n^2 times which n is finish number. 
//If the small index's value is bigger than large index's value, then swap
void bubbleSort(int* virtualMemory,int start, int finish){	
	for(int i = start;i < finish -1 ; ++i){
		for(int j = start; j < finish-i -1 ; ++j){
			if(get(j,"bubble") > get(j+1,"bubble")){
				int t = virtualMemory[j];
				virtualMemory[j] = virtualMemory[j+1];
				virtualMemory[j+1] = t;
				printsInfo[2].numOfWrite += 2;
			}
		}
	}
}



//This is the partition function for quick sort
int partition (int* virtualMemory, int left, int right){ 
    int middle_pivot = get(right,"quick"); 
    int i = (left - 1),j;
    int t; 
  
    for (j = left; j <= right- 1; j++){ 
        if (get(j,"quick") < middle_pivot){ 	//Get value from quick
            i++; 
            t=virtualMemory[i];
            virtualMemory[i]=virtualMemory[j];
            virtualMemory[j]=t;
            printsInfo[1].numOfWrite+=2;
        } 
    }
    t=virtualMemory[i+1];
    virtualMemory[i+1]=virtualMemory[right];
    virtualMemory[right]=t;
    printsInfo[1].numOfWrite+=2;
    return (i + 1); 
}


//Quick sort function
void quickSort(int* virtualMemory, int start, int finish){ 
    if (start < finish){ 
        int pivot = partition(virtualMemory, start, finish); 
        quickSort(virtualMemory, start, pivot-1); 
        quickSort(virtualMemory, pivot+1, finish); 
    } 
}


//Thread void* function for sorting threads
 void* sortThread(void* arg){
    int index=*((int*)arg);
    if(index==0){
        bubbleSort(virtualMemory,0,virtualMemorySize/2);
    }
    else if(index==1){
        quickSort(virtualMemory,virtualMemorySize/2,virtualMemorySize);
    }
    return NULL;
}


//Thread void* function for searching threads
void* searchThread(void* arg){
    int index=*((int*)arg);
    if(index==0){
        linearSearch(-2);
        linearSearch(-334);
        linearSearch(-42);
        linearSearch(-545);
        linearSearch(-423);
    }
    else if(index==1){
        binarySearch(0, virtualMemorySize - 1, -25);
        binarySearch(0, virtualMemorySize - 1, -453);
        binarySearch(0, virtualMemorySize - 1, -2425);
        binarySearch(0, virtualMemorySize - 1, -748);
        binarySearch(0, virtualMemorySize - 1, -453);
    }
    return NULL;
}



//Merge function for merge 2 sorting algorithm arrays (quick and bubble)
void merge(int* virtualMemory, int start, int middle, int finish){ 
    int start2 = middle + 1; 
    if (get(middle,"merge")<=get(start2,"merge")) { 
        return; 
    } 
    while (start<=middle && start2<=finish) { 
        if (get(start,"merge") <= get(start2,"merge")) { 
            start++; 
        } 
        else { 
            int value = virtualMemory[start2]; 
            int index = start2; 
            while (index != start) { 
                virtualMemory[index] = virtualMemory[index-1]; 
                index--; 
                ++printsInfo[3].numOfWrite;
            } 
            virtualMemory[start] = value; 
            ++printsInfo[3].numOfWrite;
            start++; 
            middle++; 
            start2++; 
        } 
    } 
}

//Merge sort helper
void mergeSort(int* virtualMemory, int start, int finish){ 
    if (start < finish) { 
        int middle = start + (finish - start) / 2; 
        mergeSort(virtualMemory, start, middle); 
        mergeSort(virtualMemory, middle + 1, finish); 
        merge(virtualMemory, start, middle, finish); 
    } 
}


//Thread void* function for merge thread
void* mergeThread(){
	mergeSort(virtualMemory,0,virtualMemorySize);
	return NULL;
}


//Set function checks the tName
//If it is fill, then fills the file which is given from command line
//Also it fills the physical and virtual memory page struct variables.  
void set(unsigned int index, int value, char * tName){
	srand(1000);
	if(strcmp(tName,"fill") == 0){
		FILE* file = fopen(diskFileName,"w+");
		if(file == NULL){
			fprintf(stderr, "The file was not opened ! \n" );
			exit(EXIT_FAILURE);
		}
		for(int i =index ;i<physicalMemorySize;++i){
			fprintf(file, "%.10d\n",physicalMemory[i] );
			printsInfo[0].numOfDiskPageWrites++;
		}
		for(int i = physicalMemorySize;i<virtualMemorySize;++i){
			fprintf(file, "%.10d\n",virtualMemory[i] );
			printsInfo[0].numOfDiskPageWrites++;
		}
		fclose(file);
		for(int i =index;i<numPhysical;++i){
			phySicalPages[i].isUsedRecent = value;
			phySicalPages[i].referencedBit = value;
			phySicalPages[i].modifiedBit = value;
            phySicalPages[i].pageNum = i;
			phySicalPages[i].present = value;
		}
		for(int i =index;i<numVirtual;++i){
			virtualPages[i].isUsedRecent = value;
			virtualPages[i].referencedBit = value;
			virtualPages[i].modifiedBit = value;
            phySicalPages[i].pageNum = i;
			virtualPages[i].present = value;
		}
	}
}


//It fills the memories with rand function.
void fillArrays(){
	srand(1000);
    for (int i = 0; i < virtualMemorySize; ++i) {
        virtualMemory[i] = rand();
        printsInfo[0].numOfWrite++;
    }
    for(int i = 0;i< physicalMemorySize;++i){
    	physicalMemory[i] = rand();
    	printsInfo[0].numOfWrite++;
    }
    set(0,0,"fill");
}



//This is the print function for informations.
void printsForInfo(){
    int i;
    for(i=0;i<6;++i){
        if(i==0){
            printf("----------------------\nFill\n");
        }
        else if(i==1){
            printf("----------------------\nQuick\n");
        }
        else if(i==2){
            printf("----------------------\nBubble\n");
        }
        else if(i==3){
            printf("----------------------\nMerge\n");
        }
        else if(i==4){
            printf("----------------------\nLinear\n");
        }
        else if(i==5){
            printf("----------------------\nBinary\n");
        }
        printf("Number of reads:%d\n",printsInfo[i].numOfRead);
        printf("Number of writes:%d\n",printsInfo[i].numOfWrite);
        printf("Number of page misses:%d\n",printsInfo[i].numOfPageMisses);
        printf("Number of page replacements:%d\n",printsInfo[i].numOfPageReplacements);
        printf("Number of disk writes:%d\n",printsInfo[i].numOfDiskPageWrites);
        printf("Number of disk reads:%d\n",printsInfo[i].numOfDiskPageReads);

    }

}



//Takes the argument from command line and checks they are valid or not.
int main(int argc, char *argv[]){
	//Checks argument count.
	if(argc!=8){
        fprintf(stderr,"The argument count must be 8 !\nThe usage is like that: \n./sortArrays frameSize numPhysical numVirtual pageReplacement tableType pageTablePrintInt diskFileName.dat");
        exit(EXIT_FAILURE);
    }
    //Takes first index to the frameSize.
    frameSize = atoi(argv[1]);
    //If the frame size is smaller than 0, then exit.
    if(frameSize <0 ){
    	fprintf(stderr, "Framse size must be bigger than 0 !\n" );
    	exit(EXIT_FAILURE);
    }
    //Takes second index to the number of physical page frames.
    numPhysical=atoi(argv[2]);
    //If the numPhysical is smaller than 0, then exit.
    if(numPhysical <0 ){
    	fprintf(stderr, "numPhysical must be bigger than 0 !\n" );
    	exit(EXIT_FAILURE);
    }
    //Takes the third index to the number of virtual page frames
    numVirtual=atoi(argv[3]);
    //If the numVirtual is smaller than, then exit.
    if(numVirtual <0 ){
    	fprintf(stderr, "numVirtual must be bigger than 0 !\n" );
    	exit(EXIT_FAILURE);
    }
    //Takes page replacement algorithm from the fourth index of command line
    strcpy(pageReplacement,argv[4]);
    //Takes the table type from the fifth index.
    strcpy(tableType,argv[5]);
    //Takes the interval of memory accesses to the pageTablePrint from the sixth index.
    pageTablePrint =atoi(argv[6]);
    //If the interval is smaller than 0, then exit.
    if(pageTablePrint <0 ){
    	fprintf(stderr, "pageTablePrint must be bigger than 0 !\n" );
    	exit(EXIT_FAILURE);
    }
    //Takes the diskFileName
    strcpy(diskFileName,argv[7]);
    //If the numPhysical is greater than numVirtual, that is also error so exit.
    if(numPhysical > numVirtual){
        fprintf(stderr,"numVirtual must be greater than numPhysical ! ");
        exit(EXIT_FAILURE);
    }

    //Takes 2 to the power of frameSize to find actual frameSize.
    frameSize = pow(2,frameSize);
    //Takes 2 to the power of numPhysical to find actual physical number of page frames
	numPhysical = pow(2,numPhysical);
    //Takes 2 to the power of numPhysical to find actual physical number of page frames	
	numVirtual = pow(2,numVirtual);
	//Finds physical memory size
	physicalMemorySize = frameSize * numPhysical;
	//Fins virtual memory size
	virtualMemorySize = frameSize * numVirtual;

	printf("Frame Size : %d\n",frameSize );
	printf("Physical Memory Size : %d\n",physicalMemorySize );
	printf("Virtual Memory Size : %d\n",virtualMemorySize );


	//Create dynamic arrays for memories and pages according to the values.
	virtualMemory = (int*)malloc(virtualMemorySize * sizeof(int));
	physicalMemory = (int*)malloc(physicalMemorySize * sizeof(int));
	phySicalPages = (struct tableInformations*)malloc(numPhysical * sizeof(struct tableInformations));
	virtualPages = (struct tableInformations*)malloc(numVirtual * sizeof(struct tableInformations));
	for(int i=0;i<6;++i){
		printsInfo[i].numOfRead=0;
		printsInfo[i].numOfWrite=0;
		printsInfo[i].numOfPageMisses=0;
		printsInfo[i].numOfPageReplacements=0;
		printsInfo[i].numOfDiskPageReads=0;
		printsInfo[i].numOfDiskPageWrites=0;
	}


	//Fills the memories
	fillArrays();


	//Create 2 thread for sortings
	for (int i = 0; i < 2; ++i) {
		thread_no[i] = i;
        if (pthread_create (&sortThreads[i], NULL, sortThread, &thread_no[i]) != 0) { 
            fprintf(stderr, "Thread was not created\n" );
            exit (EXIT_FAILURE);
        }
    }
    //Thread join for 2 sorting thread
    for (int i = 0; i < 2; ++i){
        if (pthread_join (sortThreads[i], NULL) == -1) { 
   			fprintf(stderr, "Error in thread join\n" );
            exit (EXIT_FAILURE);
        }
    }

    //Create thread for merge
    if(pthread_create (&threadForMerge, NULL, mergeThread, &virtualMemorySize) != 0){
    	fprintf(stderr, "Thread was not created\n" );
   		exit(EXIT_FAILURE);
    }
    //Thread joing for merge
   	if(pthread_join(threadForMerge,NULL) == -1){
   		fprintf(stderr, "Error in thread join\n" );
   		exit(EXIT_FAILURE);
   	}

   	//Create 2 thread for searching algorithms
    for (int i = 0; i < 2; ++i) {
        thread_no[i] = i;
        if (pthread_create (&searchThreads[i], NULL, searchThread, &thread_no[i]) != 0) { 
            fprintf(stderr, "Thread was not created\n" );
            exit (EXIT_FAILURE);
        }
    }

    //Thread join for 2 searching thread.
    for (int i = 0; i < 2; ++i){
        if (pthread_join (searchThreads[i], NULL) == -1) { 
   			fprintf(stderr, "Error in thread join\n" );
            exit (EXIT_FAILURE);
        }
    }
    //Prints the informations.
   	printsForInfo();


   	//Free them
    free(virtualMemory);
    free(physicalMemory);
    free(phySicalPages);
    free(virtualPages);

    return 0;
}