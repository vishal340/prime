#include<iostream>
#include<fstream>
#include<cmath>

using namespace std;

int main(int argc,char** argv){
	ifstream in(argv[1]);
	int n1,n2,t,count=0;
	in>>n1>>n2;
	while(in>>t){
		n1=n2;
		n2=t;
		int g=n2-n1;
		float d=log(n1);
		float threshold=d*d*atof(argv[2]);
		if(g>= threshold){
			cout<< n1 <<' '<<g<<' '<<threshold<<' '<<++count<<'\n';
		}
	}
	return 0;
}
