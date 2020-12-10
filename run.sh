#! /bin/bash

PROGRAM_NAME="clover"
PERFDIR="./perf_data"

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function clear_intermediate_output() {
    # clean the intermediate output
    if [ -f perf.data ]; then
        rm -f perf.data
    fi
    if [ -f perf.data.old ]; then
        rm -f perf.data.old
    fi
}

function stop_previous_program() {
    # make sure pidof command returns only one value
    while [[ $( pidof ${PROGRAM_NAME} ) ]]; do
        pkill ${PROGRAM_NAME}
        printf "Note: killing previous ${PROGRAM_NAME} program\n"
    done
    printf "\n"
}

function show_profiling_result() {
    sudo chmod a+r perf.data
    if [ ! -d ${PERFDIR} ]; then
        mkdir ${PERFDIR}
    fi
    perf script > ${PERFDIR}/out.perf
    stackcollapse-perf.pl ${PERFDIR}/out.perf > ${PERFDIR}/out.folded
    flamegraph.pl ${PERFDIR}/out.folded > ${PERFDIR}/user.svg
    sensible-browser ${PERFDIR}/user.svg
}

function profiling_and_show_result() {
    # use perf to profiling this program and show the result
    # 'perf record' will always output 'perf.data'
    PID=$( pidof ${PROGRAM_NAME} )
    sudo perf record -F 99 -p ${PID} -g
    show_profiling_result
}

function ctrl_c() {
    stop_previous_program
    show_profiling_result
    clear_intermediate_output
    exit 1
}

main() {
    EXE="./${PROGRAM_NAME}"
    PARAM="-t 0.05"
    SRC1="Zmays_TFBS_clover.txt"
    SRC2="DEGlist115.S02.up.promoter.fa"
    SRC3="Zmays_promoters_1k_nogenepre.fa"
    CMD="${EXE} ${PARAM} ${SRC1} ${SRC2} ${SRC3}"

    if [ $1 == "prof" ]; then
        printf "\nPlease check your Flamegraph installation and add installationDir to PATH!\n"
        printf "https://github.com/brendangregg/FlameGraph"
        printf "\n\nPlease make sure your default browser support svg format!\n\n"

        make

        stop_previous_program

        # run the program
        printf "CMD: ${CMD}\n"
        ${CMD} &
        printf "Program output:\n"

        profiling_and_show_result

        clear_intermediate_output

    # unfinished
    elif [ $1 == "runpart" ]; then
        SRC2_PART="${SRC2}.part"
        SRC3_PART="${SRC3}.part"
        PARTCMD="${EXE} ${PARAM} ${SRC1} ${SRC2_PART} ${SRC3_PART}"

        if [ ! -f ${SRC3}.part ]; then
            python3.7 get_smaller_Zmays.py ${SRC3}
        fi
        
        make
        ${PARTCMD}

    else
        make
        ${CMD}
    fi
}

main $1