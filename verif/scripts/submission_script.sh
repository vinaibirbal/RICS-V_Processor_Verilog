#!/bin/bash
# Author: Nirosh Ratnarajah

echo -e "\n=========================================================================="
echo -e "Ensure sure your project builds before using this script."
echo -e "Run script in pd5/verif/script folder"
echo -e "make run VERILATOR=1 TEST=test_pd\n"
echo -e "Must have file structure <ece320>/project-files, <ece320>/rv32-benchmarks"
echo -e "==========================================================================\n"

uWat_ID='vdbirbal'

# You can change the destination folder for trace output and benchmark folder.
BENCHMARK_FOLDER=${PROJECT_ROOT}/../rv32-benchmarks/simple-programs
TRACE_FOLDER=${PROJECT_ROOT}/project/pd5/verif/sim/verilator/test_pd
SUBMISSION_FOLDER=${PROJECT_ROOT}/project/pd5/verif/${uWat_ID}

# Create the submission folder
rm ${SUBMISSION_FOLDER}/../${uWat_ID}.tar
rm -rf ${SUBMISSION_FOLDER}
mkdir ${SUBMISSION_FOLDER}
mkdir ${SUBMISSION_FOLDER}/txt
mkdir ${SUBMISSION_FOLDER}/vcd

make package VERILATOR=1
mv ./package.verilator.tar.gz ${SUBMISSION_FOLDER}

EXT=d
for i in ${BENCHMARK_FOLDER}/*; do
    if [ "${i}" != "${i%.${EXT}}" ];then
        # Run the benchmark.
        test_file=(`basename ${i%%.d}`)
        echo "Running ${test_file} ..."
        make run VERILATOR=1 TEST=test_pd MEM_PATH=${BENCHMARK_FOLDER}/${test_file}.x VCD=1 &> /dev/null
        mv ${TRACE_FOLDER}/${test_file}.vcd ${SUBMISSION_FOLDER}/vcd
        mv ${TRACE_FOLDER}/${test_file}.trace ${SUBMISSION_FOLDER}/txt
    fi

done

tar -zcvf ${uWat_ID}.tar -C ${SUBMISSION_FOLDER} .
mv ${uWat_ID}.tar ./..
