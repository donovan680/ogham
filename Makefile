
ARCH = $(shell g++ -dumpmachine)

ifeq ($(findstring x86_64,$(ARCH)),x86_64)
CCTARGET = -m64
else
ifeq ($(findstring i686,$(ARCH)),i686)
CCTARGET = -m32
else
CCTARGET =
endif
endif

INCLUDE = -I"../libzed"
CCFLAGS = $(INCLUDE) -std=c++11 -g -W -Wall -Wextra -pedantic -fexceptions -O4 $(CCTARGET)

STATIC_LIB = $(LIBNAME).a
DLL = $(LIBNAME).dll

LFLAGS = -s -shared

ifeq ($(OS),Windows_NT)
CFLAGS = $(CCFLAGS) -shared
LFLAGS += -fPIC
RMOBJS = $(subst /,\,$(OBJS))
RM = del
DEFAULT=ogham.exe
else
CFLAGS = $(CCFLAGS) -fPIC
LFLAGS += -ldl
RM = rm -f
DEFAULT=ogham
endif

DLFLAGS_WIN = -L. -l$(LIBNAME)
DLFLAGS_NIX = -l $(LIBNAME)

default: $(DEFAULT)

ogham: ogham.o
	g++ $(DLFLAGS_NIX) -o $@ $^

ogham.exe: ogham.o
	g++ $(DLFLAGS_WIN) -o $@ $^

ogham.o: ogham.cpp
	g++ $(CCFLAGS) -o $@ -c $^

clean:
	$(RM) $(DEFAULT) *.o

.PHONY: default clean
