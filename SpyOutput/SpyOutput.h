#ifndef SPYOUTPUT_H
#define SPYOUTPUT_H
#include <iostream>
using namespace std;
class SpyOutput{
	int ctr,sum;
	ostream* spy;
public:
	int getCheckSum();
	int getCount();
	SpyOutput(ostream* a);
	~SpyOutput();
	SpyOutput & operator << (char  val);
	SpyOutput & operator << (char* val);
	SpyOutput & operator << (int   val);
	SpyOutput & operator << (double  val);
};

#endif    
