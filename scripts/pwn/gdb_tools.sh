mkdir ${HOME}/.gdb_plugin
git clone https://github.com/longld/peda.git ${HOME}/.gdb_plugin/peda
git clone https://github.com/pwndbg/pwndbg ${HOME}/.gdb_plugin/pwndbg

cd ${HOME}/.gdb_plugin/pwndbg
./setup.sh
cd -


GDBINIT_SETTING="
define v8-break
    b v8::base::ieee754::sin
end

define job
    call (void) _v8_internal_Print_Object((void*)($arg0))
end

define _peda
    source ~/.gdb_plugin/peda/peda.py
end

define _peda-heap
    source ~/.gdb_plugin/peda-heap/peda.py
end

define _pwndbg
    source ~/.gdb_plugin/pwndbg/gdbinit.py
end

define gef
end
"
echo -e ${GDBINIT_SETTING//$'\n'/\\n} > ~/.gdbinit