
#ifndef __RTSPAPI_H__
#define __RTSPAPI_H__ 


//extern int flashPageErase(unsigned int nvmAdru, unsigned int  nvmAdr);

//extern int flashPageRead(unsigned int nvmAdru, unsigned int nvmAdr,int *pageBufPtr);

//extern int flashPageModify(unsigned int row, unsigned int size,int *rowBuf, int *pageBufPtr);

//extern int flashPageWrite(unsigned int nvmAdru, unsigned int nvmAdr, int *pageBufPtr);

extern int flashPageErase(int nvmAdru,int  nvmAdr);

extern int flashPageRead(int nvmAdru,int nvmAdr, int *pageBufPtr);

extern int flashPageModify(int row, int size, int *rowBuf, int *pageBufPtr);

extern int flashPageWrite(int nvmAdru, int nvmAdr, int *pageBufPtr);

#endif

