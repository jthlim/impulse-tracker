@rem Base1 Driver
tasm /m /ut310 base1
tlink /3 base1
execom base1 itbase1.drv
copy itbase1.drv ..

