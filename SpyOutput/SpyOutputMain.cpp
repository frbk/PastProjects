#include "SpyOutput.h"
#define endl  '\n'

int main(){
	double d1 = 12.3;
	int i1 	  = 45;
	SpyOutput spy(&cout);

	spy << "abc" << endl;
	spy << "d1=" << d1 << " i1=" << i1 << "z" << endl;
	cout << "count=" << spy.getCount() << endl;
	cout << "Check Sum=" << spy.getCheckSum() << endl;
	return 0;
}
