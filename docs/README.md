# PD5

In this PD, you are required to pipeline your design in PD4.
You will also need to develop a testbench.

## Probes

You will need to fill in the `signals.h` in this PD for the probes.

Please note that unlike in PD0, we only **monitor** these probes instead of driving the probes.

## Tests

Make sure you pass the `test_pd` test.

## Testbench

You will need to update your own testbench as specified in the project manual.

Make sure that your design will not report any warning during compilation.

Make sure your testbench correctly when running with different `MEM_PATH` supplied to the `make` command.

For iverilog, the command would be `make run IVERILOG=1 TEST=test_pd MEM_PATH=/path/to/memory.x`.

For verilator, the command would be `make run VERILATOR=1 TEST=test_pd MEM_PATH=/path/to/memory.x`.

For verilator users, you may use `make run VERILATOR=1 TEST=test_pd MEM_PATH=/path/to/memory.x VCD=1` to get a `.vcd` file in `project/pd5/verif/sim/verilator/test_pd/`. 
Please be aware that `$dumpfile` and `$dumpvars` are not supported in verilator installed on ECE Linux Servers and calling them can lead to compilation errors.



## Synthesis

For this PD, when you finish your design you will be able to test your code for synthesizability.

To test the synthesizability of your code, go to `project/pd5/build/scripts` and execute `make synthesis-test`.

A successfully synthesis should produce a `design.dcp` in `project/pd5/build/scripts`.

You will need to have `Vivado` installed for this purpose.

## Submission

In `project/pd5/verif/scripts/`, use `make package YOUR_SIM=1` to package your code.

If you use `iverilog`, use `make package IVERILOG=1` to create a `package.iverilog.tar.gz`

If you use `verilator`, use `make package VERILATOR=1` to create a `package.verilator.tar.gz`

You will need to upload the `package.*.tar.gz` to learn when done.

Note that you must set your simulator properly as the package name will include
information about the simulator you are using.
The tests may fail if you are not providing the proper simulator name.

