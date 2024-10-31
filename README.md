# I2C-SPI Bridge Adapter

## What's Included
- RTL
- UVM Testbench
- Run Script
- SPI Memory File

## Run Script

The run script (Makefile) for this testbench can be found in the `sim` folder. The testbench was designed to run in VCS, so make sure the environment variables are set for Synopsys tools before attempting to run.

The `make` command will compile the testbench and run the simulation in batch mode.

Alternatively, you can compile and run the simulation separately.


### Compile Only 

To compile the testbench only and generate the `simv` file, run the following make target:

```
$ make compile_uvm
```

### Run (Batch Mode)

Once compiled, you can run the simulation in Batch Mode (CLI) by running:

```
$ make run_sim
```

The default values are:
- `SEED=0`
- `TESTNAME=i2cspibridge_sanity_test`
- `VERBOSITY=UVM_LOW`

You can individually customize these values from the command line:

```
$ make run_sim TESTNAME=i2cspibridge_spi_wr_test VERBOSITY=UVM_MEDIUM SEED=100
```

Running in batch mode will generate VCD Plus Files `*.vpd` which can be opened in Verdi or DVE to view the waveforms. The generated `*.vdb` files that will be used for coverage reporting shall have the filename format `<TESTNAME>_<SEED>.vdb`.

### Run (Verdi GUI)

Optionally, once the testbench has been compiled, simv can be run in GUI mode through Verdi. To do that, run the following make target:

```
$ make run_gui
```

The same variables in batch mode can be customized when running through the GUI:

```
$ make run_gui TESTNAME=i2cspibridge_spi_wr_test VERBOSITY=UVM_MEDIUM SEED=100
```

### Generate Coverage Report

To generate the coverage report, run the following make target:

```
$ make report_cov
```

This will merge all `*.vdb` files into one and generate a report based on that.

To open the HTML coverage report, you may use `firefox` or any other web browser available to you:

```
firefox urgReport/dashboard.html
```

Alternatively, you may look at the generated `*.txt` files which contain the same information as the HTML report.

### Clean
To clean up the simulation files, run the following make target:

```
$ make clean
```