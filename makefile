# .PHONY: clean echo if

# default target when command 'make' assigned no target, if no defalut target and no assigned target, make will issue first target
# .DEFAULT_GOAL := te_include

my_target: require1 require2
	# $$^ means requires, in this case is require1 and require2
	cat $^ > my_target
	# $$@ means target
	cat $@

# include other makefile
include included

te_no_req:
	echo hello make
	# means that it's comment, 'make' will not issue it, but it will appear in output. @ means that it would not appear in output, but 'make' will issue it
	@ # this line would not appear in output, and 'make' will not issue it

gen_require:
	echo require1 > require1
	echo require2 ... > require2

clean:
	# add - before command, or using 'make -k/--keep-going/-i/--ignore-errors' has the same effect
	-rm require1 require2

# VPATH means that 'make' would search this path when file of prerequisites not exists in current dir
VPATH = src:headers

# source = *.c
# wildcard_target: $(source) baz.c baz.h
te_wildcard: $(wildcard *.c) baz.c baz.h
	cat $^

js_file := jquery.js node.js
min: $(js_file:.js=.min.js)
	# $$(XX:a=A) means $$(patsubst %a,%A,$$(XX))
	# in this case, indicate prerequisites is $$(patsubst %.js,%.min.js,$$(js_file))
	cat $^

num1 = 1
num2 = 2
concat1 := $(num1)$(num2)
concat2 = $(num1)$(num2)
num2 = 20
te_simple_recursive:
	@echo concat $(num1) and $(num2) is $(concat1) using :=
	@echo concat $(num1) and $(num2) is $(concat2) using =

result =
# there must is seperator between 'ifeq' and '('
ifeq ($(num1),1)
# ifeq ($(num1), 1)
# ifeq '$(num1)' '1'
# ifeq "$(num1)" '1'
# ifeq '$(num1)' "1"
# ifeq "$(num1)" "1"
	result = $(num1)
else
	result = $(num2)
endif
te_ifeq:
	echo $(result)

is_result_defined =
ifdef result
	is_result_defined = true
else
	is_result_defined = false
endif

ifndef result
	is_result_defined = false
else
	is_result_defined = true
endif
te_ifdef te_ifndef:
	@echo result is defined: $(is_result_defined)

var1 = foo
override var2 = bar
te_overriden_cli:
	# execute make te_overriden_cli var1=bar, finally var1 is bar
	# execute make te_overriden_cli var1='bar', finally var1 is bar
	@echo var1 is $(var1)
	# execute make te_overriden_cli -e var2=foo, finally var1 is bar
	# execute make te_overriden_cli -e var2='foo', finally var1 is bar
	@echo var2 is $(var2)

te_override:
	# execute make te_override var2=foo, but finally var2 is bar
	# execute make te_override var2='foo', but finally var2 is bar
	@echo var2 is $(var2)

# function
te_origin:
	@# https://www.gnu.org/savannah-checkouts/gnu/make/manual/make.html#Origin-Function
	@echo origin of num1 is $(origin num1)

te_flavor:
	@echo the flavor of concat1 is $(flavor concat1)
	@echo the flavor of concat2 is $(flavor concat2)

# function 'if': $(if <condition>,<then-part>,<else-part>)
# if result of <condition> is not empty, <then-part> as function's result, else <else-part> as function's result
none_null := hello
if_result := $(if $(none_null), exp_not_empty, exp_empty)
te_if:
	@echo $(if_result)

else_result := $(if $(null), exp_not_empty, exp_empty)
te_else:
	@echo $(else_result)

te_subst:
	@echo hello after subst o with O is [$(subst o,O,hello)]

te_patsubst:
	@echo [hello hello] after patsubst %l with %L is [$(patsubst %l,%L,hell hell)]

empty :=
space := $(empty) $(empty)
#space := ' ' #this does not work
word = $(space)make$(space)
te_strip:
	@echo [$(word)] after strip is [$(strip $(word))]

sources := a.c b.c a.o b.o a.s b.s
te_filter:
	@echo [$(sources)] after filter with [%.c %.o] is [$(filter %.c %.o,$(sources))]

te_filter-out:
	@echo [$(sources)] after filter-out with [%.c %.o] is [$(filter-out %.c %.o,$(sources))]

sentence := hello world and make
te_sort:
	@echo [$(sentence)] after sort is [$(sort $(sentence))]

n := 3
te_word:
	@echo the $(n)th word of [$(sentence)] is [$(word $(n),hello world and make)]

from := 3
to := 4
te_wordlist:
	@echo from the $(from)th to $(to)th word of [$(sentence)] is [$(wordlist 3,4,hello world and make)]

te_words:
	@echo the word count of [$(sentence)] is [$(words hello world and make)]

te_firstword:
	@echo firstword of [$(sentence)] is $(firstword hello world and make)

file := src/baz.c
te_dir:
	@echo dir of $(file) is $(dir $(file))

te_notdir:
	@echo file of $(file) is $(notdir $(file))

te_suffix:
	@echo suffix of [$(sources)] is [$(suffix $(sources))]

te_basename:
	@echo basename of [$(file)] is [$(basename $(file))]

te_realpath:
	@echo $(realpath foo.c)

te_abspath:
	@echo $(abspath foo.c)

te_join:
	@echo [111 222] and [aaa bbb ccc] is [$(join 111 222, aaa bbb ccc)] after join

te_foreach:
	@echo after foreach of [$(sources)] whith .bak is [$(foreach n,$(sources),$(n).bak)]

map_func = $(foreach a,$(2),$(call $(1),$(a)))
call_result = $(call map_func,origin,call_result map_func MAKE)
te_call:
	@echo $(call_result)

te_info:
	$(info found a info!)
	echo make
te_warn:
	$(warning found a warn info!)
	echo make
te_error:
	$(error found an error!)
	echo make

or1 =
or2 =
or3 = a
or4 = b
te_or:
	@echo $(or $(or1),$(or2),$(or3),$(or4))
	@echo $(or $(or1),$(or2),$(or4),$(or3))
te_and:
	@echo $(and $(or1),$(or2),$(or3))
	@echo $(and $(or3),$(or4))
	@echo $(and $(or4),$(or3))
te_intcmp:
	echo $(intcmp 9,9)
	echo $(intcmp num1,num2)
	echo $(intcmp or3,or4)
	echo $(intcmp or4,or3)

#ifeq ($(MAKECMDGOALS),)
#	include $(MAKECMDGOALS)
#t_MAKECMDGOALS:
#	@echo $(MAKECMDGOALS)
