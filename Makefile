# vi:ts=4:

obj-m += xfrm_algo.o

all:
	+ make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	+ make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
	git clean -dfx
