# Select UVM_REV
UVM_REV   = '1_1b'

# Add vkit dependencies *in order*
VKITS = [ 
   'cn', 
   'global', 
   'ctx', 
   'alutb',
   ]

# Add testbench flists
FLISTS = [
   'alutb.flist', 
   'rtl.flist',
   ]

# PLI files
PLI_FILES = [
   '/nfs/cacadtools/springsoft/Verdi-201110/share/PLI/VCS/LINUX/novas.tab',
   '/nfs/cacadtools/springsoft/Verdi-201110/share/PLI/VCS/LINUX/pli.a',
   ]
