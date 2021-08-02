#.PHONY: clean echo if

target: require1 require2
	# $$^ means requires, in this case is require1 and require2
	cat $^ > target
	# $$@ means target
	cat $@
	@#this is comment

gen_require:
	echo require1 > require1
	echo require2 ... > require2

clean_echo: clean echo

clean:
	# add - before command, or using 'make -k/--keep-going/-i/--ignore-errors' has the same effect
	-rm require1 require2
	# this is comment
echo:
	echo make

include included

js_file := jquery.js node.js
min: $(js_file:.js=.min.js)
	cat $^

num1 = 1
num2 = 2
concat := $(num1)$(num2)
#concat = $(num1)$(num2)
num2 = 20
equal:
	@echo concat $(num1) and $(num2) is $(concat) using :=

result =
#there must is seperator between 'ifeq' and '('
#ifeq ($(num1), 1)
ifeq '$(num1)' '1'
	result = $(num1)
else
	result = $(num2)
endif
if:
	echo $(result)

#function
subst:
	@echo hello after subst o with O is [$(subst o,O,hello)]
patsubst:
	@echo [hello hello] after patsubst %O with %o is [$(patsubst %o,%O,hello hello)]
empty :=
space := $(empty) $(empty)
#space := ' ' #this does not work
word = $(space)make$(space)
strip:
	@echo [$(word)] after strip is [$(strip $(word))]
sources := a.c b.c a.o b.o a.s b.s
filter:
	@echo [$(sources)] after filter with [%.c %.o] is [$(filter %.c %.o,$(sources))]
filter-out:
	@echo [$(sources)] after filter-out with [%.c %.o] is [$(filter-out %.c %.o,$(sources))]
sentence := hello world and make
sort:
	@echo [$(sentence)] after sort is [$(sort $(sentence))]
n := 3
word:
	@echo the $(n)th word of [$(sentence)] is [$(word $(n),hello world and make)]
from := 3
to := 4
wordlist:
	@echo from the $(from)th to $(to)th word of [$(sentence)] is [$(wordlist 3,4,hello world and make)]
words:
	@echo the word count of [$(sentence)] is [$(words hello world and make)]
firstword:
	@echo firstword of [$(sentence)] is $(firstword hello world and make)
file := src/a.c
dir:
	@echo dir of $(file) is $(dir $(file))
notdir:
	@echo file of $(file) is $(notdir $(file))
suffix:
	@echo suffix of [$(sources)] is [$(suffix $(sources))]
basename:
	@echo basename of [$(file)] is [$(basename $(file))]
foreach:
	@echo after foreach of [$(sources)] whith .bak is [$(foreach n,$(sources),$(n).bak)]
