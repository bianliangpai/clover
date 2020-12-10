#! /bin/bash

PROGRAM_NAME="clover"

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
    while [[ $(ps -a | grep ${PROGRAM_NAME}) ]]; do
        pkill ${PROGRAM_NAME}
        printf "Note: killing previous ${PROGRAM_NAME} program\n"
    done
    printf "\n"
}

function ctrl_c() {
    stop_previous_program
    clear_intermediate_output
    exit 1
}

function profiling_and_show_result() {
    # use perf to profiling this program and show the result
    # 'perf record' will always output 'perf.data'
    PERFDIR=$1
    PID=$( pidof ${PROGRAM_NAME} )
    sudo perf record -F 99 -p ${PID}
    sudo chmod a+r perf.data
    if [ ! -d ${PERFDIR} ]; then
        mkdir ${PERFDIR}
    fi
    perf report > ${PERFDIR}/out.perf
    flamegraph.pl ${PERFDIR}/out.perf > ${PERFDIR}/user.svg
    sensible-browser ${PERFDIR}/user.svg
}

main() {
    EXE="./${PROGRAM_NAME}"
    PARAM="-t 0.05"
    SRC1="Zmays_TFBS_clover.txt"
    SRC2="DEGlist115.S02.up.promoter.fa"
    SRC3="Zmays_promoters_1k_nogenepre.fa"
    CMD="${EXE} ${PARAM} ${SRC1} ${SRC2} ${SRC3}"

    if [ $1 == "perf" ]; then
        printf "\nPlease check your Flamegraph installation and add installationDir to PATH!\n"
        printf "https://github.com/brendangregg/FlameGraph"
        printf "\n\nPlease make sure your default browser support svg format!\n\n"

        make

        stop_previous_program

        # run the program
        printf "CMD: ${CMD}\n"
        ${CMD} &
        printf "Program output:\n"

        profiling_and_show_result "./perf_data"

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