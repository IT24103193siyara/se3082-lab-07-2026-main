MPICC ?= mpicc
MPIRUN ?= mpirun
NP ?= 4
CFLAGS ?= -O2 -Wall -Wextra -std=c11

PROGRAMS = sum_bcast sum_scatter sum_gather sum_reduce sum_allreduce sum_scan

.PHONY: all run benchmark clean

all: $(PROGRAMS)

%: %.c
	$(MPICC) $(CFLAGS) -o $@ $<

run: all
	@set -e; for program in $(PROGRAMS); do \
		echo "== $$program ($(NP) processes) =="; \
		$(MPIRUN) -np $(NP) ./$$program; \
	done

benchmark: all
	@set -e; for processes in 2 4 8; do \
		for program in $(PROGRAMS); do \
			echo "== $$program ($$processes processes) =="; \
			$(MPIRUN) -np $$processes ./$$program; \
		done; \
	done

clean:
	rm -f $(PROGRAMS)
