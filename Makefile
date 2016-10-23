# vi:ts=4:

MN := hmac-sha2-256-128
KO := $(MN).ko

obj-m += $(MN).o

all:
	+ make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
	file $(KO)
	modinfo $(KO)

clean:
	+ make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
