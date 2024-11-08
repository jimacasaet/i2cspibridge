# I2C-SPI Bridge Adapter

## What's Included
- RTL
- UVM Testbench
- Run Script
- SPI Memory File

## Run Script

The run script (Makefile) for this testbench can be found in the `sim` folder. The testbench was tested to run in VCS and Xcelium, so make sure the environment variables are set for the specific tool before attempting to run. 

The default simulator used is VCS. This can be changed by passing the `TOOL` argument.

```
$ make TOOL=xcelium
```

The `make` command will compile the testbench and run the simulation in batch mode.

Alternatively, you can compile and run the simulation separately.


### Compile Only 

To compile the testbench only and generate the `simv` file (VCS) or snapshot (Xcelium), run the following make target (specify `TOOL` argument for Xcelium):

```
$ make compile_uvm
```

### Run (Batch Mode)

Once compiled, you can run the simulation in Batch Mode (CLI) by running:

```
$ make run_batch
```

The default values are:
- `SEED=0`
- `TESTNAME=i2cspibridge_sanity_test`
- `VERBOSITY=UVM_LOW`
- `TOOL=vcs`

You can individually customize these values from the command line:

```
$ make run_batch TESTNAME=i2cspibridge_spi_wr_test VERBOSITY=UVM_MEDIUM SEED=100 TOOL=xcelium
```

For VCS, running in batch mode will generate VCD Plus Files `*.vpd` which can be opened in Verdi or DVE to view the waveforms. The generated `*.vdb` files that will be used for coverage reporting shall have the filename format `<TESTNAME>_<SEED>.vdb`.

For Xcelium, running in batch mode will generate `*.trn` files which can be opened in SimVision. Coverage folders for each testcase/seed are located in the `cov_work/scope/` folder.

### Run (GUI Mode)

Optionally, once the testbench has been compiled, simulation can be run in GUI mode through Verdi (Synopsys) or SimVision (Cadence). To do that, run the following make target:

```
$ make run_gui
```

The same variables in batch mode can be customized when running through the GUI:

```
$ make run_gui TESTNAME=i2cspibridge_spi_wr_test VERBOSITY=UVM_MEDIUM SEED=100 TOOL=xcelium
```

### Generate Coverage Report

#### VCS
To generate the coverage report, run the following make target:

```
$ make report_cov
```

This will merge all `*.vdb` files into one and generate a report based on that.

To open the HTML coverage report, you may use `firefox` or any other web browser available to you. 
The coverage report wil be in the `urgReport` folder.

```
firefox urgReport/dashboard.html
```

Alternatively, you may look at the generated `*.txt` files which contain the same information as the HTML report.

#### Xcelium

To generate the coverage report, run the following make target:

```
$ make report_cov TOOL=xcelium
```

### Clean
To clean up the simulation files, run the following make target:

```
$ make clean
```