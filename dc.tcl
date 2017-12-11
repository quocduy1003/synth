define_design_lib WORK -path ./WORK
set DESIGN_NAME "floating_point_multiple"

set REPORTS_DIR "reports"
set RESULTS_DIR "results"

set bus_inference_style {%s[%d]}
set bus_name_style {%s[%d]}

#define_name_rule name_rule -allowed "A-Z a-z 0-9_" -max_length 255 -type cell
#define_name_rule name_rule -allowed "A-Z a-z 0-9_[]" -max_length 255 -type net
#define_name_rule name_rule -map {{"\\*cell\\*" "cell"}}
#define_name_rule name_rule -case_insensitive

file mkdir ${REPORTS_DIR}
file mkdir ${RESULTS_DIR}

set RTL_SOURCE_FILES   "[sh find ./input/ -name *.v]"

set_app_var search_path "../libs/models"
set_app_var target_library "saed90nm_max.db"
set_app_var link_library "saed90nm_max.db saed90nm_min.db saed90nm_typ.db"

analyze -format verilog ${RTL_SOURCE_FILES} -autoread -top floating_point_multiple
#read_verilog -rtl ${RTL_SOURCE_FILES}
elaborate ${DESIGN_NAME}

read_sdc floating_point_multiple.sdc

check_design -summary
check_design > ${REPORTS_DIR}/${DESIGN_NAME}.check_design.rpt

compile 

change_names -rules verilog -hierarchy

write -format verilog -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}.mapped.v
write_sdc -nosplit ${RESULTS_DIR}/${DESIGN_NAME}.mapped.sdc 

report_power -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}_power.rpt
report_clock_gating -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}_clock_gating.rpt
report_area -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}_area.rpt
report_timing -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}_timing.rpt

exit
