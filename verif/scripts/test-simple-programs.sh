#!/bin/bash

### Author: Nirosh Ratnarajah
### File: test-simple-programs.sh

echo -e "\n=========================================================================="
echo -e "Ensure sure your project builds before using this script."
echo -e "make run VERILATOR=1 TEST=test_pd\n"
echo -e "Must have file structure <ece320>/project-files, <ece320>/rv32-benchmarks"
echo -e "==========================================================================\n"

# You can change the destination folder for trace output and benchmark folder.
BENCHMARK_FOLDER=${PROJECT_ROOT}/../rv32-benchmarks/simple-programs
TRACE_FOLDER=${PROJECT_ROOT}/project/pd5/verif/sim/verilator/test_pd/

# Regex pattern for pass condition for individual instructions.
pat='(.*) <pass>:'

passCount=0
failCount=0
failedArr=()

EXT=d
for i in ${BENCHMARK_FOLDER}/*; do
    if [ "${i}" != "${i%.${EXT}}" ];then
        # Run the benchmark.
        test_file=(`basename ${i%%.d}`)
        echo "Running ${test_file} ..."
        make run VERILATOR=1 TEST=test_pd MEM_PATH=${BENCHMARK_FOLDER}/${test_file}.x &> /dev/null

        # Get the PC address of the pass jump.
        test=$(grep -E "<pass>:" ${BENCHMARK_FOLDER}/${test_file}.d)
        [[ $test =~ $pat ]]
        end_pc="${BASH_REMATCH[1]}"

        # If the pass PC is in the trace file, we pass, otherwise fail.
        if grep -q "\[W\] ${end_pc}" ${TRACE_FOLDER}/${test_file}.trace; then
            ((passCount=passCount+1))
            rm ${TRACE_FOLDER}/${test_file}.trace
        else
            failedArr+=("${test_file}")
            ((failCount=failCount+1))
        fi

    fi
done

# Print out the summary of unit tests.
echo -e "\nPassed ${passCount} tests"
echo -e "Failed ${failCount} tests\n"

if [[ "${failCount}" -ne "0" ]]; then
    echo "FAILED"

    for value in "${failedArr[@]}"; do
        echo "    $value"
    done
else
    echo "Passed all tests!"
fi

echo -e "==========================================================================\n"

#!/bin/bash

### Author: Nirosh Ratnarajah
### File: test-individual-instructionssimple-programs.sh

echo -e "\n=========================================================================="
echo -e "Ensure sure your project builds before using this script."
echo -e "make run VERILATOR=1 TEST=test_pd\n"
echo -e "Must have file structure <ece320>/project-files, <ece320>/rv32-benchmarks"
echo -e "==========================================================================\n"

# You can change the destination folder for trace output and benchmark folder.
BENCHMARK_FOLDER=${PROJECT_ROOT}/../rv32-benchmarks/individual-instructions
TRACE_FOLDER=${PROJECT_ROOT}/project/pd5/verif/sim/verilator/test_pd/

# Regex pattern for pass condition for individual instructions.
pat='(.*) <pass>:'

passCount=0
failCount=0
failedArr=()

EXT=d
for i in ${BENCHMARK_FOLDER}/*; do
    if [ "${i}" != "${i%.${EXT}}" ];then
        # Run the benchmark.
        test_file=(`basename ${i%%.d}`)
        echo "Running ${test_file} ..."
        make run VERILATOR=1 TEST=test_pd MEM_PATH=${BENCHMARK_FOLDER}/${test_file}.x &> /dev/null

        # Get the PC address of the pass jump.
        test=$(grep -E "<pass>:" ${BENCHMARK_FOLDER}/${test_file}.d)
        [[ $test =~ $pat ]]
        end_pc="${BASH_REMATCH[1]}"

        # If the pass PC is in the trace file, we pass, otherwise fail.
        if grep -q "\[W\] ${end_pc}" ${TRACE_FOLDER}/${test_file}.trace; then
            ((passCount=passCount+1))
            rm ${TRACE_FOLDER}/${test_file}.trace
        else
            failedArr+=("${test_file}")
            ((failCount=failCount+1))
        fi

    fi
done

# Print out the summary of unit tests.
echo -e "\nPassed ${passCount} tests"
echo -e "Failed ${failCount} tests\n"

if [[ "${failCount}" -ne "0" ]]; then
    echo "FAILED"

    for value in "${failedArr[@]}"; do
        echo "    $value"
    done
else
    echo "Passed all tests!"
fi

echo -e "==========================================================================\n"
