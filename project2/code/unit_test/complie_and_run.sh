if iverilog "${1}" "unit_test/t_${1}" -o "./unit_test/$(basename ${1} .v).out"; then
    vvp "./unit_test/$(basename ${1} .v).out"
    rm  "./unit_test/$(basename ${1} .v).out"
fi
