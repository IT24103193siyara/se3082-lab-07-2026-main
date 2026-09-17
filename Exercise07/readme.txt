
Exercise 7: Summary Comparison
==============================

| Program        | Collectives used                | Array storage                         | Root manual sum | Result location |
|----------------|---------------------------------|---------------------------------------|-----------------|-----------------|
| sum_bcast      | Bcast                           | Full array on every process           | Yes, while receiving | Root only |
| sum_scatter    | Scatter                         | Full array on root, chunk elsewhere   | Yes, while receiving | Root only |
| sum_gather     | Scatter, Gather                 | Full array on root, chunk elsewhere   | Yes, over gathered sums | Root only |
| sum_reduce     | Scatter, Reduce                 | Full array on root, chunk elsewhere   | No              | Root only |
| sum_allreduce  | Scatter, Allreduce              | Full array on root, chunk elsewhere   | No              | Every process |
| sum_scan       | Scatter, Scan                   | Full array on root, chunk elsewhere   | No              | Different prefix per rank |

Expected total for all six programs: 500000500000.

Performance runs
----------------

The requested timing runs use 2, 4, and 8 processes. They could not be run
in the current environment because neither `mpicc` nor `mpirun` is installed.
No execution times are reported rather than inventing measurements. On a host
with MPI installed, run `make benchmark` to collect the timing output for every
program at each process count. For the assignment's four-process run, use
`make run`.

The fastest approach cannot be determined without measurements on the target
MPI implementation and hardware. The Scatter variants avoid replicating the
entire input at every process. Reduce and Allreduce avoid root's serial
point-to-point collection, while Gather still has a root summation step.
Communication startup cost and the MPI implementation influence actual
timings, especially for this relatively small computation.

Thinking question
-----------------

Use MPI_Scan when each process needs the aggregate of all preceding processes,
not just the global total. For example, distributed output partitions can use
`sum_before_me` as a global offset when assigning positions to elements in
rank order.
