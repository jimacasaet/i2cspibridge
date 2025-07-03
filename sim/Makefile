PYTHON_PATH := $(shell cd ../tb/dpi && pwd)
C_INC := $(shell cd ../tb/dpi && pwd)
C_SRC := $(shell cd ../tb/dpi && pwd)
TESTNAME := i2cspibridge_sanity_test
VERBOSITY := UVM_LOW
SEED := 0
TOOL := vcs

VCS_CFLAG := -CC $(shell pkg-config --cflags python3) -CC -I$(C_INC) -CC -D'PYTHON_PATH=\"$(PYTHON_PATH)\"'
VCS_LDFLAG := -LDFLAGS -Wl,--no-as-needed -LDFLAGS $(shell pkg-config --libs python3)

all: clean compile_uvm run_batch

compile_uvm:
ifeq ($(TOOL), vcs)
	vcs '-timescale=1ns/1ps' -kdb -f rtl_i2cspibridge.f -f tb_i2cspibridge.f -full64 -sverilog -cc cc -assert svaext -full64 -ntb_opts uvm-1.2 -debug_access+all -top tb_i2cspibridge -cm line+cond+fsm+tgl+branch+assert -cm_dir $(TESTNAME)_$(SEED) +define+COV +define+UVM_NO_DEPRECATED
else ifeq ($(TOOL), xcelium)
	xrun -64bit -elaborate -O2 -uvm -lic_used -sv -sysv -f tb_i2cspibridge.f -f rtl_i2cspibridge.f -uvmhome `xmroot`/tools/methodology/UVM/CDNS-1.2 -clean -vtimescale 1ns/10ps -top tb_i2cspibridge -access +rwc -coverage all -setenv CADENCE_ENABLE_AVSREQ_63188_PHASE_1=1 -setenv CADENCE_ENABLE_AVSREQ_44905_PHASE_1=1 +define+UVM_NO_DEPRECATED
else
	@echo "Invalid sim tool. Available options are 'vcs' and 'xcelium'."
endif

compile_uvm_dpi:
	vcs -full64 $(VCS_CFLAG) $(VCS_LDFLAG) $(C_SRC)/c_call_py.c '-timescale=1ns/1ps' -kdb -f rtl_i2cspibridge.f -f tb_i2cspibridge.f -sverilog -cc cc -assert svaext -full64 -ntb_opts uvm-1.2 -debug_access+all -top tb_i2cspibridge -cm line+cond+fsm+tgl+branch+assert -cm_dir $(TESTNAME)_$(SEED) +define+COV

run_batch:
ifeq ($(TOOL), vcs)
	./simv -licqueue +ntb_random_seed=$(SEED) +UVM_VERBOSITY=$(VERBOSITY) +UVM_TESTNAME=$(TESTNAME) +UVM_NO_RELNOTES +UVM_MAX_QUIT_COUNT=100 +UVM_NO_DEPRECATED -cm line+cond+fsm+tgl+branch+assert -cm_dir $(TESTNAME)_$(SEED)
else ifeq ($(TOOL), xcelium)
	xrun -64bit -R +UVM_VERBOSITY=$(VERBOSITY) +UVM_TESTNAME=$(TESTNAME) +UVM_NO_RELNOTES +UVM_MAX_QUIT_COUNT=100 +UVM_NO_DEPRECATED -coverage all -covtest $(TESTNAME)_$(SEED) -covoverwrite
else
	@echo "Invalid sim tool. Available options are 'vcs' and 'xcelium'."
endif

run_gui:
ifeq ($(TOOL), vcs)
	./simv -licqueue +ntb_random_seed=$(SEED) +UVM_VERBOSITY=$(VERBOSITY) +UVM_TESTNAME=$(TESTNAME) +UVM_NO_RELNOTES +UVM_MAX_QUIT_COUNT=100 +UVM_NO_DEPRECATED -cm line+cond+fsm+tgl+branch+assert -cm_dir $(TESTNAME)_$(SEED) -verdi
else ifeq ($(TOOL), xcelium)
	xrun -64bit -R +UVM_NO_DEPRECATED +UVM_VERBOSITY=$(VERBOSITY) +UVM_TESTNAME=$(TESTNAME) +UVM_NO_RELNOTES +UVM_MAX_QUIT_COUNT=100 -gui
else
	@echo "Invalid sim tool. Available options are 'vcs' and 'xcelium'."
endif

report_cov:
ifeq ($(TOOL), vcs)
	ls | grep .vdb > list_vdb
	urg -full64 -report merge_rpt -dbname merge.vdb -f list_vdb
	urg -dir ./merge.vdb -format both
else ifeq ($(TOOL), xcelium)
	imc -exec
else
	@echo "Invalid sim tool. Available options are 'vcs' and 'xcelium'."
endif

clean:
	rm -rf urgReport verdi_config_file simv.daidir csrc simv DVEfiles verdiLog *.key *.h *.log *.vdb *.fsdb *.conf *.rc *.vpd *.vcd *.trn *.dsn .fsm.sch.verilog.xml