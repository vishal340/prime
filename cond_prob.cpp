#include<iostream>
#include<fstream>
#include<cmath>
#include <vector>

void func(int* prime,int* mod,int number,int x,int iter){
	long double prob=1.0;
	while(iter!=number){}
}
void func(int* prime,int* mod,int number,int x,int iter,std::vector<int>& space){
	long double prob=1.0;
	while(iter!=number){}
}

int main(int argc,char** argv){
    std::ifstream in(argv[1]);
    int number;
    in>>number;
    int* prime=new int[number];
    int* mod=new int[number];
    for(int i=0;i<number;i++){
        in>>prime[i];
        in>>mod[i];
    }
	 int x=atoi(argv[2]);
	 if(argc>3){
		 std::vector<int>space;
		 int t;
		 while(std::cin>>t)space.push_back(t);
	 }
	 delete[] prime;
	 delete[] mod;
    return 0;
}
