ssmem
=====

ssmem is a fast and simple object-based memory allocator with epoch-based garbage collection. In other words, the freed memory is not reused by the allocator until it is certain that no other threads might be accessing that memory. ssmem can for example be used in lock-free data structures, where the removal of an element from the structure might happen while other threads are holding a reference to the same element.

You can create multiple allocators with ssmem, however, each allocator can handle a single object size. For example, you can create an ssmem allocator to *always* allocate and release 64 bytes memory chunks.

* Website             : http://lpd.epfl.ch/site/ascylib
* Author              : Vasileios Trigonakis <vasileios.trigonakis@epfl.ch>
* Related Publications: ssmem was developed for:
  Asynchronized Concurrency: The Secret to Scaling Concurrent Search Data Structures,
  Tudor David, Rachid Guerraoui, Vasileios Trigonakis (alphabetical order),
  ASPLOS '15


Installation
------------

Execute `make` in the ssmem base folder.
This should compile `libssmem.a` and `ssmem_test`.

`ssmem_test` contains a few tests for verifying the correctness and testing the performance of ssmem.

Execute: `ssmem_test -h` for the available options.

If you want to customize the installation of ssmem, you can add a custom configuration for a platform in the `Makefile`.

You can also compile with `make VERSION=DEBUG` to generate a debug build of ssmem.

Using ssmem
-----------

To use ssmem you need to include `ssmem.h` and link with `-lssmem`.
`ssmem.h` contains the interface of ssmem.

In short, you can:
   * `ssmem_alloc_init`, or `ssmem_alloc_init_fs_size` to initialize and allocator
   * `ssmem_term` to terminate ssmem
   * `ssmem_alloc` to allocate memory
   * `ssmem_free` to free memory (when it is safe, within the allocator)
   * `ssmem_release` to free memory (when it is safe, to the system -- with `free`)

Refer to `ssmem.h` for more details and operations. 

Details
-------

Each thread holds a version/timestamp number. This timestamp is incremented every time the thread takes some steps with ssmem (i.e., either allocates, or frees memory). ssmem batches multiple frees together (in a free set) and once the set is full, it tries to garbage collect memory. The free set is timestamped with a vector clock (an array of the timestamps from all threads). The garbage collection (reclamation of the freed memory) decides if a free set is safe to release (i.e., whether all threads had made progress since it was timestamped) and if it is, it makes the memory of this (and of "older") free sets available to the allocator.
