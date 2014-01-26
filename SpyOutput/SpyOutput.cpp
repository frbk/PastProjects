#include "SpyOutput.h"
#include <sstream>
#include <string>
SpyOutput::SpyOutput(std::ostream* a){
	spy = a;
	ctr = 0;
	sun = 0;
}
SpyOutput::~SpyOutput(){}
SpyOutput & SpyOutput::operator << (char  val){
	stringstream ss;
	ss << val;
	string s;
	s = ss.str();
	*spy << s;
	for(unsigned int i=0;i < s.size();i++){
		sum +=s[i];
	}
	return *this;
}
SpyOutput & SpyOutput::operator << (char* val){
	stringstream ss;
	ss << val;
	string s;
	s = ss.str();
	*spy << s;
	for(unsigned int i=0;i < s.size();i++){
		sum +=s[i];
	}
	return *this;
}
SpyOutput & SpyOutput::operator << (int   val){
	stringstream ss;
	ss << val;
	string s;
	s = ss.str();
	*spy << s;
	for(unsigned int i=0;i < s.size();i++){
		sum +=s[i];
	}
	return *this;
}
SpyOutput & SpyOutput::operator << (int*  val){
	stringstream ss;
	ss << val;
	string s;
	s = ss.str();
	*spy << s;
	for(unsigned int i=0;i < s.size();i++){
		sum +=s[i];
	}
	return *this;
}
int SpyOutput::getCheckSum(){
	return sum;
}
int SpyOutput::getCount(){
	return ctr;
}