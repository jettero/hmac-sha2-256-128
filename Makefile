# vi:ts=4:

mod_dir := /lib/modules/$(shell uname -r)
target_mod := $(mod_dir)/kernel/net/xfrm/xfrm_algo.ko
obj-m += xfrm_algo.o

all:
	+ make -C $(mod_dir)/build M=$(PWD) modules

clean:
	+ make -C $(mod_dir)/build M=$(PWD) clean
	git clean -dfx

install: all
	sudo cp -a $(target_mod) $(target_mod)-oops-$$(date +%Y%m%d%H%M%S)
	sudo install -o 0 -g 0 -m 0644 xfrm_algo.ko $(target_mod)
