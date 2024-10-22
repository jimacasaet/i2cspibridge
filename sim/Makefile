PYTHON_PATH := `../tb/dpi && pwd`
C_INC := `../tb/dpi && pwd`
C_SRC := `../tb/dpi && pwd`

VCS_CFLAG := -CC `pkg-config --cflags python3` -CC -I$(C_INC) -CC -D'PYTHON_PATH=\"$(PYTHON_PATH)\"'
VCS_LDFLAG := -LDFLAGS -Wl,--no-as-needed -LDFLAGS `pkg-config --libs python3`

all: clean compile_uvm run_sim

compile_uvm:
	vcs '-timescale=1ns/1ps' -kdb -f rtl_i2cspibridge.f -f tb_i2cspibridge.f -full64 -sverilog -cc cc -assert svaext -full64 -ntb_opts uvm-1.2 -debug_access+all -top tb_i2cspibridge -cm line+cond+fsm+tgl+branch+assert -cm_dir i2cspibridge

compile_uvm_dpi:
	vcs -full64 $(VCS_CFLAG) $(VCS_LDFLAG) $(C_SRC)/c_call_py.c '-timescale=1ns/1ps' -kdb -f rtl_i2cspibridge.f -f tb_i2cspibridge.f -sverilog -cc cc -assert svaext -full64 -ntb_opts uvm-1.2 -debug_access+all -top tb_i2cspibridge -cm line+cond+fsm+tgl+branch+assert -cm_dir i2cspibridge

run_sim:
	./simv -licqueue +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=i2cspibridge_sanity_test +UVM_NO_RELNOTES +UVM_MAX_QUIT_COUNT=100

run_gui:
	./simv -licqueue +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=i2cspibridge_sanity_test +UVM_NO_RELNOTES +UVM_MAX_QUIT_COUNT=100 -verdi

report_cov:
	ls | grep .vdb > list_vdb
	urg -full64 -report merge_rpt -dbname merge.vdb -f list_vdb
	urg -dir ./merge.vdb -format both

clean:
	rm -rf urgReport verdi_config_file simv.daidir csrc simv DVEfiles verdiLog *.key *.h *.log *.vdb *.fsdb *.conf *.rc *.vpd *.vcd .fsm.sch.verilog.xml 